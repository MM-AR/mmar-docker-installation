#!/bin/bash
set -e

# Initialize npm installation
echo "--------------------------------------------------------"
echo "npm installation..."
/usr/src/app/npm-installation-llm-vizrep-service.sh

# Run start-node-vizrep-client.sh script
echo "----------------------------------------"
echo "Running start-node-llm-vizrep-service.sh script..."
echo "----------------------------------------"
bash /usr/src/app/start-node-llm-vizrep-service.sh