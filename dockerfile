# Stage 1: Build Node.js application
FROM node:23 AS build

# Set working directory
WORKDIR /usr/src/app

# Create necessary directories with proper permissions
RUN mkdir -p /usr/src/app/mmar/mmar-database \
    /usr/src/app/mmar/.vscode \
    /usr/src/app/mmar/mmar-server \
    /usr/src/app/mmar/mmar-modeling-client \
    /usr/src/app/mmar/mmar-metamodeling-client \
    /usr/src/app/mmar/mmar-global-data-structure  
    
# Stage 2: Add PostgreSQL to the same image
FROM postgres:16 AS final

# Update apt and install dependencies
RUN apt-get update && \
    apt-get install -y gosu git curl supervisor && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
     apt-get install -y nodejs 
    # apt-get install -y nodejs && \
    # apt-get install -y postgresql-common

    # install jq with curl
    RUN apt-get install -y jq

# Verify Node.js and install the specific npm version
RUN node -v && \
    npm install -g npm@10.7.0

# Install code-server without a password
RUN curl -fsSL https://code-server.dev/install.sh | sh && \
    mkdir -p ~/.config/code-server && \
    echo "bind-addr: 0.0.0.0:8010" > ~/.config/code-server/config.yaml && \
    echo "auth: none" >> ~/.config/code-server/config.yaml

# Install npm 10.7.0 and npm-force-resolutions globally
RUN npm install -g npm@10.7.0 
RUN npm install -g npm-force-resolutions

# Copy built Node.js application
WORKDIR /usr/src/app
COPY --from=build /usr/src/app .

# Expose required ports
EXPOSE 5432 8000 8080 8070 8010

# Copy and set up start script as root user
COPY scripts/start.sh /usr/src/app/start.sh
RUN chmod +x /usr/src/app/start.sh

# Copy and set up the initDb.sh script as root user
COPY scripts/initDb.sh /usr/src/app/initDb.sh
RUN chmod +x /usr/src/app/initDb.sh

# copy file for npm_installation.sh
COPY scripts/npm_installation.sh /usr/src/app/npm_installation.sh
RUN chmod +x /usr/src/app/npm_installation.sh

# Copy start_node_servers.sh
COPY scripts/start_node_servers.sh /usr/src/app/start_node_servers.sh
RUN chmod +x /usr/src/app/start_node_servers.sh

#COPY add_example_metamodels.sh
COPY scripts/add_example_metamodels.sh /usr/src/app/add_example_metamodels.sh
RUN chmod +x /usr/src/app/add_example_metamodels.sh

# Copy and set up the supervisord.conf file as root user
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

#COPY VSCODE CONFIG
COPY conf/tasks.json /usr/src/app/mmar/.vscode/tasks.json

#COPY all the files from conf to /usr/src/app/mmar-config-files -> environment files for node projects
COPY conf /usr/src/app/mmar-config-files

# Start entrypoint script
ENTRYPOINT ["/usr/src/app/start.sh"]