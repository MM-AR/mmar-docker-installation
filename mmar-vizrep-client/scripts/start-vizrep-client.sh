#!/bin/bash
set -e

# Initialize npm installation
echo "--------------------------------------------------------"
echo "npm installation..."
/usr/src/app/npm-installation-vizrep-client.sh

# Run start-node-vizrep-client.sh script
echo "----------------------------------------"
echo "Running start-node-vizrep-client.sh script..."
echo "----------------------------------------"
bash /usr/src/app/start-node-vizrep-client.sh

