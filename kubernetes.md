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
  - Diagram: https://d33wubrfki0l68.cloudfront.net/99d9808dcbf2880a996ed50d308a186b5900cec9/40b94/docs/tutorials/kubernetes-basics/public/images/module_01_cluster.svg
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
  - Once instances of the app are created, a Kubernetes Deployment Controller continuously monitors these instances. If an Node containing an instances goes down,the Deployment controller replaces it. This provides a self-healing mechanism.
  - Before: scripts were used to start the app, but doesn't help to recover. Now: Controller keeps them running.
  - Diagram: https://d33wubrfki0l68.cloudfront.net/152c845f25df8e69dd24dd7b0836a289747e258a/4a1d2/docs/tutorials/kubernetes-basics/public/images/module_02_first_app.svg
### kubectl
  - kubectl is a command line interface that communicates with the cluster using the k8s api.
  - To deploy, you need to specify the container image and number of replicas to run. You can change the info by updating the Deployment.
  - `kubectl run <deployment-name> --image=<image-name> --port=<8080-or-something-else`
    - `kubectl run` command creates a new Deployment. It need deployment name and app image location (if the image aren't hosted on DockerHub, needs to include full repo url). Also needs specific port to run
    - this command searched for a Node where an instance of the app could be run
    - scheduled the app to run on that Node
    - configured the cluster to reschedule the instance on a new node when needed
    - Q: fahim couldn't run the deployment because he didn't have `EXPOSE` in his Dockerfile. After adding the line, deployment ran. And `--port` value in `kubectl run` command doesn't have to match `EXPOSE` value. Why?
  - `kubectl get deployments` shows the deployments, their instances and state.
  - `kubectl proxy` creates a proxy - so far kubectl were communicating with k8s cluster using api, but after proxy command we can communicate with k8s api too (through browser or curl)


## Pods and Nodes
### K8s Pods
  - A pod represents one or more containers and has some shared storage as Volumes, networking as a unique cluster IP address, information about each container such as image version or which ports to use.
  - A pod models an application-specific "logical host" and can contain different application which are relatively tightly coupled.
  - The contains in same Pod share an IP address and port space - co-located/co-scheduled/runs-in-same-context
  - Pods are atomic unit on K8s platform. A deployment creates Pods with containers inside them. Each pod is tied to its Node, where it is scheduled. When a Node fails, identical pods are scheduled on other available Nodes in the cluster.
  - Diagram: https://d33wubrfki0l68.cloudfront.net/fe03f68d8ede9815184852ca2a4fd30325e5d15a/98064/docs/tutorials/kubernetes-basics/public/images/module_03_pods.svg
### Nodes
  - One node is either one physical machine (laptop) or virtual machine (I can create more than one node in my laptop with VM). A node can have multiple pods and k8s master automatically handles scheduling the pods across the Nodes in the cluster, based on the resources available on each Node.
  - One node has kubelet - a process responsible for communicating with the Master. It manages pods and containers.
  - Node contains container runtime too (Docker/rkt) which pulls the container image, unpacks the container and runs the pp.
  - Diagram: https://d33wubrfki0l68.cloudfront.net/5cb72d407cbe2755e581b6de757e0d81760d5b86/a9df9/docs/tutorials/kubernetes-basics/public/images/module_03_nodes.svg
### Commands
  - `kubectl get pods` lists pods.
  - `kubectl describe pods` shows details (yaml?)
  - `kubectl proxy` - As pods are running in an isolated, private network - we need to proxy access to them so we can interact with them.
  - `kubectl logs <pod-name>` - Anything that the application would normally send to STDOUT becomes logs for the container within the Pod (ommitted name of container as we have only one container now)
  - `kubectl exec <pod-name> <command>` - we can execute commands directly on the container once the Pod is up and running. (here we ommitted the container name as there's only one container in our pod)
    - `kubectl exec -it <pod-name> bash` - lets us use the bash inside the container(again, we have one container)
    - we can use `localhost:8080` to from inside the container







# Or you could start with the basics:
- https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/

## Kubernetes:
- Open-source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation.
- A container platform/a microservices platform/a portable cloud platform and a lot more.
- [Google's Borg system is a cluster manager that runs hundreds of thousands of jobs, from many thousands of different applications, across a number of clusters each with up to tens of thousands of machines.]
- Continuous Integration, Delivery, and Deployment (CI/CD)
- why containers?
  - The Old Way to deploy applications was to install the applications on a host using the operating-system package manager. This had the disadvantage of entangling the applications’ executables, configuration, libraries, and lifecycles with each other and with the host OS. One could build immutable virtual-machine images in order to achieve predictable rollouts and rollbacks, but VMs are heavyweight and non-portable.
  - The New Way is to deploy containers based on operating-system-level virtualization rather than hardware virtualization. These containers are isolated from each other and from the host: they have their own filesystems, they can’t see each others’ processes, and their computational resource usage can be bounded. They are easier to build than VMs, and because they are decoupled from the underlying infrastructure and from the host filesystem, they are portable across clouds and OS distributions.
  - Containers are small and fast. So one-to-one application-to-image relation if built.





































###### To be cleared:
- `minikube start` command initializes `kubeadm, kubelet, certs, cluster, kubeconfig`
- Kubernetes is microservices platform
