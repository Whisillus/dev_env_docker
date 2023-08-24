#!/bin/bash

set -e
image_name="nielass/dev-env"
container_name="dev-env"
container_exsit=$(docker ps -q -f name=${container_name})

# echo ${container_exsit}

# check if the contained is already running
if [[ -n ${container_exsit} ]];
then
    # if container is existed, we use it
    echo "Exec current container!!"
    docker exec -it ${container_name} /usr/bin/zsh
else
    # if container is not existed yet, we create a new one
    echo "Start New Container: ${container_name} from image: ${image_name}!!"
    docker run \
        --name ${container_name} \
        -it \
        --rm \
        --network host \
        --gpus all \
        -e "DISPLAY=$DISPLAY" \
        -e "QT_X11_NO_MITSHM=1" \
        -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        -e "XAUTHORITY=$XAUTH" \
        -v "$XAUTH:$XAUTH" \
        --runtime=nvidia \
        -e NVIDIA_VISIBLE_DEVICES=all \
        -e NVIDIA_DRIVER_CAPABILITIES=all \
        -v "${HOME}/.ssh:/root/.ssh" \
        -v "$(pwd):/workspace" \
        ${image_name}
fi
