require 'json'
require 'jekyll'
require 'aws-sdk-s3'
require 'fileutils'

def handler(event:, context:)
    { event: JSON.generate(event), context: JSON.generate(context.inspect) }
    puts [event, context]
    
    s3 = Aws::S3::Client.new
    dir = String::new

    string = s3.list_objects_v2({
    	bucket: "#{ENV['STAGING']}"
    })

    num=string.key_count
    while num>0 do
	    num=num-1
	    dir = string.contents[num].key.dup
    	if dir.include? "/"
    		l=dir.length
    		while l>0 do
    			l=l-1
    			if dir[l] == "/"		
    			dir.slice!(l..dir.length)
    			break
    			end
    		end
    		FileUtils.mkdir_p "/tmp/#{dir}"
    	end
    	resp = s3.get_object({
	    	bucket: "#{ENV['STAGING']}",
		    key: "#{string.contents[num].key}",
		    response_target: "/tmp/#{string.contents[num].key}",
	    })
    end

    conf = Jekyll.configuration({
        'source'      => "/tmp",
        'destination' => "/tmp/_site"
    })

    Jekyll::Site.new(conf).process
    

    FileUtils.cd("/tmp/_site")
    list=Dir["**/*.*"]
    
    
    FileUtils.cd("/var/task")
    check = s3.list_objects_v2({
    	bucket: "#{ENV['WWW']}"
    })

    del=Array.new
    for i in 0...check.key_count
        del[i]=check.contents[i].key.dup
    end
    for i in 0...list.length
        for j in 0...del.length
            if list[i].eql? del[j]
                del.delete_at(j)
                break
            end
            j=j+1
        end
        i=i+1
    end
    
    numDel=del.length
    while numDel>0 do
        numDel=numDel-1
        rmv=s3.delete_object({
            bucket: "#{ENV['WWW']}",
            key: "#{del[numDel]}",
        })
    end
    
    FileUtils.cd("/tmp/_site")
    s3u = Aws::S3::Resource.new
    
    numList=list.length
    while numList>0 do
    	numList=numList-1
    	obj = s3u.bucket("#{ENV['WWW']}").object("#{list[numList]}")
    	obj.upload_file("#{list[numList]}")
    	resp=s3.put_object_acl({
    	acl: "public-read",
    	bucket: "#{ENV['WWW']}",
    	key: "#{list[numList]}",
    	})
    	
    end
    system('rm -r /tmp/*')
    
end
