
https://itnext.io/building-an-operator-for-kubernetes-with-kubebuilder-17cbd3f07761
https://www.godoc.org/sigs.k8s.io/controller-runtime/pkg

### Core principals of k8s:

The structure of Kubernetes APIs and Resources
API versioning semantics
Self-healing
Garbage Collection and Finalizers
Declarative vs Imperative APIs
Level-Based vs Edge-Base APIs
Resources vs Subresources

###

kubebuilder init --domain k8s.io --license apache2 --owner "The Kubernetes Authors"
kubebuilder create api --group mygroup --version v1beta1 --kind MyKind
minikube start
make install
make run
