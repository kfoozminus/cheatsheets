# Setup:
  - Installed kubectl binary using curl: https://kubernetes.io/docs/tasks/tools/install-kubectl/
  - Have secure boot disabled and virtualization enabled from bios
  - Installed virtualBox and minikube: https://kubernetes.io/docs/tasks/tools/install-minikube/



# If you want to get introduced with the commands without knowing what the hell is going on:
  - https://kubernetes.io/docs/tutorials/hello-minikube/
  - https://kubernetes.io/docs/setup/minikube/

## Minikube:
  - `minikube version`
  - `minikube start`
    - Now I have a running Kubernetes clster. Minikube started a virtual machine and a Kubernetes cluster is now running in that VM.
  - `minikube dashboard`
    - shows gui

## kubectl:
  - The cluster can be interacted with using the kubectl CLI. This is the main approach used for managing Kubernetes and the applications running on top of the cluster.
  - `kubectl cluster-info`
    - shows links
  - `kubectl cluster-info dump`
    - further diagnose in terminal
  - `kubectl get nodes`
    - This command shows all nodes that can be used to host our applications. Now we have only one node, and we can see that it’s status is ready (it is ready to accept applications for deployment).







# Next Step: Provides Basics:
  - https://kubernetes.io/docs/tutorials/kubernetes-basics/

## Kubernetes Cluster
  - Before: applications were installed directly onto specific machines as packages deeply integrated into the host. Now: make the applications containerized. Deploy them into a cluster of machines.
  - ![alt text](https://d33wubrfki0l68.cloudfront.net/99d9808dcbf2880a996ed50d308a186b5900cec9/40b94/docs/tutorials/kubernetes-basics/public/images/module_01_cluster.svg)
  - Master coordinates the cluster - schedules applications, maintains desired state, scales app and rolls out new updates.
  - Nodes are the workers that run applications. It's a VM or a physical computer that serves as a worker machine in a Kubernetes cluster. It has a kubelet, that manages the node and communicates with master. Each node has docker/rkt too. A cluster has at least three nodes.
  - To deploy an application, you tell the master the start app containers. The master schedules the containers to run on the nodes. The nodes communicates with the master using k8s api, which the master exposes. Users can also communicate withe master using the api.
  - A k8s cluster can be deployed on either physical or vm. We can use minikube to make a k8s cluster on local machine, which has only one node.
### Minikube:
  - `minikube version` ensure that minikube is installed
  - `minikube start` - minikube created a virtual machine and a k8s cluster is running in that vm.
  - `kubectl version` - it provides an interface to manage k8s. This command checks if kubectl is installed properly.
  - `kubectl cluster-info` - shows the cluster details
  - `kubectl get nodes` - shows all the nodes that can be used to host apps. Now in our local machine, we have only one node and we can it's status ready and it's role is *master*

## K8s Deployments:
  - Now you can deploy apps **on top of the cluster**. You need to create a **Deployment Configuration**. This instructs how to create and update instances of your app. Then Master schedules the instances onto individual Nodes.
  - Once instances of the app are created, a Kubernetes Deployment Controller continuously monitors these instances. If a Node containing an instances goes down, the Deployment controller replaces it. This provides a self-healing mechanism.
  - Before: scripts were used to start the app, but doesn't help to recover. Now: Controller keeps them running.
  - ![alt text](https://d33wubrfki0l68.cloudfront.net/152c845f25df8e69dd24dd7b0836a289747e258a/4a1d2/docs/tutorials/kubernetes-basics/public/images/module_02_first_app.svg)
### kubectl
  - kubectl is a command line interface that communicates with the cluster using the k8s api.
  - To deploy, you need to specify the container image and number of replicas to run. You can change the info by updating the Deployment.
  - `kubectl run <deployment-name> --image=<image-name> --port=<8080-or-something-else>`
    - `kubectl run` command creates a new Deployment. It need deployment name and app image location (if the image aren't hosted on DockerHub, needs to include full repo url). Also needs specific port to run
    - this command searched for a Node where an instance of the app could be run
    - scheduled the app to run on that Node
    - configured the cluster to reschedule the instance on a new node when needed
    - Q: fahim couldn't run the deployment because he didn't have `EXPOSE` in his Dockerfile. After adding the line, deployment ran. And `--port` value in `kubectl run` command doesn't have to match `EXPOSE` value. Why?
    - `kubectl run busyboxkube --image=busybox` pods doesn't run because the os container have nothing to do - it will be in `Running` status as long as it has something to do - Shudipta added a infinite loop and it ran and you can run `kubectl exec -it <pod-name> sh` and run various comamnds on sh.
      - QJenny - fahim asked how can I access bash/sh from it and run commands
  - `kubectl get deployments` shows the deployments, their instances and state.
  - `kubectl proxy` creates a proxy - so far kubectl were communicating with k8s cluster using api, but after proxy command we can communicate with k8s api too (through browser or curl)


## Pods and Nodes
### K8s Pods
  - A pod represents one or more containers and has some shared storage as Volumes, networking as a unique cluster IP address, information about each container such as image version or which ports to use.
  - A pod models an application-specific "logical host" and can contain different application which are relatively tightly coupled.
  - The contains in same Pod share an IP address and port space - co-located/co-scheduled/runs-in-same-context
  - Pods are atomic unit on K8s platform. A deployment creates Pods with containers inside them. Each pod is tied to its Node, where it is scheduled. When a Node fails, identical pods are scheduled on other available Nodes in the cluster.
  - ![alt text](https://d33wubrfki0l68.cloudfront.net/fe03f68d8ede9815184852ca2a4fd30325e5d15a/98064/docs/tutorials/kubernetes-basics/public/images/module_03_pods.svg)
### Nodes
  - One node is either one physical machine (laptop) or virtual machine (I can create more than one node in my laptop with VM). A node can have multiple pods and k8s master automatically handles scheduling the pods across the Nodes in the cluster, based on the resources available on each Node.
  - One node has kubelet - a process responsible for communicating with the Master. It manages pods and containers.
  - Node contains container runtime too (Docker/rkt) which pulls the container image, unpacks the container and runs the pp.
  - ![alt text](https://d33wubrfki0l68.cloudfront.net/5cb72d407cbe2755e581b6de757e0d81760d5b86/a9df9/docs/tutorials/kubernetes-basics/public/images/module_03_nodes.svg)
### Commands
  - `kubectl get pods` lists pods.
  - `kubectl describe pods` shows details (yaml?)
  - `kubectl proxy` - As pods are running in an isolated, private network - we need to proxy access to them so we can interact with them.
    - `kubectl proxy --port=3456` adds a port
    - default is 8001
    - `curl localhost:8001` from browser
  - `export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')`
    - QJenny
  - `curl http://localhost:<mentioned-or-default-port>/api/v1/namespaces/default/pods/$POD_NAME/proxy/` (from my laptop)
    - QJenny - shows yaml-like things
  - `kubectl logs <pod-name>` - Anything that the application would normally send to STDOUT becomes logs for the container within the Pod (ommitted name of container as we have only one container now)
  - `kubectl exec <pod-name> <command>` - we can execute commands directly on the container once the Pod is up and running. (here we ommitted the container name as there's only one container in our pod)
    - `kubectl exec -it <pod-name> bash` - lets us use the bash inside the container(again, we have one container)
    - we can use `curl localhost:8080` to from inside the container (after accessing bash of the pod)
      - as we used `4321` in our dockerfile - we would use `localhost:4321`
      - `--target-port` is `4321`



## K8s Services:
  - Pods are mortal. They have a lifecycle. If a node dies, pods running on that node are lost too.
  - Replication Controller creates new pods when that happens (by rescheduling the pod on available nodes).
  - Pods have unique IP across a K8s cluster.
  - Front-end shouldn't care about backend replicas or if a pod is lost and created.
  - A service in K8s defines a logical set of Pods and a policy by to access them. Service is defined using YAML.
  - The set of Pods targeted by a Service is usually determined by a `LabelSelector`
  - Unique IP addresses are not exposed to outside cluster with a Service. Services can be exposed in different ways by specifying a **type** in the ServiceSpec.
    - `ClusterIP` (default) exposes the service on an internal IP in the cluster. This makes the Service onlu reachable from within the cluster.
    - `NodePort` exposes the Service on the same port of each selected Node in the cluster using NAT. Makes a service accessible from outside the cluster using `<NodeIP>:<NodePort`. Superset of ClusterIP.
    - `LoadBalancer` creates an external load balancer in the current cloud (if supported) and assigns a fixed, external IP to the Service. Superset of NodePort.
    - `ExternalName` exposes the service using an arbitrary name (specified by `externalName` in the spec) by returning a `CNAME` record with the name. No proxy is used. This type requires v1.7 or higher of `kube-dns`
  - A service created without selector will also not create the corresponding Endpoints object. This allows users to manually map a Service to specific endpoints. Another possibility why there maybe no selector is you are strictly using `type:ExternalName`
### Services and Labels
  - ![alt text](https://d33wubrfki0l68.cloudfront.net/cc38b0f3c0fd94e66495e3a4198f2096cdecd3d5/ace10/docs/tutorials/kubernetes-basics/public/images/module_04_services.svg)
  - Service routes traffic for a set of pods and allows pods to die and replicate in k8s without impacting the app (services exposes pods through a common port(in case of node port) - so an application sees the service  - if a node/pod is down service is recreating those pods internally - application is not harmed)
  - Labels are key/value pairs attached to objects. It can attached to objects at creation or later on.
  - A Service can be created at time of deployment by using `--expose` in kubectl.
  - ![alt text](https://d33wubrfki0l68.cloudfront.net/b964c59cdc1979dd4e1904c25f43745564ef6bee/f3351/docs/tutorials/kubernetes-basics/public/images/module_04_labels.svg)
  - A Service is created by default when minikube starts the cluster.
### Commands:
  - `kubectl get services`
  - `kubectl expose deployment/<deployment-name> --type="NodePort" --port 4321` created a new service and exposed it as NodePort type. minikube doesn't support LoadBalancer yet.
    - QJenny - Here target-port must be same as the one we exposed in Dockerfile - the deployment is deploying a container based on the dockerfile and the container exposed the target-port mentioned - and If we are creating a Service whose job is to watch that deployment/Pods/Container, we have to watch this on same port
    - when we are mentioning `--port` and not mentioning `--target-port`, target-port takes the --port by default
    - my `EXPOSE` in Dockerfile is `4321`, we can access the service only if `--target-port` is `4321`
    - QJenny - so what is --port in `kubectl expose`
    - QJenny - what is --port in `kubectl run`
    - QJenny - So a cluster can have multiple services?
    - services works on pods - a service can have pods from multiple nodes
  - `kubectl describe services/<service-name>` shows details
    - QJenny - service name or deployment name?
  - `export NODE_PORT=$(kubectl get services/kubernetes-bootcamp -o go-template='{{(index .spec.ports 0).nodePort}}')`
    - `curl $(minikube ip):$NODE_PORT`
      - `minikube ip` shows the node-ip
      - browse `192.168.99.100:30250`
  - `kubectl describe deployment` shows name of the label among many other infos
  - QJenny
    - how does services work? service labels? everything has labels?
  - `kubectl get pods -l run=<pod-label>`
    - `kubectl get pods -l run=booklistkube2`
  - `kubectl get services -l run=<service-label>`
    - `kubectl get services -l run=booklistkube2`
    - QJenny - pod-label? service-label? I guess It's deployment-name? by run=<deployment-name> we are using the default label of a pod. and I guess `run` is an attribute? Later we used `app` attribute?
  - `export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')`
    - QJenny
  - `kubectl label pod <pod-name> app=<varialbe-name>` applies a new label (pinned the application version to the pod)
    - this doesn't add this label to the service - so we are sure that : although service/pod had same label `run=booklistkube2` they are different
    - QJenny - `app` is an attribute? what are the other attributes?
  - `kubectl describe pods <pod-name>`
    - if we use `-l` flag, use <pod-label>
    - otherwise, use <pod-name>
    - same for `kubectl get pods`
  - `kubectl describe pods -l app=<app-label-name`
  - `kubectl delete service -l run=<label-name>` or `app=<label-name` deletes a service
    - or `kubectl delete service <service-name`
  - `kubectl label pod <pod-name> app=v2 --overwrite` overwrites a label name
  - `kubectl label service <service-name> app=<label-name` we can add service label too! (:D starting to get the label-things)
  - `kubectl edit service <service-name> -o yaml` you can edit details of the service
    - `-o yaml` can be ommitted
    - used `--port=8080` - later saw that `--target-port` got the same from this comamnd and edited target-port(only) to `4321` and it worked
  - `kubectl get service <service-name> -o yaml` shows the yaml
  - `kubectl get deployment <deployment-name> -o yaml`
  - `kubectl edit deployment <deployment-name> -o yaml`
    - `-o yaml` can be ommitted
  - `kubectl get pod <pod-name> -o yaml`
  - `kubectl edit pod <pod-name> -o yaml`
    - `-o yaml` can be ommitted
  - `kubectl exec -it <pod-name> sh` - then `wget localhost:4321` (--target-port)
  - `kubectl exec -it <pod-name> wget localhost:4321`





## Scaling
  - Scaling is accomplished by changing the number of replicas in a Deployment.
  - Scaling will increase the number of Pods to the new desired state - schedules them to nodes with available resources. Scaling to zero will terminate all pods.
  - Services have an intergrated load balancer that will distribute network traffic to all pods of an exposed deployment. Services will monitor continuously the running pods using endpoints, to ensure the traffic is sent only to available pods.
  - `kubectl get deploy` command has
    - DESIRED shows the configured number of replicas
    - CURRENT shows how many replicas are running now
    - UP-TO-DATE shows the number of replicas that were updated to match the desired state
    - AVAILABLE state shows the number of replicas AVAILABLE to the users
  - `kubectl scale deploy/booklistkube2 --replicas=4` makes the number of pods to 4
  - `kubectl get pods -o wide` will also show IP and NODE
  - `kubectl get deploy booklistkube2` will now show the scaling up event
  - `kubectl describe services <service-name>` shows 4 endpoints as `IP:4321` (4 different IP and one common port).
    - creating replicas will automatically be added to the service
    - QJenny - Here `port` is `--port` (I don't know what it does). TargerPort is `--targer-port` - the one we exposed in Dockerfile. NodePort is 31562. The one we're gonna use to access the service from browser. I guess NodePort is mapped to TargetPort
  - open `kubectl get pods -w`, `kubectl get deploy -w`, `kubectl get replicaset -w` in 3 pane and scale/edit a deployment in another pane and see the changes :D
    - replicaset name + different extension = different pod name
    - scaling up/down doesn't change the replicaset name - because old pods are useful. but updating deployment replaces every pod - so new replicaset name and pod name.




## Update
  - Rolling updates allow deployments' update to take place with zero downtime by incrementally updating pods instances with new ones.
  - By default, the max no of pods that can be unavailable during the update and the max no of new pods that can be created, is one. Both options can be configured to either number or percentage. Updates are versioned and can be reverted back to  previous version.
  - Similar to application Scaling, if a deployment is exposed publicly, the Service will load-balance the traffic only to available Pods during the update.
  - `kubectl set image deploy/booklistkube2 <container-name>=<new-image-name>` changes image
  - `kubectl rollout status deploy/booklistkube2` shows rollout status
  - `kubectl rollout undo deploy/booklistkube2` reverts back to previous version
  - `kubectl get events`
  - `kubectl config view`





# Concepts:
  - https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/
  - K8s Master is collection of these process: kube-apiserver, kube-controller, kube-scheduler
  - Each non-master node has two processes:
    - kubelet, which communicates with the K8s Master
    - kube-proxy, a network proxy which reflects K8s networking services on each node
  - Various parts of the K8s Control Plane, such as the K8s Master and kubelet processes, govern how K8s communicates with your cluster.

## Kubernetes:
  - Open-source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation.
  - A container platform/a microservices platform/a portable cloud platform and a lot more.
  - [Google's Borg system is a cluster manager that runs hundreds of thousands of jobs, from many thousands of different applications, across a number of clusters each with up to tens of thousands of machines.]
  - Continuous Integration, Delivery, and Deployment (CI/CD)
  - Kubernetes is not a mere orchestration system. In fact, it eliminates the need for orchestration. The technical definition of orchestration is execution of a defined workflow: first do A, then B, then C. In contrast, Kubernetes is comprised of a set of independent, composable control processes that continuously drive the current state towards the provided desired state. It shouldn’t matter how you get from A to C. Centralized control is also not required.
  - why containers?
    - The Old Way to deploy applications was to install the applications on a host using the operating-system package manager. This had the disadvantage of entangling the applications’ executables, configuration, libraries, and lifecycles with each other and with the host OS. One could build immutable virtual-machine images in order to achieve predictable rollouts and rollbacks, but VMs are heavyweight and non-portable.
    - The New Way is to deploy containers based on operating-system-level virtualization rather than hardware virtualization. These containers are isolated from each other and from the host: they have their own filesystems, they can’t see each others’ processes, and their computational resource usage can be bounded. They are easier to build than VMs, and because they are decoupled from the underlying infrastructure and from the host filesystem, they are portable across clouds and OS distributions.
    - Containers are small and fast. So one-to-one application-to-image relation if built.
  - The name Kubernetes originates from Greek, meaning helmsman or pilot, and is the root of governor and cybernetic. K8s is an abbreviation derived by replacing the 8 letters `ubernete` with `8`


## K8s Components
### Master Components
  - Master components provide the cluster's control  plane - makes global decisions, e.g. scheduling, detecting, responding
  - Master components can be run on any machine in the cluster - usually set up scripts start all master components on the same machine and do not run user containers on this machine.
  - `kube-apiserver` exposes k8s api - front end for k8s control plane. designed to scale horizontally, that is - it scales by deploying more instances (QJenny - vertical scaling is creating new replicas with increased resources?)
  - `etcd` is key value store used as k8s' backing store for all cluster data.
    - QJenny - Doc said, Always have backup plan for etcd's data for your k8s cluster.
  - `kube-scheduler` schedules newly created pods to nodes based on indivifual and collective resource requirements, hardware/software/policy constraints, affinity and anti-affinity specifications, data locality, inter-workload interface and deadlines.
    - QJenny
  - `kube-controller manager` runs controllers. Logically, each controller is a seperate process, but to reduce complexity, they are all compiled into a single binary and run in a single process
    - `Node Controller` is responsible for noticing and responding when nodes go down
    - `Replication Controller` is responsible for maintaining correct number of pods
    - `Endpoints Controller` populates the Endpoints object (joins Services and Pods)
    - `Service Account & Token Controllers` create default accounts and API access tokens for new namespaces.
    - QJenny
  - `cloud-controller-manager` runs controllers that interact with the underlying cloud providers. It runs cloud-provider-specific controller loops only, must disable these controller loops in the kube-controller-manager by setting `--cloud-provider` flag to  `external`. It allows cloud vendors code and k8s core to evolve independent of each other. In prior releases, the core k8s code was dependent upon cloud-provider-specific code for functionality. In future releases, code specific to cloud vendors should be maintained by the cloud vendor themselves, and linked to cloud-controller-manager while running k8s. These controllers have cloud provider dependencies:
    - `Node Controller` for checking the cloud provider to determine if a node has been deleted in the cloud after it stops responding.
    - `Route Controller` for setting up routes in the underlying cloud infrastructure
    - `Service Controller` for creating, updating and deleting cloud provider load balancers
    - `Volume Controller` for creating, attaching and mounting volumes, and interacting with the cloud provider to orchestrate volumes
    - QJenny


### Node Components
  - `kubelet` runs on each in the cluster, takes a set of PodSpecs and ensures that the containers are running and healthy.
  - `kube-proxy` enables k8s service abstraction by maintaining network rules on the host and performing connection forwarding
    - QJenny
  - `Container Runtime` is the software that is responsible for running containers, e.g. Dcocker, rkt, runc, any OCI runtime-spec implementation
    - QJenny



### Addons
  - Addons are pods and services that implement cluster features. They may be managed by Deployments, ReplicationControllers. Namespaced addon objects are created in `kube-system` namespace.
    - QJenny
  - `DNS` - all k8s clusters should have cluster DNS, as many examples rely on it. Cluster DNS is DNS server, in addition to the other DNS server(s) in your environment, which serves DNS records for k8s services. Containers started by k8s automatically include this DNS server in their DNS searches
    - QJenny
  - `Web UI`(Dashboard)
  - `Container Resource Monitoring` records generic time-series metrics about containers in a central database and provides a UI for browsing that data
    - QJenny
  - `Cluster-level Logging` is responsible for saving container logs to central log store with search/browsing interface
    - QJenny


## K8s API
  - https://kubernetes.io/docs/concepts/overview/kubernetes-api/
    - QJenny
  - API continuously changes
  - to make it easier to eliminate fields or restructure resource representation, k8s supports multiple API versions, each at a different API path, such as `/api/v1` or `/apis/extensions/v1beta1`
  - Alpha: e.g, `v1alpha1`. may be buggy.
  - Beta: e.g, `v2beta3`. code is well tested
  - Stable: e.g, `v1`. will appear in released software.



## K8s Objects
  - K8s objects represent the state of a cluster. They can describe
    - what containerized applications are running on which nodes
    - available resources
    - policies areound how those applications behave (restart, upgrade, fault-tolerance)
  - Objects represents the cluster's desired state
  - `kubectl` is used to create/modify/delete the objects through api calls. alternatively, [client libraries](https://kubernetes.io/docs/reference/using-api/client-libraries/) can be used
    - QJenny
  - Every k8s object has two field - the object spec is provided, it describes desired state. The object status describes the actual status of the object. k8s control plane actively manages actual state to match the desired state
    - deployment is an object. spec can have no of replicas to make. it one fails, k8s replaces the instance.


### Describing K8s Object
  - k8s api is used (either directly or via kubectl) to create an object. that API request must have some information as JSON in the request body. I provide the information to kubectl in a `.yaml` file. kubectl convert the info to JSON
  -
    ```apiVersion:
    kind:
    metadata:
      name:
      labels:
        app:
    spec:
      replicas:
      template:
        metadata:
          name:
          labels:
            app:
        spec:
          containers:
            - name:
              image:
              imagePullPolicy: IfNotPresent
              ports:
              - containerPort:
          restartPolicy: Always
      selector:
        matchLabels:
          app:
    ```
    - [kubernetes type architecture](https://github.com/kubernetes/api/blob/kubernetes-1.12.0/apps/v1/types.go#L250)
    - `apiVersion` defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. +optional
    - `kind` Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. Cannot be updated. +optional
    - `metadata` Standard object metadata. +optional
      - `name` Name must be unique within a namespace. Cannot be updated. +optional
      - `labels` Map of string keys and values that can be used to organize and categorize (scope and select) objects. May match selectors of replication controllers and services. +optional
        - `app` is key of the map (Why isn't it string? QJenny)
      - `uid` UID is the unique in time and space value for this object. It is typically generated by the server on successful creation of a resource and is not allowed to change on PUT operations. +optional
    - `spec` Specification of the desired behavior of the Deployment. +optional
      - `replicas` Number of desired pods. This is a pointer to distinguish between explicit zero and not specified. Defaults to 1. +optional
      - `template` Template describes the pods that will be created.
        - `metadata` Standard object's metadata. +optional
          - `name` same
          - `labels` same
            - `app` same
        - `spec` Specification of the desired behavior of the pod. +optional
          - `containers` List of containers belonging to the pod. Containers cannot currently be added or removed. There must be at least one container in a Pod. Cannot be updated.
            - `name` Name of the container specified as a DNS_LABEL. Each container in a pod must have a unique name (DNS_LABEL). Cannot be updated.
            - `image` Docker image name. This field is optional to allow higher level config management to default or override container images in workload controllers like Deployments and StatefulSets. +optional (QJenny)
            - `imagePullPolicy` Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if :latest tag is specified, or IfNotPresent otherwise. Cannot be updated. +optional
              - Always means that kubelet always attempts to pull the latest image. Container will fail If the pull fails.
              - Never means that kubelet never pulls an image, but only uses a local image. Container will fail if the image isn't present
              - IfNotPresent means that kubelet pulls if the image isn't present on disk. Container will fail if the image isn't present and the pull fails.
            - `ports` List of ports to expose from the container. Exposing a port here gives the system additional information about the network connections a container uses, but is primarily informational. Not specifying a port here DOES NOT prevent that port from being exposed. Any port which is listening on the default "0.0.0.0" address inside a container will be accessible from the network. Cannot be updated. +optional
              - `containerPort` Number of port to expose on the pod's IP address. This must be a valid port number, 0 < x < 65536. (QJenny)
          - `restartPolicy` Restart policy for all containers within the pod. One of Always, OnFailure, Never. Default to Always. +optional
      - `selector` Label selector for pods. Existing ReplicaSets whose pods are selected by this will be the ones affected by this deployment. It must match the pod template's labels. (Selector selects the pods that will be controlled. if the matchLabels is a subset of a pod, then that pod will be selected and will be controlled. If we change no of replicas then these pods will be affected? QJenny)
        - `matchLabels` matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is "key", the operator is "In", and the values array contains only "value". The requirements are ANDed. +optional (QJenny)
          - `app` is a key
    - QJenny - what is +optional? (Nahid: +optional thakle user empty dite parbe, na dile nil hobe. +optional na thakle na dile empty hobe??? :/ )
    - `apiVersion`, `kind`, `metadata` is required.


## Names & UID
  - All objects in the Kubernetes REST API are unambiguously identified by a Name and a UID. For non-unique user-provided attributes, Kubernetes provides labels and annotations.
### Names
  - name is included in the url `/api/v1/pods/<name>`
  - max length 253. consists of lowercase alphanumeric, '-' and '.' (certain resources have more specific restrictions)
### UID
  - A Kubernetes systems-generated string to uniquely identify objects.
  - Every object created over the whole lifetime of a Kubernetes cluster has a distinct UID. It is intended to distinguish between historical occurrences of similar entities.


## Namespaces
  - Namespaces are intended for use in environments with many users spread across multiple teams, or projects. For clusters with a few to tens of users, you should not need to create or think about namespaces at all. Start using namespaces when you need the features they provide. Namespaces provide a scope for names. Names of resources need to be unique within a namespace, but not across namespaces.
  - It is not necessary to use multiple namespaces just to separate slightly different resources, such as different versions of the same software: use labels to distinguish resources within the same namespace.
  - `kubectl get namespaces` to view namespaces in a cluster
    - `default` the default namespace for objects with no other namespace
    - `kube-system` for objects created by k8s system
    - `kube-public` is crated automatically and readable by all users(including not authenticated). mostly reserved for cluster usage, in case some resources should be visible and readable publicly
  - `kubectl create ns <new_namespace_name` creates a namespace
  - `kubectl --namespace=<non-default-namespace> run <deployment-name> --image=<image-name>`
  - `kubectl get deploy --namespace=<new-namespace>` if not mentioned, kubectl uses default namespaces. so you won't see the deployment created in previous comamnd if you don't mention this namespace name
  - `kubectl get deploy --all-namespaces` shows all deployments under al namespaces
  - similar `--namespace` flag for all deloy/pod/service/container commands
  - `kubectl delete ns <new-namespace>` deletes a namespace
  - `kubectl config view` shows the file `~/.kube/config`
    - clusters: here we have only minikube cluster, with its certificates and server. minikube cluster is running in that ip:port. `192.168.99.100` comes from here
    - users: kubectl communicates with k8s api, as a user(name: minikube (QJenny)). that user is defined here with its certificates and stuff
    - context: configurations - we have one context. a context has cluster/user/namespace/name
    - QJenny
  - `kubectl config current-context` shows current-context field of the config file
  - `kubectl config set-context $(kubectl config current-context) --namespace=<ns>` sets a ns as default, any changes you make/create objects will be done to this namespace
  - most k8s resources (pods, services, replication controllers etc.) are in some namespaces. low-level resources (nodes, persistentVolumes) are not in namespace.
    - `kubectl api-resources` shows all
      - `--namespaced=true` shows which are in some namespace
      - `--namespaced=false` shows which are not in a namespace


### DNS
  - When you create a Service, it creates a corresponding DNS entry. This entry is of the form <service-name>.<namespace-name>.svc.cluster.local, which means that if a container just uses <service-name>, it will resolve to the service which is local to a namespace.
  - This is useful for using the same configuration across multiple namespaces such as Development, Staging and Production. If you want to reach across namespaces, you need to use the fully qualified domain name (FQDN).


## Labels and Selectors
  - 





















# To Do:
  - make list of all the ports



###### To be cleared:
- `minikube start` command initializes `kubeadm, kubelet, certs, cluster, kubeconfig`
- Kubernetes is microservices platform
