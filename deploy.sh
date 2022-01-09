#!/bin/bash
echo "start"
# variables
IMAGE_1_NAME="zvavltest/avlservice-repo:avlserviceimage1"
IMAGE_2_NAME="zvavltest/avlservice-repo:avlserviceimage2"
CONTAINER_1_NAME=""
CONTAINER_2_NAME=""
NETWORK_NAME="" 
PORT_RANGE=""
# get cli arguments
while [ $# -gt 0 ]; do
  case "$1" in
    --cont1name=*)
      CONTAINER_1_NAME="${1#*=}"
      ;;
    --cont2name=*)
      CONTAINER_2_NAME="${1#*=}"
      ;;
    --netname=*)
      NETWORK_NAME="${1#*=}"
      ;;
    --portrange=*)
      PORT_RANGE="${1#*=}"
      ;;
    --version_service1=*)
      SERVICE1_VERSION="${1#*=}"
      ;;
    --version_service2=*)
      SERVICE2_VERSION="${1#*=}"
      ;;
    *)
      printf "* Error: "$1" Invalid argument.*\n"
      exit 1
  esac
  shift
done
#if args are empty fill default values
if [ -z "$CONTAINER_1_NAME" ]; then
    CONTAINER_1_NAME="avlservice1"
fi

if [ -z "$CONTAINER_2_NAME" ]; then
    CONTAINER_2_NAME="avlservice2"
fi

if [ -z "$NETWORK_NAME" ]; then
    NETWORK_NAME="avlservice-net"
fi

if [ -z "$PORT_RANGE" ]; then
    PORT_RANGE="8000-9000"
fi

if [ -z "$SERVICE1_VERSION" ]; then
    SERVICE1_VERSION="v1.0"
fi

if [ -z "$SERVICE2_VERSION" ]; then
    SERVICE2_VERSION="v1.0"
fi

#container 1 check, kill, remove
RUNNING1="$(docker ps --all --quiet --filter=name="$CONTAINER_1_NAME")"
if [ -n "$RUNNING1" ]; then
    echo "$CONTAINER_1_NAME is running"
    docker stop $RUNNING1 && docker rm -f $RUNNING1
    echo "$CONTAINER_1_NAME stopped and removed"
fi

#container 2 check, kill, remove
RUNNING2="$(docker ps --all --quiet --filter=name="$CONTAINER_2_NAME")"
if [ -n "$RUNNING2" ]; then
    echo "$CONTAINER_2_NAME is running"
    docker stop $RUNNING2 && docker rm -f $RUNNING2
    echo "$CONTAINER_2_NAME stopped and removed"
fi

# network
docker network create --driver bridge $NETWORK_NAME 2>/dev/null || true

# service 1 start
docker run -d --name $CONTAINER_1_NAME --network $NETWORK_NAME $IMAGE_1_NAME$SERVICE1_VERSION
echo "service $CONTAINER_1_NAME started with $IMAGE_1_NAME:$SERVICE1_VERSION on network $NETWORK_NAME"
# service 2 start
docker run -dp $PORT_RANGE:8080 --name $CONTAINER_2_NAME --env SERVICE1_NAME=$CONTAINER_1_NAME --network $NETWORK_NAME $IMAGE_2_NAME$SERVICE2_VERSION
echo "service $CONTAINER_2_NAME started with $IMAGE_2_NAME:$SERVICE2_VERSION on network $NETWORK_NAME"

# prune unused images
docker image prune -a -f

echo "end"