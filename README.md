# INCEPTION
![inception image](https://i.imgur.com/WzZTtGz.png)
This project is about setting up a small infrastructure composed of different services using Docker & Docker Compose.
## Table of contents
1. [Docker definition](https://github.com/Suigetsu/42_Inception/new/main?filename=README.md#docker-definition)
   - [OS-LEVEL VIRTUALIZATION](https://github.com/Suigetsu/42_Inception/new/main?filename=README.md#os-level-virtualization)
       - [Namespaces](https://github.com/Suigetsu/42_Inception/new/main?filename=README.md#namespaces)
       - [Cgroups](https://github.com/Suigetsu/42_Inception/edit/main/README.md#cgroups)
   - [Linux Containers (LXC)](https://github.com/Suigetsu/42_Inception/edit/main/README.md#linux-containers-lxc)
       - [LXC vs Docker](https://github.com/Suigetsu/42_Inception/edit/main/README.md#lxc-vs-docker)
   - [How does Docker work?](https://github.com/Suigetsu/42_Inception/edit/main/README.md#how-does-docker-work)
       - [Docker ecosystem](https://github.com/Suigetsu/42_Inception/edit/main/README.md#docker-ecosystem)
       - [Docker Engine](https://github.com/Suigetsu/42_Inception/edit/main/README.md#docker-engine)
       - [Docker Compose](https://github.com/Suigetsu/42_Inception/edit/main/README.md#docker-compose)
   - [Containers vs VMs](https://github.com/Suigetsu/42_Inception/edit/main/README.md#containers-vs-vms)
   - [Daemons](https://github.com/Suigetsu/42_Inception/edit/main/README.md#daemons)
2. [Project's Structure](https://github.com/Suigetsu/42_Inception/edit/main/README.md#projects-structure)
3. [The project's requirements](https://github.com/Suigetsu/42_Inception/edit/main/README.md#the-projects-requirements)
4. [Resources](https://github.com/Suigetsu/42_Inception/edit/main/README.md#resources)

## Docker definition
**_Docker_** is a **_containerization platform_** that uses **OS-level virtualization** to deliver software in packages called **containers**.

**_Docker_** initially used **LXC (Linux Containers)** as its container runtime to provide containerization functionality.
LXC is a user-space interface for the Linux kernel's container features, leveraging the kernel's cgroups and namespaces for resource management and isolation.
However, Docker eventually moved away from LXC and developed its own container runtime called **libcontainer**, which provided more flexibility and control.
**Libcontainer** became the foundation for the **Open Container Initiative (OCI)** specification, and its reference implementation, **runc**, is now the standard low-level container runtime.

In 2016, **_Docker_** separated its container management component into a standalone project called **containerd**.
**Containerd** is a high-level container runtime that manages the complete container lifecycle, including image transfer, container execution, and storage.
It uses **runc** under the hood to handle the actual container execution.
### OS-LEVEL VIRTUALIZATION
A virtualization paradigm in which the **kernel** allows the existence of multiple isolated user-space instances, known as **containers**.
These instances share the same operating system kernel but are isolated from each other using **kernel features** such as **_namespaces_** (for isolation) and **_cgroups_** (for resource management).
In simpler terms, it enables the creation of lightweight, isolated environments (containers) on top of a single operating system.

Docker is a technology developed to to manage containers efficiently. But you can have/create containers by using “namespaces” and “cgroups”

> Basically these features let you pretend you have something like a virtual machine, except it’s not a virtual machine at all, it’s just processes running in the same Linux kernel. [What even is a container: namespaces and cgroups](https://jvns.ca/blog/2016/10/10/what-even-is-a-container/)
#### Namespaces
Linux namespaces are a feature of the Linux kernel that isolate and virtualize system resources for processes.
Each namespace provides a separate instance of specific resources (such as process IDs, network interfaces, mount points, etc.), ensuring that processes in one namespace cannot directly interact with or see resources in another namespace.
This isolation is a key component of containerization, enabling lightweight and efficient environments that mimic the behavior of separate systems.

When using containers during development, developers get an isolated environment that behaves like a complete virtual machine (VM).
However, unlike a VM, a container is not a full-fledged virtualized operating system.
Instead, it is a process (or group of processes) running on the host operating system, isolated using namespaces and cgroups.
For example, if a developer starts two containers, they are essentially running two isolated processes on the same server, but these processes are completely isolated from each other due to namespaces.


In the diagram, there are three **PID namespaces**: a parent namespace and two child namespaces.
Within the parent namespace, there are four processes labeled **PID1** through **PID4**.
These processes can see and interact with each other since they share the same PID namespace.

The processes with **PID2** and **PID3** in the parent namespace also belong to their own child PID namespaces.
Within these child namespaces, these processes are assigned **PID1** because they are the first (and only) processes in their respective namespaces.

From within a child namespace, the process with **PID1** cannot see or interact with processes outside its namespace.
For example, **PID1** in both child namespaces cannot see **PID4** in the parent namespace.
This isolation is a key feature of PID namespaces, ensuring that processes in different namespaces are unaware of each other, even though they may be running on the same host.
![image](https://github.com/user-attachments/assets/48430963-be0b-4e38-9afe-05213e8e0a51)

To create a namespace, we use the unshare command (refer to man unshare for more details).
```
~# unshare --user --pid --map-root-user --mount-proc --fork bash
```
The command above creates a new namespace and runs the bash command within it. Here's a breakdown of the options:

    --user: Creates a new user namespace. This allows processes inside the namespace to have different user and group IDs compared to those outside the namespace. It provides isolation for user-related attributes, enabling non-root users to act as root within the namespace.

    --pid: Creates a new PID namespace. Processes inside this namespace will have their own isolated process IDs, separate from processes outside the namespace. This ensures that processes in the namespace cannot see or interact with processes in other namespaces.

    --map-root-user: Maps the root user (UID 0) inside the namespace to the calling user outside the namespace. This allows a non-root user to create a user namespace and still appear as the root user inside that namespace, enabling administrative tasks within the namespace.

    --mount-proc: Mounts a new /proc filesystem inside the namespace. The /proc filesystem provides information about processes and system resources. Mounting it inside the namespace ensures that processes within the namespace see only their own process information, maintaining isolation.

    --fork: Forks a new child process before executing the specified command (bash in this case). The new process runs in the newly created namespace, ensuring proper isolation.

    bash: The command to run in the new namespace. In this case, it starts an interactive Bash shell within the namespace, allowing you to work in the isolated environment.


As you can see there is a difference, in the first example we created a whole new namespace and our bash was in an isolated place being the only process in that place, meanwhile in the second example we ran bash directly in our parent namespace. 
After running ps command, you can see that it's not isolated.

<img width="824" alt="image(1)" src="https://github.com/user-attachments/assets/7ebb91fd-5d0c-49b4-bbff-bb272a1d7aba" />
<img width="817" alt="image(2)" src="https://github.com/user-attachments/assets/85e9ac46-114c-4b79-83a3-4ce749f99adb" />

#### Cgroups
A Linux kernel feature that enables the management and isolation of system resources for groups of processes.
> Cgroups allow you to allocate resources — such as CPU time, system memory, network bandwidth, or combinations of these resources — among user-defined groups of tasks (processes) running on a system. You can monitor the cgroups you configure, deny cgroups access to certain resources, and even reconfigure your cgroups dynamically on a running system.
> [Chapter 1. Introduction to Control Groups (Cgroups)](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/6/html/resource_management_guide/ch01#idm139819585387936)

This is an example of how to use Cgroups.

If you like this kind of examples please consider checking and supporting this [zine](https://wizardzines.com/zines/containers/) made by [Julia Evans](https://x.com/b0rk).
![image(3)](https://github.com/user-attachments/assets/0d6251ce-51c3-40c8-b1bc-33be8608a5a6)

### Linux Containers (LXC)
Just like Docker, LXC is a well-known Linux container runtime that consists of tools, templates, and library and language bindings.
It's pretty low level, very flexible and covers just about every containment feature supported by the upstream kernel.

LXC is often used for system containers, which behave more like traditional virtual machines, providing a full operating system environment within the container.
It is highly customizable and can be used to build containerized environments tailored to specific needs. [Learn more](https://linuxcontainers.org/lxc/introduction/)

#### LXC vs Docker
<img width="873" alt="image" src="https://github.com/user-attachments/assets/942feda4-153f-42ae-b0bc-3e5b808b9a8c" />

To keep it short, LXC is more flexible since it's low level.
You get to use the Kernel features in anyway you want, and basically, like a VM, you can install and configure anything you want with the container.

On the other hand, there is an engine that handles all the low level operations when using Docker.
So it's super friendly for people with no prior linux knowledge. Also Docker comes with a rich ecosystem of tools (e.g., Docker Compose, Docker Swarm) and a vast library of pre-built images, making it ideal for modern DevOps workflows.

### How does Docker work?
**_Docker_** uses a **client-server architecture** to manage containers. Here’s how it works:
   - **Docker Client**: The **Docker client** is the primary way users interact with **_Docker_**. It sends commands (e.g., ```docker build```, ```docker run```) to the **Docker daemon**.
        The client can run on the same system as the daemon or connect to a remote **Docker daemon**.
   - **Docker Daemon**: The **Docker daemon** (**dockerd**) is the server component that does the heavy lifting. It handles tasks like:
        - Building Docker images.
        - Running containers.
        - Managing storage and networking for containers.
        - Distributing images via Docker registries (e.g., Docker Hub).
          
        The daemon listens for requests from the Docker client and executes them.
   - **Communication**: The **Docker client** and daemon communicate using a **REST API**.
        Communication can occur over:
        - UNIX sockets (for local communication on the same system).
        - Network interfaces (for remote communication).
   - **Docker Compose**: **Docker Compose** is another Docker client designed for managing multi-container applications.
        It allows you to define and run applications consisting of multiple containers using a single configuration file (**docker-compose.yml**).

#### Docker ecosystem
![image(1)](https://github.com/user-attachments/assets/855428cd-d59b-4c1d-b70c-0fa93d223b0d)

**Explaining the docker ecosystem components in details.**

![image](https://github.com/user-attachments/assets/5960cb99-36d9-4f4e-8d07-966a662353eb)

- Docker daemon
![image](https://github.com/user-attachments/assets/abb30053-4a0d-4944-a90e-227311328f73)

- Docker Image

An executable package of software that includes everything needed to run an application.
This image informs how a container should instantiate, determining which software components will run and how.

To Create A Docker Image:

   1- Create a Dockerfile
   
   2- Build the image using the Dockerfile, this command does the job: ```docker build -t <name>:<tag>```
   
   It will create a docker image of the application and download all the necessary dependencies needed for the application to run successfully.
   
   3- The image has been built and ready to be run. This command is an example of how to run your built image: ```docker run <image-name>:<tag>```
   
![image](https://github.com/user-attachments/assets/963b8334-c2b7-4b5b-a653-32e9082ed19d)

Dockerfile Definition:

A Dockerfile is a text file that contains instructions for building a Docker image.
It specifies the base image, sets up the environment, copies files, installs dependencies, and configures the application.
Docker uses the Dockerfile to create the layers that make up the final image.
Dockerfile create all the layers needed for an image. Starting from the base image to the regestry.  

Example of a Dockerfile
![image](https://github.com/user-attachments/assets/3644e25c-7a95-444a-94c8-68395923f1c2)

Structure of an image created by the Dockerfile:

   1- Base Image: The basic image will be the starting point for the majority of Dockerfiles, and it can be made from scratch.
   
   2- Layers: Docker images are composed of layers. Each instruction in a Dockerfile (the script used to build an image) creates a new layer.
   
   Layers are cached, which allows for efficient image building. When changes are made to an image, only the affected layers need to be rebuilt.
   
   3- Docker registry: A system for storing and distributing Docker images with specific names. It's like a repository where you can push your own images, make them public or private, or pull public images and build them.

![image](https://github.com/user-attachments/assets/719c931b-19f4-40af-a182-261a8b5412f4)

![image](https://github.com/user-attachments/assets/cd23ba34-fd3e-47be-aadc-eab6eeec0969)
[this cool medium article](https://medium.com/techmormo/how-do-docker-images-work-docker-made-easy-part-2-91d5c1a8d8a6)

- Docker Registeries
>> Docker Registry aids in development automation.
The docker registry allows you to automate building, testing, and deployment.
Docker registry may be used to create faster CI/CD pipelines, which helps to reduce build and deployment time.
Docker Registry is useful if you want complete control over where your images are kept.
A private Docker registry can be used. You gain total control over your applications by doing so.
In addition to controlling who may access your Docker images, you can determine who can view them.
Docker Registry can provide you with information about any issue you may encounter.
You may also completely rely on it for container deployment and access it at any moment. - [Source](https://www.geeksforgeeks.org/what-is-docker-registry/)

![image](https://github.com/user-attachments/assets/37c067e5-85cf-4833-82d4-87639c6a7168)

Different Types of Docker Registries:

1- DockerHub

2- Amazon Elastic Container Registry (ECR)

3- Google Container Registry (GCR)

4- Azure Container Registry (ACR)

![image](https://github.com/user-attachments/assets/d3a52c51-9be7-430d-84d9-de23a23eb51f)

- Docker Containers

![Screenshot from 2025-02-04 13-12-15](https://github.com/user-attachments/assets/5bbcf4a0-7efb-4d6a-8e96-1d3855a963ac)


#### Docker Engine

**Docker engine** consist of several key parts such as the docker daemon, an API interface, and Docker CLI.

![image](https://github.com/user-attachments/assets/32bc7299-7b4d-4fb3-a366-fd866c416404)

#### Docker Compose
A tool that will help us run multiple containers.
With Compose, you use a YAML file to configure your application's services.
Then, with a single command, you create and start all the services from your configuration.  

![image](https://github.com/user-attachments/assets/f9942808-4e74-461f-b114-d2cb479d6fe0)

### Containers vs VMs

![image](https://github.com/user-attachments/assets/67a7804b-a7b7-4ff8-b326-5ae3e6bd621c)

![Screenshot from 2025-02-04 13-17-33](https://github.com/user-attachments/assets/e7245b44-330e-4ade-9d16-8b449502e70f)

### Daemons
A process that runs in the background and is usually out of the control of the user.
They are utility programs that run silently in the background to monitor and take care of certain subsystems to ensure that the operating system runs properly.
A printer daemon monitors and takes care of printing services.
A network daemon monitors and maintains network communications, and so on.
Daemons perform certain actions at predefined times or in response to certain events.

Besides of daemons, there are two other types of processes: interactive and batch:
- Interactive processes: Interactive processes are those which are run by a user at the command line are called interactive processes.
- Batch: Batch processing is the method computers use to periodically complete high-volume, repetitive data jobs. Certain data processing tasks, such as backups, filtering, and sorting, can be compute intensive and inefficient to run on individual data transactions.

Interactive processes and batch jobs are not daemons even though they can be run in the background and can do some monitoring work.
The key is that these two types of processes involve human input through some sort of terminal control. Daemons do not need a person to start them up.

To list all services that start at boot:
```systemctl list-unit-files --type=service```

![Screenshot from 2025-02-04 13-22-11](https://github.com/user-attachments/assets/a49c94b5-9540-45e4-afdd-071dc05e68a9)

## Project's Structure
```
├── Makefile
├── README.md
├── srcs
│   ├── docker-compose.yml
│   └── requirements
│       ├── mariadb
│       │   ├── conf
│       │   │   ├── db_script.sh
│       │   │   └── mysql_install_db.sh
│       │   ├── Dockerfile
│       │   └── tools
│       ├── nginx
│       │   ├── conf
│       │   │   └── nginx_conf_script.sh
│       │   └── Dockerfile
│       ├── tools
│       │   └── volumes_script.sh
│       └── wordpress
│           ├── conf
│           │   ├── get_wordpress.sh
│           │   └── setup_wordpress.sh
│           ├── Dockerfile
│           └── tools
```
## The project's requirements
This project consists of setting up a small infrastructure composed of different services under specific rules.
The whole project has to be done in a virtual machine using docker compose.
Each Docker image must have the same name as its corresponding service.
Each service has to run in a dedicated container.
For performance matters, the containers must be built either from the penultimate stable version of Alpine or Debian, writing our own Dockerfiles, one per service.
The Dockerfiles must be called in docker-compose.yml by the Makefile.
It is then forbidden to pull ready-made Docker images, as well as using services such as DockerHub (Alpine/Debian being excluded from this rule).

Here is an example diagram of the expected result:

![image](https://github.com/user-attachments/assets/c1866b35-b697-4d18-b9d1-0362b166eee2)

## Resources

[Julia Evans](https://x.com/b0rk) Blog [What even is a container: namespaces and cgroups](https://jvns.ca/blog/2016/10/10/what-even-is-a-container/) and her [zines](https://wizardzines.com/zines/containers/)

Scott van Kalken's [Blog What Are Namespaces and cgroups, and How Do They Work?](https://blog.nginx.org/blog/what-are-namespaces-cgroups-how-do-they-work)

man [unshare](https://man7.org/linux/man-pages/man1/unshare.1.html)

Red Hat [Chapter 1. Introduction to Control Groups (Cgroups)](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/6/html/resource_management_guide/ch01)

[LXC](https://linuxcontainers.org/lxc/introduction/)

[Docker Engine](https://www.docker.com/products/container-runtime/)

Bibin Wilson's [What is Docker? How Does it Work?](https://devopscube.com/what-is-docker)

Farhim Ferdous's [How do Docker Images work? | Docker made easy #2](https://medium.com/techmormo/how-do-docker-images-work-docker-made-easy-part-2-91d5c1a8d8a6)

Geeks for Geeks's [What is Docker Registry?](https://www.geeksforgeeks.org/what-is-docker-registry/)

Bill Dyer's [Linux Jargon Buster: What are Daemons in Linux?](https://itsfoss.com/linux-daemons/)


