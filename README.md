# AWS-Jekyll
(readme.md is WIP)

This project uses [Jekyll](https://jekyllrb.com) and [Amazon Web Services](https://aws.amazon.com) to make static websites without the necessity of instaling Ruby on your PC. 



### Files:
**cfTemplate.yaml**- CloudFormation template. The only parameter is domain name (without www).

**ruby.zip**- lambda layers. All ruby gems AWS Lambda needs, to run Jekyll.

**www_function.rb**- lambda function code. Just copy paste it into the lambda console :)


## How it works:
![Template](img/CF.png)
The project works on AWS Lambda and 2 S3 buckets- WWW and STAGING. Both buckets contain the website files although STAGING has the site siles in a "raw" form and WWW holds already built site. When in there is a change in the STAGING bucket (for instance, a new file is uploaded), lambda recieves a signal, downloads everything from STAGING, builds the site using the Jekyll gem and uploads finished website on the WWW bucket.

## Work in progress:
I'm working on a web editor for the site using AWS Lambda, Cognito and API Gateway.
