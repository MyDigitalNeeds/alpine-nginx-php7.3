# The Development Workflow Strategy
### Stream your PHP development and deploy-to-production workflow with this modernized workflow strategy. Designed around Docker, Gitlab and a Docker Swarm managed with Caprover.

![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/nickmaietta/alpine-nginx-php73)

Your Dev PC <-----> Gitlab <-----> Caprover -----> The World

This workflow strategy is designed for the PHP developer but it can be applied to virtually any type of webiste or application development where your code is held in a central Git repository and deployed to a Docker Swarm using Caprover.

Prerequisites
-----

Whether you are using Mac OS X, Linux or Windows 10 Home, Pro or Enterprise editions, this workflow has you covered. The following tools have been selected for cross-platform compatability, stability and community support and is highly recommend

While this guide is designed for Mac OS X, Linux and Windows 10 users, the 

For Windows 10 Home users, install Docker according to the most current instructions available at https://docs.docker.com/docker-for-windows/install-windows-home/.

For Windows 10 Professional or Enterprise users, use https://docs.docker.com/docker-for-windows/install/.



For Windows 10, Mac OS X and Linux Desktop users, the following open source tools are tested to work well:
- Git-SCM - https://git-scm.com/
- VSCode Community Edition- https://code.visualstudio.com/download

SECURITY NOTICE:
  We will avoid the use of passwords to syncronize your project's code between your computer your hosted Git project. Instead of passwords, we use SSH Keypairs. If you have not already done so, you need to create an SSH identity that Gitlab will use to cryptographically identify your machine when pushing changes to your project's Git repository. To generate your keypair, open a suitable Terminal like Git Bash (you just instaled) and issue the following command to generate a ed25519 compatable keypair, providing your email address for the comment.
  
  Generating SSH Keys
  -----
  The task of creating SSH needs only be performed once per each machine you wish to work on your projects from. These keys will be used when your machine communicates with your project's hosted Git repository in Gitlab. If you have not already generated a public and private SSH keypair on your development machine, open a Git bash or other terminal and enter the following in:

  > ssh-keygen -t ed25519 -C "you@email.com"

  Follow the prompts but take note of and leave the default file location path. Hitting enter you will be prompted to optionally provide a password. Once you've done this, a public and private file is saved.

  The contents of the plain text ~/.ssh/ed25519.pub file is your public key. The entire text of this file needs to be added to your Gitlab account in the section called "SSH Keys".

  PRO TIP: Linux users or Windows users using Git bash terminal can simply run the following command to copy the contents of the file directly to the clipboard:

  > cat ~/.ssh/ed25519.pub | clip
  
** INSERT SCREEN GRAB HERE -- Show Gitlab Add SSH Key dialog ***

  For more information about generating and using Gitlab compatible SSH Keys, please take a look at https://docs.gitlab.com/ee/ssh/#ed25519-ssh-keys

Setting up your website's DNS
-----

This step should be done early in your project setup to avoid wait time and it must be completed before you can attach the domain name to Caprover.

If the project domain name's Registrar is also the DNS provider, you may never see the term "DNS Zone" mentioned in their control panel. Instead, you will likely see a section for editing DNS records directly, saving a step. However, if your DNS provider is seperate from your Domain Registrar, you may have to "Create" a zone before you can edit said zone record. This is often confusing to many people so it's worth the mention.


At minimum, an A-type answer record for the "naked" domain name must be present in dns zone record, denoted an @ symbol and pointed to an IP address responsible for serving a copy of your website. During setup and testing, it is advised to set a low TTL value and adjust this to something more reasonable later after you've tested everything. It is also recommended that you add a CNAME entry with a name of "www" pointed to the naked domain, also denoted using @ for the designated value. This is because people will still have a habbit of publishing www as part of their address.

PRO TIP: If your A record is given more than one IP address where your website can be reached, your DNS providers may automatically start taking latency measurements and serve DNS answers with the closest or fastest response time to those who are visitng your website. If your provider does not have these features or capabilities, then it is likely load balancing and DNS level fault tolerances will be handled with the very basic Round-robin method. See Wikipedia's entry discussing Round-robin DNS here: https://en.wikipedia.org/wiki/Round-robin_DNS.

An example of the creation of a new Zone in Stackpath:

![Create or edit DNS zone](/gfx/workflow/create_zone.png)

With your DNS zone record updated, it's time to set your name servers on the domain name if not already done. This is always done at the domain registrar. In this example, we set the name servers issued by StackPath, in the Google Domains control panel:

![Update your name servers](/gfx/workflow/set_nameservers.png)

Just like DNS records themselves, Name Servers, once set, need time to propogate across the Internet. With name servers, they are referenced from the core "root servers" that hold the world's DNS system together so while unlikely, it is possible it coule take 24-48 hours for this name servers to become available worldwide and old DNS caches are no longer referencing old answer records. This here is proof the Internet does not revolve around you.

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

Your hosted Git project repository is at the center of the workflow. The role of Gitlab includes tracking changes to code, fostering collaboration and triggering other systems like Caprover that a new revision is ready for testing or publishing.

If you haven't already done so, you will need to setup a new repository for your website in Gitlab. In my example, i've got a "Websites" group where key key staff can manage repositories as needed for clients. For projects requiring NDA's outside of our organization, we have a different working group for those where more restrictive access is configured. In our workflow we adopt a constistant project naming convention for websites, making use of the primary domain name used for that website. This name is similar in Caprover.

A Gitlab project must exist before we can deploy an website in Caprover-- but to signal when a new revision of the website code is available for deployment we need to have Caprover issue a webhook that will get added to Gitlab. It's a bit of a who came first, the chicken or the egg? To make this task ab it easier, I recommend opening Gitlab in one browser tab and another tab pointed to Caprover.






In Gitlab:

- Create a new project if you haven't already done so.
- Create a set of "deploy keys" in Git bash and distribute them

* Generated Deployment Keys
* Get URL of your project repository.

In Caprover:




- Create your app (do not enable persistant storage). Name the app the primary domain for your website, changing periods to dashes.
- Attach your domain name(s) to the app and enable HTTPS.
- Force HTTPS always and enable Websocket support.
- In the Deployment tab for your app, find "Method 3".


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