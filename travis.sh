#!/bin/bash  
HUBNAME=""
if [[ -z "$TRAVIS_TAG" ]]; then
   HUBNAME=migruiz/$PI_APP-$PI_TYPE;
else
	HUBNAME=migruiz/$PI_APP-$PI_TYPE:$TRAVIS_TAG;
fi
docker pull $HUBNAME || true
docker build -f Dockerfile_$PI_TYPE --cache-from $HUBNAME  -t $HUBNAME  . || travis_terminate 1
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin || travis_terminate 1
docker push $HUBNAME  || travis_terminate 1