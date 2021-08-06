#!/bin/bash

su -m $DOCKER_USER -c "cp -r /root/.rustup /root/.cargo -t ~/"
