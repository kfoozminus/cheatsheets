#!/bin/bash

curl -L https://github.com/knative/serving/releases/download/v0.3.0/istio.yaml \
  | sed 's/LoadBalancer/NodePort/' \
  | kubectl apply --filename -

kubectl label namespace default istio-injection=enabled

curl -L https://github.com/knative/serving/releases/download/v0.3.0/serving.yaml \
  | sed 's/LoadBalancer/NodePort/' \
  | kubectl apply --filename -

kubectl apply --filename https://github.com/knative/eventing/releases/download/v0.3.0/release.yaml
kubectl apply --filename https://github.com/knative/eventing-sources/releases/download/v0.3.0/release.yaml


kubectl apply --filename https://storage.googleapis.com/knative-releases/build/latest/release.yaml



