# AWS-Jekyll
(readme.md is WIP)

This project uses [Jekyll](https://jekyllrb.com) and [Amazon Web Services](https://aws.amazon.com) to make static websites without the necessity of instaling Ruby on your PC. 



### Files:
**cfTemplate.yaml**- CloudFormation template. The only parameter is domain name (without www).

**ruby.zip**- lambda layers. All ruby gems AWS Lambda needs, to run Jekyll.

**www_function.rb**- lambda function code. Just copy paste it into the lambda console :)


## How it works:
![Template](img/CF.png)

Here are all the AWS Components that CloudFormation is making. **StagingUser** with **StagingUserKeys** is able to manage **StageBucket**.

This bucket contains all the assets needed to create a static site. When something gets added to the bucket, **CreateWWWStageBucketEventPermission** triggers **CreateWWW**. This function with **CreateWWWRole** and **CreateWWWRubyLayer9cca5ad8ec** (containing ruby gems such as Jekyll etc.) downloads content from StageBucket, executes Jekyll and outputs finished site to **WWWBucket1**. **WebsiteBucketPolicy** makes the final bucket public for all making the site reachable to everyone. **WWWBucket2** is an empty bucket that redirects all the traffic to WWWBucket1. 

The last components are **WWWZone**, **WWWRec1** and **WWWRec2** (Route53 hosted zone and records needed to attach DNS to our site). WWWRec1 attaches WWWBucket1 and WWWRec2 ties WWWBucket2 with the hosted zone. 

The template requires one parameter which is simply your DNS. For example, if the parameter is 'domain.com', all the traffic from domain.com address is connecting directly to WWWBucket1 and address www.domain.com goes through WWWBucket2

## Work in progress:
I'm working on a web editor for the site using AWS Lambda, Cognito and API Gateway.
