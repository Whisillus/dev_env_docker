#!/bin/bash

set -e
image_name="nielass/rtabmap-dev"
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
        --network host \
        --gpus all \
        --runtime=nvidia \
        -e NVIDIA_VISIBLE_DEVICES=all \
        -e NVIDIA_DRIVER_CAPABILITIES=all \
        -v "${HOME}/.ssh:/root/.ssh" \
        ${image_name}
fi
