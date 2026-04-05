# Developer Documentation - Inception Project

*This technical guide is intended for developers who wish to modify, debug, or understand the infrastructure of the Inception stack.*

---

## 1. Environment Setup

### Conceptual Level
Before building the project, you need to prepare the "ground." This means installing the necessary tools and creating a secret file with all the keys and passwords that the services will use to talk to each other.

### Technical Level
* **Prerequisites**: Docker Engine (v24.0+), Docker Compose (v2.0+), and GNU Make.
* **Host Configuration**: Map the domain by adding `127.0.0.1 abaldelo.42.fr` to `/etc/hosts`.
* **Secrets**: Create a `.env` file in the `srcs/` directory. It must define:
    * `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`.
    * `DOMAIN_NAME=abaldelo.42.fr`.
    * `WP_ADMIN_USER`, `WP_ADMIN_PASSWORD`, `WP_USER`, `WP_PASSWORD`.

---

## 2. Build and Execution

### Conceptual Level
The project is built using a "recipe" called a Makefile. By running a single word, the system automatically downloads the base systems, installs the software, and wires the virtual cables between the containers.

### Technical Level
The workflow is managed via the `Makefile` located in the root:
* `make`: Triggers the `docker compose up --build`. It creates the Docker images from the Dockerfiles and launches the services in the background.
* `make re`: Forces a full rebuild by cleaning and restarting the stack.
* **Network Architecture**: All containers are joined in a custom bridge network (`inception_net`). Nginx is the only container with host port mapping (443:443).

---

## 3. Container & Volume Management

### Conceptual Level
As a developer, you have "X-ray vision" to see what's happening inside the containers. You can check the logs to see if there are errors or even "enter" a container to run commands directly as if you were inside it.

### Technical Level
Common developer commands:
* **Logs**: `docker logs <container_name>` (useful for debugging MariaDB init or PHP errors).
* **Interactive Shell**: `docker exec -it <container_name> /bin/bash`.
* **Inspection**: `docker network inspect inception_net` to verify IP assignments and connectivity.
* **Volume Cleanup**: `docker volume rm $(docker volume ls -q)` (use with caution).

---

## 4. Data Storage and Persistence

### Conceptual Level
One of the most important parts is making sure that if the power goes out or a container breaks, the data survives. We save the database and the website files in special folders on your computer so they are never lost.

### Technical Level
Persistence is achieved through **Bind Mounts** linked to the host's filesystem:
* **Database Path**: `/home/abaldelo/data/mysql` (maps to `/var/lib/mysql` in the container).
* **Website Path**: `/home/abaldelo/data/wordpress` (maps to `/var/www/html` in the container).
* **Lifecycle**: Data persists even if containers are removed (`docker compose down`). To wipe data completely, you must manually delete the host directories or use `make fclean`.