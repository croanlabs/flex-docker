# flex-docker
Docker Compose Stacks for Flex Product

## Overview

This project contains [Docker compose](https://docs.docker.com/compose/) stacks for starting a local Flex environment and deploying it to the AWS cloud.

## Setup

### Docker Engine

Setup the docker engine on your development machine as described in the [Docker Manual](https://docs.docker.com/engine/installation/)

### AWS Docker Registry

Images for Flex components are pushed to a private registry provided by Amazon Container Services. 
To access the registry, users must have an Amazon IAM account and must be logged in.

#### MacOS

    brew install awscli
    aws configure
    $(aws ecr get-login --region eu-central-1)

If you have multiple AWS accounts then use the [profile option](http://docs.aws.amazon.com/cli/latest/userguide/cli-multiple-profiles.html). 
    
### IntelliJ Docker Plugin
    
The [IntelliJ Docker plugin](https://www.jetbrains.com/help/idea/2016.3/docker.html) makes it easier to keep an overview of running containers, inspect them, and run commands in individual containers.

#### MacOS

Install the Docker Plugin via `Settings > Plugins`. To connect IntelliJ to Docker for Mac, you might need to use [a workaround](https://blog.dekstroza.io/osx-docker-beta-intellj-playing-nicely/):

    socat -d TCP-LISTEN:2376,range=127.0.0.1/32,reuseaddr,fork UNIX:/var/run/docker.sock &

## Local Development

At this point you need to have logged into AWS via the CLI. The command is 
    
    aws ecr get-login --region eu-central-1    

This will produce the docker login command, execute it and then you will have access to the EC2
docker registry.

### Start

Start the compose stack:

    docker-compose up --build -d
    
Check the logs:
    
    docker-compose logs -f
    
### Test Local Setup

*GET* https://localhost:3000/ -> Gets you the nginx landing page

*GET* http://localhost:3000/webapi/greetings -> Web API call
 
At the moment, we are using self signed certificates, so your browser will complain about how
trustworthy the certificates are, accept the risk and proceed.    
   
### Stop

Stop Containers:

    docker-compose stop
    
### Cleanup

Stop and remove containers and volumes:

    docker-compose down -v
    
Stop and remove containers, volumes, and images:

    docker-compose down -v --rmi local --remove-orphans

## Deployment to AWS

Deployment to AWS is done with [Docker Machine](https://docs.docker.com/machine/). 

On a lightsail machine it is slightly different to when you use the EC2 services e.g [AWS Example](https://docs.docker.com/machine/drivers/aws/) 
and [AWS Driver](https://docs.docker.com/machine/examples/aws/).

To use docker machine, we need to connect over ssh. Read [this article](http://www.kevinkuszyk.com/2016/11/28/connect-your-docker-client-to-a-remote-docker-host/) article on how 
to connect your docker client to a remote docker host over ssh. First recommend connecting to the machine just over ssh first and then trying to get the docker client to connect.

TODO script when we have the proper machine static IP

### Depoyments Start

Once you have your docker machine setup in place you need to point your local docker to the remote machine
    
Point docker to the remote machine:
    
    eval $(docker-machine env $REMOTE_HOST_NAME)
    
$REMOTE_HOST_NAME is what you should have already setup with your docker machine setup.

### Bring up environment
Once your docker machine is connected, to bring up the environment then you can execute 

    docker-compose -f docker-cloud-compose.yml up --force-recreate --build -d
     
Once fired up you can check the logs
     
Check the logs:    
    
    docker-compose logs -f
    
### Stop    

Stop and remove containers and volumes:

    docker-compose down -v
    
Stop and remove containers, volumes, and images:
    
    docker-compose down -v --rmi local --remove-orphans
    
    
## Implementation Notes
   
### Multiple compose files

Flex product uses two different stacks to represent local and cloud environments: 

- `docker-compose.yml`
- `docker-cloud-compose.yml`

The main reason is that we [cannot use](http://stackoverflow.com/questions/30040708/how-to-mount-local-volumes-in-docker-machine) local directories as configuration volumes for containers 
when docker-machine is used to provision a remote host.

The following compose configuration, for instance, would *not* work with a remote machine:

    nginx:
      image: openresty/openresty:alpine
      volumes:
        - ./nginx/ssl/:/etc/ssl/

For local development, it makes perfect sense to share sources and configuration between host and container. For remote deployments, however,
a different approach has to be used. There are [quite a few options](https://dantehranian.wordpress.com/2015/03/25/how-should-i-get-application-configuration-into-my-docker-containers/)
for getting configuration into containers.

For Flexer, configuration is baked into containers as part of the compose stack.
   
### AWS Lightsail Setup

Setting up docker on the lightsail machine I followed the following resources

   * [Docker on Lightsail](https://davekz.com/docker-on-lightsail/)
   * [Danhaywood Docker on Lightsail](http://www.danhaywood.com/2016/12/21/lightsail-and-docker/)

At this time, Docker on lightsail is [not a first class citizen](https://forums.aws.amazon.com/thread.jspa?messageID=772098) from amazon.  

To deploy with docker compose and docker machine I followed the followng guide    

   * [Connect to a remote docker host](http://www.kevinkuszyk.com/2016/11/28/connect-your-docker-client-to-a-remote-docker-host/)

## Resources

### Recommended Reading

- [Docker In Action](https://www.manning.com/books/docker-in-action)
- [DevOps 2.0 Toolkit](https://leanpub.com/the-devops-2-toolkit)
- [Deploy to amazon using docker-machine and docker compose](https://github.com/julianespinel/stockreader/wiki/Deploy-to-AWS-using-docker-machine-and-docker-compose)
