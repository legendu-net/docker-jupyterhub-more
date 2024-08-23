#!/usr/bin/env sh

docker pull dclong/jupyterhub-jdk:next
docker build -t dclong/jupyterhub-more:next .
#docker build --no-cache -t dclong/jupyterhub-more:next .
