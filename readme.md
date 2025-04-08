# MMAR Metamodeling Platform - Docker Installation

Welcome to the **MMAR Docker Installation** repository! This guide will walk you through installing and managing the MMAR platform using Docker. Installing MMAR with Docker simplifies setup, minimizes potential issues, and provides an efficient environment for both development and production.

## Installation

### Prerequisites

Ensure that you have the following software installed on your machine:

- [Docker](https://docs.docker.com/get-docker/)

Clone the repository to your local machine and navigate to the directory:

<!-- https://github.com/MM-AR/mmar-docker-installation.git --> 
```bash
git clone https://github.com/MM-AR/mmar-docker-installation.git
cd mmar-docker-installation
```

Make sure that docker is running. You can check this by running the following command or just open the Docker Desktop application:

```bash
docker info
```

You can install and start the MMAR environment using a single command depending on your desired mode:

---
### Quick Start Production Mode

Before starting the production mode, make sure that you adapt the `.env-prod` file to your needs. You can find the file in the `conf` directory.
If you want to run the production mode on a local machine and expose it to localhost, set the environment variables `API_URL` and `ALLOWED_HOSTS` to `localhost` (in the files `.env-mmar-metamodeling-client-prod` and `.env-mmar-modeling-client-prod`). The `API_URL` should be set to `http` and not `https`.

If you want to run the production mode on a production server, set the environment variable `API_URL` and `ALLOWED_HOSTS` to the domain name of your server and use `https` for the `API_URL`. 

To start the production mode, run:

```bash
docker compose --env-file conf/.env-prod up
```

To stop the production mode, run:

```bash
docker compose --env-file conf/.env-prod down
```

To completely remove all containers, images, and volumes associated with MMAR, use:

```bash
docker compose down --rmi all --volumes
```
---

### Quick Start Development Mode

If you want to develop something for the MMAR platform, you can use the development mode. This mode is not recommended for production use. This mode is exposed to localhost and starts a VS Code development server on port 8010. You can access it by opening a browser tab on https://localhost:8010 or by using the VS Code Remote Development extension (recommended).

The development mode uses the `.env-dev` file for configuration. You can find the file in the `conf` directory. You can change the environment variables in this file to suit your needs.

If you want to run the development mode on a local machine and expose it to localhost (default scenario), set the environment variables `API_URL` and `ALLOWED_HOSTS` to `localhost` (in the files `.env-mmar-metamodeling-client-dev` and `.env-mmar-modeling-client-dev`). The `API_URL` should be set to `http` and not `https` (by default no changes needed).

To start the development mode, run:
```bash
docker compose --env-file conf/.env-dev up
```

This will set up and start the necessary containers for MMAR. The first time you run this command, it may take a while to download the required images and set up the containers. Subsequent runs will be faster as Docker caches the images. 

Check the console output for any errors. If everything is set up correctly, you can access the development environment at [https://localhost:8010](https://localhost:8010) or by using the VS Code Remote Development extension (See section `Attach Container to VSCode`). 

Note that the development server does not start the API server, the modeling client, and the metamodeling client by default. However, there is a automatic task that runs the npm projects in the `mmar-server`, `mmar-modeling-client`, and `mmar-metamodeling-client` directories if you open the folder `/usr/src/app/mmar` in VS Code. 

You can also start the API server, the modeling client, and the metamodeling client manually by running the following commands in the respective directories:

```bash
# In the mmar-server directory
cd mmar-server

npm start
```

```bash
# In the mmar-modeling-client directory
cd mmar-modeling-client

npm start
```

```bash
# In the mmar-metamodeling-client directory
cd mmar-metamodeling-client

npm start
```

To stop the development mode, run:

```bash
docker compose --env-file conf/.env-dev down
```

To completely remove all containers, images, and volumes associated with MMAR, use:

```bash
docker compose down --rmi all --volumes
```

---


## Attach Container to VSCode
If you are in development mode and you want to open VSCode, either open a browser tab on https://localhost:8010 or open a remote connection in your VSCode Desktop installation.

```We strongly recommend using your local VSCode, since you can use then all your Code extensions by default.```

To attach a running container in VSCode, follow these instructions: https://code.visualstudio.com/docs/devcontainers/attach-container
```It should be sufficient to just attach the running Docker container. You do not have to configure additional settings.```

The repositories are located in the ```/usr/src/app/mmar``` directory. If you open the folder ```/usr/src/app/mmar```, a task will be automatically started to run the npm projects in mmar-server, mmar-modeling-client, and mmar-metamodeling-client. 

Be aware that most users are not allowed to push directly to the main and develop branches. By default, the development container fetches the development branch. If you want to develop your own features, create a fork of the repository you are working on. When finished, create a ```pull request``` to the develop branch.

## Configuration

The MMAR platform can be configured using environment variables. These variables are defined in the `.env` files located in the `conf` directory. You can modify these files to suit your needs. `.env-dev` and `.env-prod` are for the configuration of the Docker variables. All the `.env-mmar...` files are passed on to the different project folders. Only change something if you know what you are doing. By default, you can just let the files as they are. 

## Environment Variables

### PostgreSQL Configuration

- `POSTGRES_USER`: The username for the PostgreSQL database.
- `POSTGRES_PASSWORD`: The password for the PostgreSQL database.
- `POSTGRES_DB`: The name of the PostgreSQL database.

### General Configuration

- `GIT_BRANCH`: The branch of the Git repository to use.
- `GITHUB_TOKEN`: The GitHub token for accessing private repositories.
- `PRODUCTION`: Set to `'true'` for production mode, `'false'` for development mode.
- `DELETE_NODE_MODULES`: Set to `true` to delete `node_modules` before installing dependencies.

### API Configuration

- `HTTPPORT`: The port on which the API server will run.
- `JWT_SECRET`: The secret key for JWT authentication.
- `TOKEN_EXPIRE_TIME`: The expiration time for JWT tokens.

### Client Configuration (Modeling and Metamodeling Client)

- `API_URL`: The URL of the API endpoint. For local development, set it to `http://localhost:8000`. For production, set it to the domain name of your server where you redirect the trafic to/from port 8000 (e.g., `https://your-domain.com`). Use `http` for local development and `https` for production.
- `HTTPS`: Set to `true` to enable HTTPS, `false` otherwise.
- `ANALYZE`: Set to `true` to enable bundle analysis, `false` otherwise.
- `PORT`: The port on which the client will run.
- `COMPRESS`: Set to `true` to enable compression, `false` otherwise.
- `ALLOWED_HOSTS`: A comma-separated list of allowed hosts. For local development, set it to `localhost`. For production, set it to the domain name of your server (e.g., `your-domain.com`).
- `ERRORS`, `WARNINGS`, `RUNTIME_ERRORS`: Set to `true` to enable overlays for errors, warnings, and runtime errors respectively.
- `HOT`, `LIVE_RELOAD`: Set to `true` to enable hot reload and live reload respectively.
- `USERNAME`, `PASSWORD`: Default user credentials for the client.
- `CI`: Set to `true` to open the Bero user interface after the server starts.

### Performance Configuration
In the docker-compose file, you can set the memory limit for the containers. By default, the containers are limited to 6 GB of memory. You can change this in the `docker-compose.yml` file under the `mem_limit` property. For example, to set the memory limit to 8 GB, change the line to: 

```yaml
mem_limit: 8g
```

## Sequence Diagram 
The following sequence diagram illustrates the set up of the Docker project.
![alt text](images/global-sequence-diagram.png)

## Contributing

We welcome contributions! Feel free to fork the repository, create feature branches, and submit pull requests.

## License

This repository is licensed under the GNU AFFERO GENERAL PUBLIC LICENSE Version 3.

## Authors
- [Fabian Muff](https://www.unifr.ch/inf/digits/en/group/team/fabian-muff.html)

