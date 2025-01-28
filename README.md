# INCEPTION
![inception image](https://i.imgur.com/WzZTtGz.png)
This project is about setting up a small infrastructure composed of different services using Docker & Docker Compose.
## Table of contents
1. [Docker definition](https://github.com/Suigetsu/42_Inception/new/main?filename=README.md#docker-definition)
   - [OS-LEVEL VIRTUALIZATION](https://github.com/Suigetsu/42_Inception/new/main?filename=README.md#os-level-virtualization)
       - [Namespaces](https://github.com/Suigetsu/42_Inception/new/main?filename=README.md#namespaces)
       - Cgroups
   - Linux Containers (LxC)
       - LxC vs Docker
   - How does Docker work?
       - Docker ecosystem
       - Docker Engine
   - Containers vs VMs
   - Daemons
2. Project's Structure
3. [The project's requirements](https://github.com/Suigetsu/ft_irc?tab=readme-ov-file#requirements)
4. [Resources](https://github.com/Suigetsu/ft_irc?tab=readme-ov-file#resources)
5. [Authors](https://github.com/Suigetsu/ft_irc?tab=readme-ov-file#authors)
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



