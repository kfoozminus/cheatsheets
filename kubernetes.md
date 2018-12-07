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
    - [Deployment struct](https://github.com/kubernetes/api/blob/kubernetes-1.12.0/apps/v1/types.go#L250)
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
        - `matchLabels` matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is "key", the operator is "In", and the values array contains only "value". The requirements are ANDed. +optional. type: map[string]string
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
    - clusters: here we have only minikube cluster, with its certificates and server. minikube cluster is running in that ip:port. `192.168.99.100` (minikube ip) comes from here
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
  - QJenny


## Labels and Selectors
  - to specify identifying attributes of objects - meaningful and relevant (but do not directly imply semantics to the core system). used to organize and seelect subsets of objects. can be attached at creation/added/modified.
  - key can be anything, but have to be unique (within a object). e.g, `release`, `environment`, `tier`, `partition`, `track`
  - Labels are key/value pairs. Valid label keys have two segments: an optional prefix and name, separated by a slash (/). The name segment is required and must be 63 characters or less, beginning and ending with an alphanumeric character ([a-z0-9A-Z]) with dashes (-), underscores (_), dots (.), and alphanumerics between. The prefix is optional. If specified, the prefix must be a DNS subdomain: a series of DNS labels separated by dots (.), not longer than 253 characters in total, followed by a slash (/). If the prefix is omitted, the label Key is presumed to be private to the user. Automated system components (e.g. kube-scheduler, kube-controller-manager, kube-apiserver, kubectl, or other third-party automation) which add labels to end-user objects must specify a prefix. The kubernetes.io/ prefix is reserved for Kubernetes core components.
  - many objects can have same labels
  - via a label selector, the client/user can identify a set of objects. the label selector is the core grouping primitive in k8s
  - current, the API supports two types of selectors: equality-based and set-based. A label selector can be made of multiple requirements, which are comma-separated - acts as a logical AND(&&).
    - An empty label selector selects every object in the collection
    - A null label selector (which is only possible for optional selector fields) selects no objects (QJenny)
    - The label selectors of two controllers must not overlap within a namespace, otherwise they will fight with each other. (QJenny - Deployment controllers? does every deployment has one controller?)


### Equality-based requirement
  - equality or inequality based requirements allow filtering by label keys and values. matching objects must satisfy **ALL** of the specified label constraints, though they may have additional labels as well.
  - three kinds of operator are admitted `=`, `==`, `!=`. first two are synonyms.
    - `environment = production` selects all resources with key equal `environment` and value equal to `production`
    - `tier != frontend` selects all resources with key equal to `tier` and value distinct from `frontend` and all resources with no labels with the `tier` key.
    - `environment=production, tier!=frontend` selects resources in `production` excluding `frontend`
    - usually, pods are scheduled to nodes, based on various criteria. If we want to limit the nodes a pod can be assigned to
		``` apiVersion: v1
		kind: Pod
		metadata:
			name: cuda-test
		spec:
			containers:
				- name: cuda-test
					image: "k8s.gcr.io/cuda-vector-add:v0.1"
					resources:
						limits:
							nvidia.com/gpu: 1
			nodeSelector:
				accelerator: nvidia-tesla-p100
		```
    - [Pod Struct](https://github.com/kubernetes/kubernetes/blob/895f483fdfba055573681ef067e16d60df7985f8/staging/src/k8s.io/apiserver/pkg/apis/example/v1/types.go#L33)
    - `kind`, `metadata` same
    - `spec` (podSpec) same
      - `containers` same
        - `name`, `image` same
        - `resources` Compute Resources required by this container. Cannot be updated. +optional
          - `limits` Limits describes the maximum amount of compute resources allowed. +optional (this is of type ResourceList. ResourceList is a set of (resource name, quantity) pairs.) (QJenny: [Quantity](https://github.com/kubernetes/apimachinery/blob/6dd46049f39503a1fc8d65de4bd566829e95faff/pkg/api/resource/quantity.go#L88:6))
              - `nvidia.com/gpu` is resource name, whose quantity is `1`
      - `nodeSelector` NodeSelector is a selector which must be true for the pod to fit on a node. Selector which must match a node's labels for the pod to be scheduled on that node. +optional
        - `accelerator: nvidia-tesla-p100` is a node label


### Set-based requirement
  - set-based label requirements allow one key with multiple values.
  - three kinds of operators are supported: `in`, `notin` and `exists` (only key needs to be mentioned) (QJenny)
  - `environment in (production, qa)` selects all resources with key equal to `environment` and value equal to `production` OR `qa`. (of course OR, it cannot be AND, can it? a resource cannot have multiple values for one key)
  - `tier notin (frontend, backend)` selects all resources with key equal to `tier` and values other than `frontend` and `backend` and all resources with no labels with the `tier` key
  - `partition`  selects all resources including a label with key `partition`, no values are checked
  - `!partition` selects all resources without the key `partition`; no values are checked
  - comma acts like a AND
    - so `partition, environment notin (qa)` means the key `partition` have to exist and `environment` have to be other than `qa` (QJenny, will the resources with no `environment` be selected?)
  - Set-based requirements can be mixed with equality-based requirements. For example: `partition in (customerA, customerB), environment!=qa`


### API
    - LIST and WATCH both are allowed to use using labels
    - in URL:
      - equality-based: `?labelSelector=environment%3Dproduction,tier%3Dfrontend`
      - set-baed: `?labelSelector=environment+in+%28production%2Cqa%29%2Ctier+in+%28frontend%29`
    - both selector style can be used to list or watch via REST client. e.g, targeting `apiserver` with `kubectl`
      - `kubectl get pods -l environment=production, tier=frontend`
      - `kubectl get pods -l 'environment in (production), tier in (frontend)'`
    - set-based requirements are more expressive - they can implement OR operator
      - `kubectl get pods -l 'environment in (production, qa)'` selects `qa` or `production`
      - `kubectl get pods -l 'environment, environment notin(frontend)'` selects resources which has `environment` and it cannot be `frontend` (if i wrote `environment notin(frontend)` only, it would select the resources which doesn't have `environment` key also)
    - `services` and `replicationcontrollers` also use label selectors to select other resources as `pods`
      - only equality-based requirements are supported (QJenny: is this restriction for deploy/pods too?)
    - newer resources, such as `job`, `deployment`, `replicaset`, `daemon set` support set-baed requirements
    ```
		selector:
			matchLabels:
				component: redis
			matchExpressions:
				- {key: tier, operator: In, values: [cache]}
				- {key: environment, operator: NotIn, values: [dev]}
    ```
    - `matchExpressions` is a list of label selector requirements. The requirements are ANDed. +optional
      - `key` is the label key that the selector applies to. type: string
      - `operator` represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist.
      - `values` is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch. +optional (QJenny: merge patch?)
    - All of the requirements, from both matchLabels and matchExpressions are ANDed together – they must all be satisfied in order to match.


## Annotations
  - to attach arbitrary non-identifying metadata to objects. Clients such as tools and libraries can retrieve this metadata.
  - labels are used to identify and select objects. annotations are not.
  - can include characters not permitted by labels
  ```
	"metadata": {
		"annotations": {
			"key1" : "value1",
			"key2" : "value2"
		}
	}
  ```
  - Instead of using annotations, you could store this type of information in an external database or directory, but that would make it much harder to produce shared client libraries and tools for deployment, management, introspection, and the like. (QJenny: [examples are given](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/#attaching-metadata-to-objects))


## Field Selectors
  - select k8s objects based on the value of one or more fields.
  - `kubectl get pods --field-selector status.phase=Running` selects all pods for which the value of `status.phase` is `Running`
  - `metadata.name=my-service`, `metadata.namespace!=default`, `status.phase=Pending`
  - using unsupported fields gives error `kubectl get ingress --field-selector foo.bar=baz` gives error `Error from server (BadRequest): Unable to find "ingresses" that match label selector "", field selector "foo.bar=baz": "foo.bar" is not a known field selector: only "metadata.name", "metadata.namespace"` (QJenny: what the f is ingress)
  - supported operator are `=`, `==`, `!=` (first two are same). `kubectl get services --field-selector metadata.namespace!=default`
  - `kubectl get pods --field-selector metadata.namespace=default,status.phase=Running` ANDed
  - multiple resource types can also be selected
    - `kubectl get statefulsets,services --field-selector metadata.namespace!=default`
  - multiple resource is also allowed for labels too: `kubectl get pod,deploy -l run=booklistkube2` also works


## Recommended Labels
  - https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/
  - QJenny


## K8s object management techniques
  - A Kubernetes object should be managed using only one technique. Mixing and matching techniques for the same object results in undefined behavior.
  - 
  ```
	Management techniques							Operates on						Recommended environment		Supported writers		Learning curve
	Imperative commands								Live objects					Development projects			1+									Lowest
	Imperative object configuration		Individual files			Production projects				1										Moderate
	Declarative object configuration	Directories of files	Production projects				1+									Highest
  ```
  QJenny

### Imperative commands
  - `kubectl run nginx --image nginx`
  - `kubectl create deployment nginx --image nginx`
  - simple, easy to learn, single step
  - doesn't record changes, doesn't provide template


### Imperative object configuration
  - `kubectl create -f nginx.yaml`
  - `kubectl delete -f <name>.yaml -f <name>.yaml`
  - `kubectl replace -f <name>.yaml`
  - Warning: The imperative replace command replaces the existing spec with the newly provided one, dropping all changes to the object missing from the configuration file. This approach should not be used with resource types whose specs are updated independently of the configuration file. Services of type LoadBalancer, for example, have their externalIPs field updated independently from the configuration by the cluster. (QJenny)
  - compared with imperative commands:
    - can be stored, provides template
    - must learn, additional step writing YAML
  - compated with declarative object config:
    - simpler and easier to learn, more mature
    - works best on files, not directories. updates to live objects must be reflected in config file or they will be lost in next replacement (QJenny)
  - QJenny: does flags in kubectl command overwrite corresponding .yaml file flags?


### Declarative object configuration
  - When using declarative object configuration, a user operates on object configuration files stored locally, however the user does not define the operations to be taken on the files. Create, update, and delete operations are automatically detected per-object by kubectl. This enables working on directories, where different operations might be needed for different objects. QJenny
  - Note: Declarative object configuration retains changes made by other writers, even if the changes are not merged back to the object configuration file. This is possible by using the patch API operation to write only observed differences, instead of using the replace API operation to replace the entire object configuration. QJenny
  - `kubectl diff -f configs/` to see what changes are going to be made
  - `kubectl apply -f configs/` process all object configuration files in the configs directory
  - `kubectl diff -R -f configs/`, `kubectl apply -R -f configs/` recursively processs directories
  - changes made directly to live objects are retained, even if they are not merged. has better support for operating on directories and automatically detecting opeartion types (create, patch, delete) per-object
  - harder to debug and understand results, partial updates using diffs create complex merge and patch operations.
  - QJenny: the whole thing


## Using Imperative commands:
  - `run`: create a new deploy to run containers in one or more pods
  - `expose`: create a new service to load balance traffic across pods
  - `autoscale`: create a new autoscaler object to automatically horizontally scale a controller, such as a deployment.
  - `create`: driven by object type
    - `create <objecttype> [<subtype>] <instancename>`
    - `kubectl create service nodeport <name>` QJenny: how to use?
  - `scale` horizontally scale a controller to add or remove
  - `annotate` add or remove an annotation
  - `label` add or remove a label
  - `set` set/edit an aspect (env, image, resources, selector etc) of an object
  - `edit` directly edit the config file
  - `patch` directly modify specific fields of a live object by using a patch string (QJenny)
  - `delete` deletes an object
  - `get`
  - `describe`
  - `logs` prints the stdout and stderr for a container running in a pod
  - `kubectl create service clusterip <name> --clusterip="None" -o yaml --dry-run | kubectl set selector --local -f - 'environment=qa' -o yaml | kubectl create -f -`
    - `create` command cannot take every fields as flags. used create + set to do this (using `set` command to modify objects before creation)
    - `kubectl create service -o yaml --dry-run` command creates the config file for the service, but prints it to stdout as YAML instread sending it to k8s API
      - `--dry-run` if it is true, only print the object that would be sent, without sending it.
    - `kubectl set selector --local -f - -o -yaml` reads the config file from stdin, write the updated configuration to stdout as YAML
    - `kubectl create -f -` command creates the object using the config provided via stdin
    - QJenny: `--local`
  - 
  ```
  kubectl create service clusterip <name> --clusterip="None" -o yaml --dry-run > /tmp/srv.yaml
  kubectl create --edit -f /tmp/srv.yaml
  ```
    - `kubectl create service` creates the config for the service and saves it to `/tmp/srv.yaml`
    - `kubectl create --edit` open the config file for editiog before creating


## Using imperative object configuration
  - `kubectl create -f <filename/url>` creates an object from a config file
  - `kubectl replace -f <filename/url>`
    - Warning: Updating objects with the replace command drops all parts of the spec not specified in the configuration file. This should not be used with objects whose specs are partially managed by the cluster, such as Services of type LoadBalancer, where the externalIPs field is managed independently from the configuration file. Independently managed fields must be copied to the configuration file to prevent replace from dropping them. QJenny
  - `kubectl delete -f <filename/url>` QJenny - how does this work?
    - ever if changes are made to live config file of the object - `delete <object-config>.yaml` also works too
  - `kubectl get -f <filename/url> -o yaml` show objects. `-o yaml` shows the yaml file
  - limitation: created a deployment from a yaml file. edited the `kubectl edit deploy <name>` (note that, this is not the yaml file from which I created the object. this is called `live configuration`, this is saved in `/tmp/`). then `kubectl replace -f <object-config>.yaml` creates the object from scratch. the edit is gone. works for every kind of object.
  - `kubectl apply` if multiple writers are needed.
  - `kubectl create -f <url> --edit` edits the config file from the url, then create the object.
  - `kubectl get deploy <name> -o yaml --export > <filename>.yaml` exports the live object config file to local config file
    - then remove the status field (interestingly, the status field is automatically after exporting, although `kubectl get deploy <name> -o yaml` has the status field)
    - then run `kubectl replace -f <filename>.yaml`
    - this solves the `replace` problem
  - Warning: Updating selectors on controllers is strongly discouraged. (QJenny: because it would affect a lot?)
    - The recommended approach is to define a single, immutable PodTemplate label used only by the controller selector with no other semantic meaning. (significant labels. doesn't have to be changed again)




## [Using Declarative object configuration](https://kubernetes.io/docs/concepts/overview/object-management-kubectl/declarative-config/) (UJenny)
  - `object config file` defines the config for k8s object.
  - `live object config`/`live config` values an object, as observed by k8s cluster. this is typically stored in `etcd` (QJenny isn't it saved in `/tmp/`)
  - `declaration config writer`/`declarative writer` a person or software component that makes updates to a live object.

## Nodes
  - worker machine in k8s, previously knows as `minion`
  - maybe vm or physical machine
  - each node contains the services necessary to run pods
  - the services on a node include docker, kubelet, kube-proxy
  - a node's status contains - addresses, condition, capacity, info
  - Node is a top-level resource in the k8s REST API. (QJenny)

### Addresses
  - usage of these fields depends on your cloud provider or bare metal config
  - `HostName` the hostname as reported by the node's kernel. can be overridden via the kubelet `--hostname-override` parameter
  - `ExternalIP` available from outside the cluster
  - `InternalIP` within the cluster

### Condition
  - describes the status of all running nodes
  - `OutOfDisk` `True` if there is insufficient free space on the node for adding new pods, otherwise `False`
  - `Ready` `True` if the node is healthy and ready to accept pods, `False` if the node is not healthy and is not accepting pods and `Unknown` if the node controller has not heard from the node in the last `node-monitor-grace-period` (default is 40 seconds)
  - `MemoryPressure` `True` if pressure exists on the node memory - that is, if the node memory is low; otherwise `False`
  - `PIDPressure` `True` if pressure exists on the processes - that is, if there are too many processes on the node, otherwise `False`
  - `DiskPressure` `True` if pressure exists on the disk size - that is, if the disk capacity is low; otherwise `False`
  - `NetworkUnavailable` `True` if the network for the node is not correctly configured, otherwise `False`
  - 
  ```
  "conditions": [
		{
			"type": "Ready",
			"status": "True"
		}
	]
  ```
  - if the status of the `Ready` condition remains `Unknown` or `False` for longer than `pod-eviction-timeout` (default 5m), an argument is passed to `kube-controller-manager` and all the pods on the node are scheduled for deletion by Node Controller. if apiserver cannot communicate with kubelet on the node, the deletion decision cannot happen until the communication is established again. in the meantime, the pods on the node continues to run, in `Terminating` or `Unknown` state.
  - prior to version 1.5, node controller force deletes the pods from the apiserver. from 1.5, if k8s cannot deduce if the node has permanently left the cluster, admin needs to delete the node by hand. then all pods will be deleted with the node.
  - in version 1.12, `TaintNodesByCondition` feature is promoted to beta，so node lifecycle controller automatically creates taints that represent conditions. Similarly the scheduler ignores conditions when considering a Node; instead it looks at the Node’s taints and a Pod’s tolerations. users can choose between the old scheduling model and a new, more flexible scheduling model. A Pod that does not have any tolerations gets scheduled according to the old model. But a Pod that tolerates the taints of a particular Node can be scheduled on that Node. Enabling this feature creates a small delay between the time when a condition is observed and when a taint is created. This delay is usually less than one second, but it can increase the number of Pods that are successfully scheduled but rejected by the kubelet. (QJenny)

### Capacity
  - describes the resources available on the node: cpu, memory, max no of pods that can be scheduled

### Info
  - general information about the node, such as kernel version, k8s (kubelet, kube-proxy) version, docker version, os name. these info are gathered by kubelet


## Node Management
  - unlike pods and services, a node is not inherently created by k8s. it is created by cloud providers, e.g, google compute engine or it exists in your pool of physical or vm. so when k8s creates a node, it creates an object that represents the node. then k8s checks whether the node is valid or not.
  - 
  ```
  {
		"kind": "Node",
		"apiVersion": "v1",
		"metadata": {
			"name": "10.240.79.157",
			"labels": {
				"name": "my-first-k8s-node"
			}
		}
	}
  ```
    - k8s creates a node object internally (the representation) and validates the node by health checking based on `metadata.name`. if it is valid, it is eligible to run a pod. otherwise, it is ignored for any cluster until it becomes valid. k8s keeps the object for the invalid node and keeps checking. to stop this process, you have to explicitly delete this node.
    - there are 3 components that interact with the k8s node interface: node controller, kubelet, kubectl

### Node Controller
  - k8s master component which manages varioud aspects of nodes
  - first role is assigning a CIDR block to a node when it is registered (if CIDR assignment is turned on)
  - second is keeping the node controller's internal list of nodes up to date with the cloud provider's list of available machines. when a node is unhealthy, the node controller asks the cloud provider if the vm for that node is still available. if not, the node controller deletes the node from its list of nodes.
  - third is monitoring the nodes' health. the node controller is responsible for updating the NodeReady condition of NodeStatus to ConditionUnknown when a node becomes unreachable and then later evicting all the pods from the node if the node continues to be unreachable(`--node-monitor-grace-period` is 40s and `pod-eviction-timeout` is 5m by defautl). the node controller checks the state of each node every `--node-monitor-period` seconds (default 5s) (QJenny where are these flags???)
  - prior to 1.13, NodeStatus is the heartbeat of a node. from 1.13, node lease feature is introduced. when this feature is enabled, each node has an associated `Lease` object in `kube-node-lease` namespace. both NodeStatus and node lease are treated as heartbeats. Node leases are updated frequently and NodeStatus is reported from node to master only when there is some change or some time(default 1 minute) has passed, which is longer than default timeout of 40 seconds for unreachable nodes. Since node lease is much more lightweight than NodeStatus, this feature makes node heartbeat cheaper.
  - Node controller limits the eviction rate to `--node-eviction-rate` (default 0.1) per second, meaning it won't evict pods from more than 1 node per 10 seconds.
    - If your cluster spans multiple cloud provider availability zones (otherwise its one zone), node eviction behavior changes when a node in a given availability becomes unhealthy.
    - Node controller checks the percentage of unhealthy nodes (`NodeReady` is `False` or `ConditionUnknown`). If the fraction is at least `--unhealthy-zone-threshold` (default 0.55) then the eviction rate is reduced - if the cluster is small (less than or equal to `--large-cluster-size-threshold`, default 50 nodes), then evictions are stopped, otherwise the eviction rate is reduced to `--secondary-node-eviction-rate` (default 0.01) per second.
    - This is done because one availability zone might become partitioned from the master while the others remain connected.
    - Key reason for spreading the nodes across availability zone is that workload can be shifted to healthy zones when one entire zone goes down.
    - Therefore if all nodes in a zone are unhealthy then node controller evicts at the normal rate `--node-eviction-rate`
    - Corner case is, if all zones are completely unhealthy, node controller thinks there's some problem with master connectivity and stops all evictions until some connectivity is restored.
    - Starting in Kubernetes 1.6, the NodeController is also responsible for evicting pods that are running on nodes with NoExecute taints, when the pods do not tolerate the taints. Additionally, as an alpha feature that is disabled by default, the NodeController is responsible for adding taints corresponding to node problems like node unreachable or not ready. See this documentation for details about NoExecute taints and the alpha feature. Starting in version 1.8, the node controller can be made responsible for creating taints that represent Node conditions. This is an alpha feature of version 1.8. (QJenny)

### Self-Registration of Nodes (QJenny)
  - When the kubelet flag `--register-node` is true (the default), the kubelet will attempt to register itself with the API server.
  - `--kubeconfig` path to credentials to authenticate itself to the apiserver
  - `--cloud-provider` how to talk to a cloud provider to read metadata about itself
  - `--register-node` automatically register with the API server
  - `--register-with-taints` register the node with the given list of taints (comma separated <key>=<value>:<effect>) No-op if `register-node` is false
  - `--node-ip` ip address of the node
  - `--node-labels` labels to add when registering the node in the cluster
  - `--node-status-update-frequency` specifies how often kubelet posts node status to master
#### [Manual Node Administration](https://kubernetes.io/docs/concepts/architecture/nodes/#manual-node-administration) (UJenny)



## Node capacity
  - Number of cpus and amount of memory
  - Normally nodes register themselves and report their capacity when creating node object
  - K8s scheduler ensures that there are enough resources for all thepods on a node. The sum of the requests of containers on the node must be no greater than the node capacity. (It includes all containers started by the kubelet, not the ones started directly by dockers nor any process running outside of the containers)
  - If you want to explicitly reserve resources for non-pod processes, you can create a placeholder pod. QJenny
  ```
  apiVersion: v1
	kind: Pod
	metadata:
		name: resource-reserver
	spec:
		containers:
		- name: sleep-forever
			image: k8s.gcr.io/pause:0.8.0
			resources:
				requests:
					cpu: 100m
					memory: 100Mi
  ```
	- set the cpu and memory values to the amount of resources you want to reserve. Place the file in the manifest directory (`--config=DIR` flag of kubelet). do this on every kubelet you want to reserve resources. QJenny




















# To Do:
  - make list of all the ports/ip
  - you need get, create, patch permissin for `kubectl apply` (dipta vai)



###### To be cleared:
- `minikube start` command initializes `kubeadm, kubelet, certs, cluster, kubeconfig`
- Kubernetes is microservices platform
