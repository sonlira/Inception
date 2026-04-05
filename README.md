*This project was created as part of the 42 curriculum by abaldelo.*

---

## 1. Description

### Conceptual Level
Inception is a system architecture exercise where a private and secure network infrastructure is built. The goal is to orchestrate several independent services (Nginx, MariaDB, and WordPress) to function as a single unit, using containers that isolate each process. It is like building a small digital city where each building has a specific function and strict communication rules.

### Technical Level
The project implements a LEMP stack (Linux, Nginx, MariaDB, PHP) using Docker Compose on Debian Bookworm. It focuses on operating system-level virtualization, ensuring each service is immutable and reproducible. The design prioritizes security through the use of TLS 1.3 and isolated networks to avoid unnecessary exposure of ports to the host.

---

## 2. Instructions

1.  **Configuration**: Edit your `/etc/hosts` file to include `127.0.0.1 abaldelo.42.fr`.
2.  **Variables**: Ensure the `.env` file contains the necessary credentials in the `srcs/` directory.
3.  **Compilation and Execution**:
    ```bash
    make        # Builds images and starts containers
    make down   # Stops the services
    make clean  # Removes containers, networks, and clears volume directories
    make fclean # Removes everything, including volumes and images
    ```
4.  **Access**: Open a browser and navigate to `https://abaldelo.42.fr`.

---

## 3. Design Decisions and Comparisons

* **Virtual Machines vs. Docker**: While a VM emulates complete hardware and loads its own kernel (being heavy and slow), Docker shares the host's kernel and isolates processes. This allows Inception to be lightweight, fast to boot, and resource-efficient.
* **Secrets vs. Environment Variables**: Environment variables are useful for configuring software behavior but can be visible in logs. For this project, they have been managed through a protected `.env` file, ensuring that database passwords are not hardcoded in the source code.
* **Docker Network vs. Host Network**: A dedicated bridge network (`inception_net`) is used. Unlike the host network, which would expose all services directly, the Docker network allows MariaDB and WordPress to communicate privately, leaving only Nginx visible to the outside world.
* **Docker Volumes vs. Bind Mounts**: Managed volumes and bind mounts are used for persistence. Volumes are ideal for internal MariaDB data, while bind mounts in `/home/abaldelo/data` allow direct management of site files from the host's file system.

---

## 4. Resources

* **Official Docker Documentation**: Used for `docker-compose.yml` syntax and `Dockerfile` directives.
* **Nginx SSL/TLS Guide**: Reference for configuring secure protocols and self-signed certificates.
* **MariaDB Knowledge Base**: For database initialization using `mysql_install_db` scripts.

### AI Usage
Artificial Intelligence (Gemini) was used as a technical assistant in this project for the following tasks:
* **Error Debugging**: Resolving permission issues in entrypoint scripts and 403 Forbidden connection errors.
* **Script Optimization**: Improving the logic of `.sh` files to ensure correct user creation and database initialization in MariaDB.
* **Documentation**: Structuring and drafting this README.