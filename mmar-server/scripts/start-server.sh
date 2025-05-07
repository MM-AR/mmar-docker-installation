#!/bin/bash
set -e

# Initialize npm installation
echo "--------------------------------------------------------"
echo "npm installation..."
/usr/src/app/npm-installation-server.sh

# Run start-node-server.sh script
echo "----------------------------------------"
echo "Running start-node-server.sh script..."
echo "----------------------------------------"
bash /usr/src/app/start-node-server.sh

