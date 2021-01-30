require 'json'
require 'jekyll'
require 'aws-sdk-s3'

def handler(event:, context:)
    { event: JSON.generate(event), context: JSON.generate(context.inspect) }
    puts [event, context]
    s3 = Aws::S3::Client.new
    dir = String::new
    
    #system('rm -rf /tmp/*')
    

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
    		system("mkdir -p /tmp/#{dir}")
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
    

    Dir.chdir('/tmp/_site')
    list=Dir["**/*.*"]
    
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
    
    system('cd /tmp/_site')
    s3u = Aws::S3::Resource.new
    
    
    numList=list.length
    while numList>0 do
    	numList=numList-1

    	if list[numList].end_with?(".svg")
        	resp=s3.put_object({
            	body: File.read("#{list[numList]}"),
            	acl: "public-read",
            	bucket: "#{ENV['WWW']}",
            	key: "#{list[numList]}",
            	content_type: "image/svg+xml",
        	})
        else
        	resp=s3.put_object({
        	    body: File.read("#{list[numList]}"),
            	acl: "public-read",
            	bucket: "#{ENV['WWW']}",
            	key: "#{list[numList]}",
        	})
        end
    	
    end
    
    Dir.chdir("/tmp")
    system('pwd')
    system('ls | grep -v "_config.yml" | xargs rm -r')
    system('ls -r /tmp')
    
    


end