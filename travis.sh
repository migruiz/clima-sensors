docker pull migruiz/$PI_APP-$PI_TYPE || true
docker build -f Dockerfile_$PI_TYPE --cache-from migruiz/$PI_APP-$PI_TYPE -t migruiz/$PI_APP-$PI_TYPE . || travis_terminate 1
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin || travis_terminate 1
docker push migruiz/$PI_APP-$PI_TYPE || travis_terminate 1