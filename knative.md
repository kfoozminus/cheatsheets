hi

## Read

persistent queue
https://docs.splunk.com/Documentation/Splunk/7.2.3/Data/Usepersistentqueues


- read knative, riff
- eventing
- use nats to build container source


queueing system
https://nats.io/documentation/tutorials/nats-pub-sub/
https://jack-vanlightly.com/blog/2018/10/2/understanding-how-apache-pulsar-works
https://codurance.com/2016/05/16/publish-subscribe-model-in-kafka/
https://www.linkedin.com/pulse/message-que-pub-sub-rabbitmq-apache-kafka-pubnub-krishnakantha





# To Do

Use Riff
https://projectriff.io/docs/getting-started/minikube/
https://github.com/tamalsaha/kube-next/blob/master/microservices/serverless/riff.md
https://www.youtube.com/watch?time_continue=13&v=eZ4dKU0tZEk

Install kvm2 on minikube
https://github.com/kubernetes/minikube/blob/master/docs/drivers.md

Then start minikube with this
```
minikube start --memory=8192 --cpus=4 \
--kubernetes-version=v1.13.0 \
--vm-driver=kvm2 \
--disk-size=30g \
--bootstrapper=kubeadm \
--extra-config=apiserver.enable-admission-plugins="LimitRanger,NamespaceExists,NamespaceLifecycle,ResourceQuota,ServiceAccount,DefaultStorageClass,MutatingAdmissionWebhook"
```


# [Install Knative (not using riff)](https://github.com/knative/docs/blob/master/install/Knative-with-Minikube.md)
- Install Istio

```
curl -L https://github.com/knative/serving/releases/download/v0.3.0/istio.yaml \
  | sed 's/LoadBalancer/NodePort/' \
  | kubectl apply --filename -

kubectl label namespace default istio-injection=enabled
```

- Install knative-serving

```
curl -L https://github.com/knative/serving/releases/download/v0.3.0/serving.yaml \
  | sed 's/LoadBalancer/NodePort/' \
  | kubectl apply --filename -
```
- Deploy a knative-service

```
apiVersion: serving.knative.dev/v1alpha1
kind: Service
metadata:
  name: ksvc-knative-test
  namespace: default
spec:
  runLatest:
    configuration:
      revisionTemplate:
        spec:
          container:
              image: kfoozminus/knative-test:v2
```

- do a grep to see what objects are created

```
kubectl get all | grep "knative-test"

~/./getall | grep "knative-test"
```

### [Install knative-eventing](https://github.com/knative/docs/tree/master/eventing)

```
kubectl apply --filename https://github.com/knative/eventing/releases/download/v0.3.0/release.yaml
kubectl apply --filename https://github.com/knative/eventing-sources/releases/download/v0.3.0/release.yaml
```

- Inspect eventing-sources object

```
kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -n knative-sources
```

- Inspect eventing object

```
kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -n knative-eventing
```

### Install knative-build

```
kubectl apply --filename https://storage.googleapis.com/knative-releases/build/latest/release.yaml
```



