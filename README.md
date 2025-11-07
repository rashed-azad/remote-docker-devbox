````markdown
# Remote Devbox Docker Setup

This repository contains a **Debian-based remote development Docker image** with SSH access, Python 3.11, essential development tools, and common utilities. Perfect for coding, testing, and remote development from any host machine.

---

## 🐳 Build the Docker Image

Before running, build your image from the Dockerfile:

```bash
docker build -t remote-devbox .
````

* `-t remote-devbox`: Tag the image for easy reference.
* `.`: Build context (current directory).

---

## 🚀 Run the Container

Run the container in **detached mode** with SSH access:

```bash
docker run -d \
    --hostname remote-devbox \
    -p 2222:22 \
    -v ~/Documents:/home/rashed/Documents \
    --name remote-devbox \
    remote-devbox
```

* `-d`: Run container in the background (detached mode).
* `-p 2222:22`: Map host port 2222 to container SSH port 22.
* `-v ~/Documents:/home/rashed/Documents`: Mount your local `Documents` folder inside the container for easy file sharing.
* `--name remote-devbox`: Give your container a memorable name.
* `remote-devbox`: The image to run.

---

## 🔑 Connect via SSH

```bash
ssh rashed@localhost -p 2222
```

* `rashed`: Username inside the container.
* `-p 2222`: Connect to the mapped SSH port.

> Default password: `rashed` (change it for production!)

---

## 🧰 Common Docker Commands

| Command                                   | Purpose                                       |
| ----------------------------------------- | --------------------------------------------- |
| `docker images`                           | list images                                   |
| `docker images -q`                        | list image IDs only (quiet / for scripting)   |
| `docker ps`                               | list running containers                       |
| `docker ps -a`                            | list all containers                           |
| `docker ps -q`                            | list container IDs only                       |
| `docker stop <container>`                 | stop a running container                      |
| `docker start <container>`                | start an existing container                   |
| `docker rm <container>`                   | remove a stopped container                    |
| `docker rm -f <container>`                | force remove container (even if running)      |
| `docker rmi <image>`                      | remove unused image                           |
| `docker rmi -f <image>`                   | force remove image                            |
| `docker rm $(docker ps -aq)`              | remove **all** containers                     |
| `docker rmi -f $(docker images -q)`       | remove **all** images                         |
| `docker image prune`                      | remove dangling untagged images               |
| `docker image prune -f`                   | remove dangling untagged images (auto yes)    |
| `docker build -t <tag> .`                 | build image from Dockerfile with tag          |
| `docker run -d ... --name <name> <image>` | run container detached + friendly name        |
| `docker exec -it <container> bash`        | open bash shell inside a running container    |
| `docker logs <container>`                 | see logs                                      |
| `docker inspect <container>`              | view full JSON metadata (IP, volumes, config) |

---

## 💡 Tips to Remember

1. **Ports**: `-p host:container` → Host port first, container port second.
2. **Volumes**: `-v host:container` → Maps host folder to container folder for persistent data.
3. **Detached Mode**: `-d` → Runs container in the background.
4. **Enter container**: Use `docker exec -it` instead of stopping & restarting.
5. **Clean up**: `docker rm` for containers and `docker rmi` for images to save disk space.

---

## ✅ Example Workflow

1. Build the image:

```bash
docker build -t remote-devbox .
```

2. Start the container:

```bash
docker run -d --hostname remote-devbox -p 2222:22 -v ~/Documents:/home/rashed/Documents --name remote-devbox remote-devbox
```

3. Connect via SSH:

```bash
ssh rashed@localhost -p 2222
```

4. Enter container interactively if needed:

```bash
docker exec -it remote-devbox bash
```

5. Stop the container when done:

```bash
docker stop remote-devbox
```