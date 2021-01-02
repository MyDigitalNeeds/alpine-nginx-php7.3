# The Development Workflow Strategy
### Stream your PHP development and deploy-to-production workflow with this modernized workflow strategy. Designed around Docker, Gitlab and a Docker Swarm managed with Caprover.

![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/nickmaietta/alpine-nginx-php73)

Your Dev PC <-----> Gitlab <-----> Caprover -----> The World

This workflow strategy is designed for the PHP developer but it can be applied to virtually any type of webiste or application development where your code is held in a central Git repository and deployed to a Docker Swarm using Caprover.