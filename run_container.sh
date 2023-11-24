#!/bin/bash

set -e

# for output color
Nc='\033[0m' # No Color
BRed='\033[1;31m'
BCyan='\033[1;36m'

# default values
image_repo="whisillus/dev-env"
image_tag="latest"
container_name="dev-env"
workspace_path=$(pwd)

# print func
usage() {
    echo "$(basename "$0")"
    echo -e "    [-i image_repo] [-t image_tag] [-n container_name] [-w workspace_path]\n"
    echo -e "Description:\n"
    echo -e "  -i image_repo, the REPOSITORY of the image you want to run (default: ${image_repo})\n"
    echo -e "  -t image_tag, the TAG of the image you want to run (default: ${image_tag})\n"
    echo -e "  -n container_name, the name of running container (default: ${container_name})\n"
    echo -e "  -w workspace_path, the path mount to /workspace (default: ${workspace_path})\n"
}

printinfo() {
    echo "  Image: ${image_repo}:${image_tag}"
    echo "  Name: ${container_name}"
    echo "  Workspace: ${workspace_path}"
}

startnew() {
    echo -e "${BRed}Starting Container!${Nc}"
    printinfo
}

runexist() {
    echo -e "${BCyan}Exec current container!!${Nc}"
}

checkimage() {
    exist=$(docker images -q ${1}:${2})
    if [[ -z ${exist} ]];
    then
        echo -e "Docker Image ${BRed}${1}:${2}${Nc} NOT exist!"
        exit 1
    else
        echo "${1}:${2} Found!"
    fi
}

# process params
while getopts 'i:t:n:w:h' OPT; do
    case $OPT in
        i) image_repo="${OPTARG}" ;;
        t) image_tag="${OPTARG}" ;;
        n) container_name="${OPTARG}" ;;
        w) workspace_path="${OPTARG}" ;;
        h) usage 
            exit 0 ;;
        ?) usage 
            exit 1 ;;
    esac
done


# run the container
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
    checkimage ${image_repo} ${image_tag}
    docker run \
        --name ${container_name} \
        -d \
        -it \
        --rm \
        --privileged \
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
        -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
        -v "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" \
        -v "${HOME}/.ssh:/root/.ssh" \
        -v "${workspace_path}:/workspace" \
        ${image_repo}:${image_tag}

    echo "Container Started!"
fi
