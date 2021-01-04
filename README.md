# alpine-nginx-php7.3

![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/nickmaietta/alpine-nginx-php73)

Build PHP websites with this simple workflow toolchain kit. Includes instructions and small config for simple, effortless automated deployments for Docker Swarms using Caprover.

TO AVOID CONFUSION, DOCUMENTS HAVE BEEN REDACTED UNTIL THEY ARE FINALIZED.

The only files you should include in your project are:

-docker-compose.yml
-Dockerfile
-composer.json
-captain-definition

Create a src/ directory in your project and move all your PHP website files there.

Then run docker-compose up -d to launch your local webserver.