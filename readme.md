# MMAR Metamodeling Platform - Docker Installation

Welcome to the **MMAR Docker Installation** repository! This guide will walk you through installing and managing the MMAR platform using Docker. Installing MMAR with Docker simplifies setup, minimizes potential issues, and provides an efficient environment for both development and production.

## Installation

### Prerequisites

Ensure that you have the following software installed on your machine:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### Quick Start

You can install and start the MMAR environment using a single command depending on your desired mode:

#### Production Mode

```bash
docker compose --env-file conf/.env-prod up
```

#### Development Mode

```bash
docker compose --env-file conf/.env-dev up
```

This will set up and start the necessary containers for MMAR.

## Managing the Environment

### Stopping the Environment

To stop the environment, run:

#### Production Mode

```bash
docker compose --env-file conf/.env-prod down
```

#### Development Mode

```bash
docker compose --env-file conf/.env-dev down
```

### Removing Containers and Data

To completely remove all containers, images, and volumes associated with MMAR, use:

```bash
docker compose down --rmi all --volumes
```

## Attach Container to VSCode
If you are in development mode and you want to open VSCode, either open a browser tab on https://localhost:8010 or open a remote connection in your VSCode Desktop installation.

```We strongly recommend using your local VSCode, since you can use then all your Code extensions by default.```

To attach a running container in VSCode, follow these instructions: https://code.visualstudio.com/docs/devcontainers/attach-container
```It should be sufficient to just attach the running Docker container. You do not have to configure additional settings.```

The repositories are located in the ```/usr/src/app/mmar``` directory. If you open the folder ```/usr/src/app/mmar```, a task will be automatically started to run the npm projects in mmar-server, mmar-modeling-client, and mmar-metamodeling-client. 

Be aware that most users are not allowed to push directly to the main and develop branches. By default, the development container fetches the development branch. If you want to develop your own features, create a fork of the repository you are working on. When finished, create a ```pull request```.

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

- `API_URL`: The URL of the API endpoint.
- `HTTPS`: Set to `true` to enable HTTPS, `false` otherwise.
- `ANALYZE`: Set to `true` to enable bundle analysis, `false` otherwise.
- `PORT`: The port on which the client will run.
- `COMPRESS`: Set to `true` to enable compression, `false` otherwise.
- `ALLOWED_HOSTS`: A comma-separated list of allowed hosts.
- `ERRORS`, `WARNINGS`, `RUNTIME_ERRORS`: Set to `true` to enable overlays for errors, warnings, and runtime errors respectively.
- `HOT`, `LIVE_RELOAD`: Set to `true` to enable hot reload and live reload respectively.
- `USERNAME`, `PASSWORD`: Default user credentials for the client.
- `CI`: Set to `true` to open the Bero user interface after the server starts.

## Contributing

We welcome contributions! Feel free to fork the repository, create feature branches, and submit pull requests.

## License

This repository is licensed under the GNU AFFERO GENERAL PUBLIC LICENSE Version 3.

## Authors
- [Fabian Muff](https://www.unifr.ch/inf/digits/en/group/team/fabian-muff.html)
