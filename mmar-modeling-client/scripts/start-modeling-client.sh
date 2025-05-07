#!/bin/bash
set -e

# Initialize npm installation
echo "--------------------------------------------------------"
echo "npm installation..."
/usr/src/app/npm-installation-modeling-client.sh

# Run start-node-modeling-client.sh script
echo "----------------------------------------"
echo "Running start-node-modeling-client.sh script..."
echo "----------------------------------------"
bash /usr/src/app/start-node-modeling-client.sh

