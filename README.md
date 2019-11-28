# AWS-Jekyll

This project uses [Jekyll](https://jekyllrb.com) and [Amazon Web Services](https://aws.amazon.com) to make static websites without the necessity of instaling Ruby on your PC. 



### Files:
**mod_files.msi**- [NSIS](https://nsis.sourceforge.io/Main_Page) script used to create installation files that deploy AWS CLI, config files  and download-upload scripts. OPTIONAL

**ruby.zip**- lambda layers. All ruby gems, aws lambda needs to run Jekyll.

**www_function.rb**- lambda function code. Just copy paste it into the lambda console :)


## How it works:
The project works on 2 s3 bucket- WWW and STAGING. Both buckets contain the website files although STAGING has the site siles in a "raw" form and WWW holds already built site. When in there is a change in the STAGING bucket (for instance, a new file is uploaded), lambda recieves a signal, downloads everything from STAGING, builds the site using the Jekyll gem and uploads finished website on the WWW bucket.
