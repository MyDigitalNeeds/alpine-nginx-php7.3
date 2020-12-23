# alpine-nginx-php7.3

![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/nickmaietta/alpine-nginx-php73)

Build PHP websites with this simple workflow toolchain kit. Includes instructions and small config for simple, effortless automated deployments for Docker Swarms using Caprover.

Radpidly build and test PHP websites with this simple workflow using the power of Docker. Includes instructions for effortless automated deployments for Docker Swarms using Caprover.
The PHP enviornment includes the recommended packages to run most popular web application frameworks including Fat Free Framework, Laravel, Slim, etc. The Linux enviornment is a bare bones Alpine Linux distrobution and the webserver is a stock Nginx 1.18 configuration.

This package also includes that is used during the automated build process:

 * Git
 * Composer

Prerequisites
-----

I assume you have installed Docker and it is running.

See the [Docker website](http://www.docker.io/gettingstarted/#h_installation) for installation instructions.

Build
-----

Steps to deploy your website locally:

1. Copy the Dockerfile, docker-compose.yml, composer.json files into your project's root directory. (The files in configs/ are for your inspection but are not used in your project, so they are safe to discard)

        git clone https://github.com/cb372/docker-sample.git

2. Fetch a copy of your website's files and place them in the src/ directory.

3. Start the docker service using Docker Compose. (Not be confused with Composer, which is for PHP dependency management)

        docker-compose up -d
		
	This could take a few minutes on the first run. Be patient.

Once everything has started up, you should be able to access the webapp via [http://localhost/](http://localhost/) on your host machine.

        open http://localhost/

You can also login to the image and have a look around:

    docker run -i -t name_of_running_container /bin/sh
	
	
Steps to setup automated deployments with a Docker Swarm running Caprover:

1.) Make sure your project is held in it's own Git Repository inside Gitlab, Github, Bitbucket or any other Git hosting solution.

2.) From your project's root directory, create a deployment key-pair with the SSH command or another utility and give it the name "deploy_keys".

	ssh-keygen -t rsa -c "you@email.com"
	
3.) Distribute the keypair between Caprover and Gitlab.

	If you haven't already done so, create a new App in Caprover. In the Deployment tab, choose "Method 3" and provide the private key from the "deploy_keys" file, the URL to your Git repo and save your changes.

	After clicking "Save", you will be issued a Webhook URL that will need to be added to your project's settings inside Gitlab, Bitbucket etc.
	
	In Gitlab, find the section for "Deploy Keys" and add your the contents of the "deploy_keys.pub" public key file you previously generated.
	
4.) Copy your Caprover generated Webhook to your projects hosted Git settings under the "Webhooks section". If asked for a secret token, copy the token portion from the URL, omitting the token= from the string.

5.) Test the automated deployments by commiting and pushing your local changes back to your hosted Git repo.

If all goes well, you can proceed to focus on building your website.