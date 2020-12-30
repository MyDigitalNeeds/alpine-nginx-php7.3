# The Development Workflow Strategy
### A general guide for building, testing and deploying applications with a system built around Docker, Gitlab and Caprover.

![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/nickmaietta/alpine-nginx-php73)

In this work flow, you will work on your PHP website project lcoally on your machine, then push your committed changes to Gitlab. In turn, Caprover will be notified and will build a fresh container image of your project and deploy it for the world to see.

In this workflow strategy, you will work on a local copy of your PHP website and commit your changes as you make progress in development. When you are satisfied with your changes and are ready to redeploy those changes, you will "push" your local commit history back to Gitlab where your project is centrally tracked. This "push" action will trigger a webhook that notifies Caprover that it's time to redeploy your application with the latest changes you've provided. The webhook will be triggered only for the "main" branch but nothing is stopping you from creating aditional branches for staging or a/b testing in a more advanced workflow. This guide outlines the deployment of the "main" branch to production only.

Your Dev PC <-----> Gitlab <-----> Caprover -----> The World

Prerequisites
-----

For Windows 10 Home users, install Docker according to the most current instructions available at https://docs.docker.com/docker-for-windows/install-windows-home/.

For Windows 10 Professional or Enterprise users, use https://docs.docker.com/docker-for-windows/install/.

For Windows 10, Mac OS X and Linux Desktop users, the following open source tools are tested to work well:
- Docker for Windows with WSL 2 enabled. - 
- Git-SCM - https://git-scm.com/
- VSCode Community Edition- https://code.visualstudio.com/download

SECURITY NOTICE:
  We will avoid the use of passwords to syncronize your project's code between your computer your hosted Git project. Instead of passwords, we use SSH Keypairs. If you have not already done so, you need to create an SSH identity that Gitlab will use to cryptographically identify your machine when pushing changes to your project's Git repository. To generate your keypair, open a suitable Terminal like Git Bash (you just instaled) and issue the following command to generate a ed25519 compatable keypair, providing your email address for the comment.

  > ssh-keygen -t ed25519 -C "you@email.com"

  The new keypair will be stored in a directory in your User's home directory called .ssh/. The contents of the .pub file must be coped into Gitlab. Navigate to your Gitlab Settings page to add your SSH public key.

  For more information about generating and using Gitlab compatible SSH Keys, please take a look at https://docs.gitlab.com/ee/ssh/#ed25519-ssh-keys

Setup your website's DNS
-----
Before you can deploy a live website, you will need to have a domain name pointed to the Name Servers that will be responsible for resolving hostnames to IP addresses. In this example, the domain name "**delnorteclassifieds.com**" is registered with Google Domains but we want to use StackPath as our DNS provider.

In StackPath or other DNS provider, we need to create a new Zone for our domain and then create or edit the A record for the domain name. This "Answer" record needs to point to an IP address assigned by the system administrator. However, if your Domain Registrar happens to also be your DNS provider, a zone will already be available for you to modify. Is is almost certain your Domain Registrar will also offer free DNS servers but using them requires you leave default Name Servers unmodified.

While editing your zone, and if you will be adding the subdomain www, you can create a CNAME entry for it and point it to @. This is completely optional.

The "naked" domain without the www or other subdomain can be referenced with an @ symbold. During initial testing, it's advised to set the TTL to a few minutes and adjust this number to a reasonable number when you are certain things are working as expected.

To summarize, at minimum you will need an "A" type record with the name @ pointed to a valid IP address responsible for serving your website.

![Create or edit DNS zone](/gfx/workflow/create_zone.png)

Typically with DNS providers, they will issue Name Servers after you create a zone record. These name servers will need to be provided to your Domain Registrar. In this example, Google Domains has been updated with the name servers as provided by StackPath.

![Update your name servers](/gfx/workflow/set_nameservers.png)

Once this action has been taken, you may be forced to wait a while for DNS to propogate across the internet. Typically the changes will happen within a few minutes but in some cases, your ISP, router or computer may "remember" a previous setting and won't look for the changes until the previous TTL number in minutes or hours has been reached. This is why we set TTL's low during testing.



Create A New App in Caprover
-----
Visit the Caprover installation and create a new App using your website's domain name as the app name. Replace any periods with a dash like so:

![Create a new](/gfx/workflow/create_app.png)

Leaving the "Has Persistent Data" option unchecked, proceed to the next page by clicking "Create New App".

Find your app in the list and click it's link. You should now see your app specific settings.

![Connecting domains](/gfx/workflow/connect_domains.png)


Once your domain is succefully added, you can "Enable HTTPS" to get your free SSL issued from LetsEncrypt.

Now you can force HTTPS and turn on support for websockets, then Save those changes.

![Enable and force HTTPS](/gfx/workflow/enable_and_force_ssl.png)

Leaving this browser tab open and reating an new one, we'll start the process of setting up the project repository then come back to this.
![Gitlab stuff goes here](/gfx/workflow/caprover_method_3.png)



Setting up a Project Repository
-----
At the center of our workflow is Git repositories. Gitlab is responsible for notifying Caprover about changes to your codebase.

1) Visit your Gitlab server's web interface and setup a new project if you haven't already done so. Be sure to keep everything organized by creating assinginbg your project to the appropriate group. For example, a website could be in the group "Websites". If you will be creating a project from scratch, choose the option to add a README file so you can immediately clone this repository to your local machine.Follow the instructions most appropriate for your situation.

2) Setup a deployment keypair. Once created, distribute them between Gitlab and Caprover. In Gitlab, copy the contents of the .pub file into your project's Deploy Keys section. In Caprover, copy the contents of private key into the deploy

3) 


Clone your Git project locally and start developing.
-----



If you haven't already done so, you should aside a general "Projects" directory somewhere on your local development machine. I would recommend partitioning some disk space and assigning it a drive letter (Windows) or mountpoint (Linux/Mac). An example of a location could be E:\Projects\ or /home/username/Projects/. This directory should be shared with Docker and you can proactively set this up in the Docker Configuration or Settings/





1) Create a directory in your Projects directory and give it the name of your website's domain name. For example, if your project is mywebsite.net, use that for your directory. Within that new directory, add another directory called "src". When done you should have something that looks like:

     "E:\Projects\mywebsite.net\src\
    
2) Now fetch a copy of the following three files and place them inside your "mywebsite.net" directory.

- https://github.com/maietta/alpine-nginx-php7.3/blob/main/docker-compose.yml
- https://github.com/maietta/alpine-nginx-php7.3/blob/main/captain-definition
- https://github.com/maietta/alpine-nginx-php7.3/blob/main/composer.json

3. Either in VSCode or from the terminal (Git bash)

        docker-compose up -d
		
	This could take a few minutes on the first run. Be patient.

    Docker compose will fetch, build and deploy a local web server running Nginx 1.18, PHP 7.3 and will include a nifty tool called Composer to let you define your PHP project depenencies using the composer.json file. "Composer" is not to be confused with Docker Compose, a utility for composing and running application stacks.

    You are now ready to place your website's files in the src/ directory and begin development.

    PRO TIP: You can type "code ." on the terminal to open VSCode in the current directory. In Windows you can type "start ." to open a file explorer window in the current directory.

Once everything has started up, you should be able to access your local website via [http://localhost/](http://localhost/).

        Open http://localhost/ in your favorite browser.


Publishing your website to the Docker Swarm via Caprover
-----

Caprover offers CLI, API and Web UI to create, manage and monitor Docker Services in a Docker Swarm. We will leverage the docker swarm to deploy an exact copy of your website that will be automatically built and re-deployed on every "Git push" you make to the main branch of your project's repository. Bit first, let's setup the app in Caprover:

Visit your caprover installation Web Interface at https://captain.apps.yourdomain.com.

Setting up Automated Deployments
-----

Caprover offers multiple ways to deploy applications on Docker Swarm. We will use Method 3 