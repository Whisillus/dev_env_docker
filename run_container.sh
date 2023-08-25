#!/bin/bash

set -e
image_name="whisillus/dev-env"
container_name="dev-env"
workspace_path=$(pwd)

usage() {
    echo "$(basename "$0")"
    echo -e "    [-i image_name] [-n container_name] [-w workspace_path]\n"
    echo -e "Description:\n"
    echo -e "  image_name, the name of the image you want to run (default: ${image_name})\n"
    echo -e "  container_name, the name of running container (default: ${container_name})\n"
    echo -e "  workspace_path, the path mount to /workspace (default: ${workspace_path})\n"
}

printinfo() {
    echo "  Image: ${image_name}"
    echo "  Name: ${container_name}"
    echo "  Workspace: ${workspace_path}"
}

startnew() {
    echo "Container start running!"
    printinfo
}

runexist() {
    echo "Exec current container!!"
    printinfo
}

while getopts 'i:n:w:h' OPT; do
    case $OPT in
        i) image_name="${OPTARG}" ;;
        n) container_name="${OPTARG}" ;;
        w) workspace_path="${OPTARG}" ;;
        h) usage 
            exit 0 ;;
        ?) usage 
            exit 1 ;;
    esac
done

container_exsit=$(docker ps -q -f name=${container_name})

# check if the contained is already running
if [[ -n ${container_exsit} ]];
then
    # if container is existed, we use it
    runexist
    docker exec -it ${container_name} /usr/bin/zsh
else
    # if container is not existed yet, we create a new one
    startnew
    docker run \
        --name ${container_name} \
        -d \
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
        -v "${workspace_path}:/workspace" \
        ${image_name}
fi
