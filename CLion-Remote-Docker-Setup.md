````markdown
# CLion Remote Development Setup with Docker

This guide explains step by step how to configure CLion to use a Docker-based Debian development environment for remote C/C++ development.

---

## 1. Prerequisites

- Docker installed on your system (Mac, Windows, or Linux)
- CLion installed
- Your project folder on the host (e.g., `~/Documents`)

---

## 2. Run the Docker Container

Assuming you have built the Docker image named `remote-docker-devbox`:

```bash
# Run the container in detached mode, with SSH port and persistent project folder
docker run -d \
    --hostname remote-devbox \
    -p 2222:22 \
    -v ~/Documents:/home/rashed/Documents \
    --name remote-devbox \
    remote-docker-devbox
````

* **-d**: Run in background
* **-p 2222:22**: Map SSH port for remote access
* **-v ~/Documents:/home/rashed/Documents**: Mount project folder for persistence
* **--name remote-devbox**: Container name

---

## 3. Verify SSH Access

```bash
ssh rashed@localhost -p 2222
# password: rashed
```

---

## 4. Configure CLion Remote Toolchain

1. Open **CLion → Preferences → Build, Execution, Deployment → Toolchains**.

2. Click **+** → **Remote Host**.

3. Fill in the connection details:

   * **Host**: `localhost`
   * **Port**: `2222`
   * **Username**: `rashed`
   * **Authentication**: password (`rashed`)

4. Click **Test Connection** to ensure SSH is working.

---

## 5. Use Your Project Folder

* Your host folder (`~/Documents`) is mounted into `/home/rashed/Documents` in the container.
* Any changes you make from CLion or inside the container are **persistent**.

---

## 6. Stop / Restart Container

```bash
# Stop
docker stop remote-devbox

# Start
docker start remote-devbox

# Restart
docker restart remote-devbox
```