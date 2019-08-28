#! /bin/bash

# Build
docker build \
-t cpackingham/multi-client:latest \
-t cpackingham/multi-client:$SHA \
-f ./client/Dockerfile ./client

docker build \
-t cpackingham/multi-server:latest \
-t cpackingham/multi-server:$SHA \
-f ./server/Dockerfile ./server

docker build \
-t cpackingham/multi-worker:latest \
-t cpackingham/multi-worker:$SHA \
-f ./worker/Dockerfile ./worker

# Push
docker push cpackingham/multi-client:latest
docker push cpackingham/multi-client:$SHA

docker push cpackingham/multi-server:latest
docker push cpackingham/multi-server:$SHA

docker push cpackingham/multi-worker:latest
docker push cpackingham/multi-worker:$SHA

# Update k8s
kubectl apply -f k8s

# Redeploy
kubectl set image deployments/client-deployment client=cpackingham/multi-client:$SHA
kubectl set image deployments/server-deployment server=cpackingham/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=cpackingham/multi-worker:$SHA