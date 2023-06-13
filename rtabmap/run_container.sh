#!/bin/bash

set -e
image_name="nielass/ubuntu-dev-base"
container_name="rtabmap-dev"
container_exsit=$(docker ps -q -f name=${container_name})

# echo ${container_exsit}

# check if the contained is already running
if [[ -n ${container_exsit} ]];
then
    # if container is existed, we use it
    echo "Exec current container!!"
    docker exec -it ${container_name}
else
    # if container is not existed yet, we create a new one
    echo "Start New Container: ${container_name} from image: ${image_name}!!"
    docker run \
        --name ${container_name} \
        -it \
        --rm \
        --gpus all \
        --runtime=nvidia \
        ${image_name}
fi
