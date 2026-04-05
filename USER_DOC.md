# User Documentation - Inception Project

*This documentation is designed to help users and administrators manage the Inception web stack.*

---

## 1. Services Overview

### Conceptual Level
The stack offers a complete web hosting solution. Imagine a secure building where **Nginx** is the receptionist who checks your ID (SSL/TLS), **WordPress** is the office where the content is created, and **MariaDB** is the secure vault where all the information is stored in organized files.

### Technical Level
The infrastructure provides three interconnected services:
* **Nginx (v1.22.1)**: Acts as a Reverse Proxy and Web Server, handling encrypted HTTPS traffic on port 443.
* **WordPress (v6.4+)**: A PHP-FPM container that processes dynamic content.
* **MariaDB (v10.11)**: A relational database management system for persistent data storage.

---

## 2. Managing the Project (Start & Stop)

### Conceptual Level
Starting the project is like turning on a power plant: one command activates all the engines in the correct order. Stopping it safely shuts down the services without losing your work.

### Technical Level
Use the provided `Makefile` in the root directory:
* **To Start**: Run `make`. This builds the images, creates the network, and starts containers in detached mode.
* **To Stop**: Run `make down`. This stops the processes without deleting the database or site files.
* **To Reset**: Run `make fclean`. This wipes all containers and volumes for a fresh start.

---

## 3. Accessing the Website

### Conceptual Level
To visit your site, you must use a specific address in your browser. Since we are using a private security key, your browser will ask for permission to enter—simply click "Advanced" and "Proceed".

### Technical Level
1.  **URL**: Navigate to `https://abaldelo.42.fr` in your browser.
2.  **Admin Panel**: Access the WordPress dashboard at `https://abaldelo.42.fr/wp-admin`.
3.  **SSL Warning**: You will see a "Your connection is not private" warning. This is expected as we use a **self-signed certificate**. Select **Advanced -> Proceed to abaldelo.42.fr**.

---

## 4. Credentials Management

### Conceptual Level
Passwords and usernames are not written inside the program for security. Instead, they are kept in a "secret envelope" called a `.env` file. You can find and change them there.

### Technical Level
All sensitive information is located in `srcs/.env`. 
* **MariaDB**: Contains `MYSQL_ROOT_PASSWORD`, `MYSQL_USER`, and `MYSQL_PASSWORD`.
* **WordPress**: Contains `WP_ADMIN_USER`, `WP_ADMIN_PASSWORD`, and basic user credentials.
* *Note*: Never commit the `.env` file to public repositories.

---

## 5. Health Check (Service Status)

### Conceptual Level
You can check if the "heart" of your project is beating by asking the system for a status report. It will show you a list of the services and if they are currently running.

### Technical Level
To verify the status of the containers, run the following command in your terminal:
```bash
docker ps