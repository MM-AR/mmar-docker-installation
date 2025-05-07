#!/bin/bash
set -e

# Initialize npm installation
echo "--------------------------------------------------------"
echo "npm installation..."
/usr/src/app/npm-installation-metamodeling-client.sh

# Run start-node-metamodeling-client.sh script
echo "----------------------------------------"
echo "Running start-node-metamodeling-client.sh script..."
echo "----------------------------------------"
bash /usr/src/app/start-node-metamodeling-client.sh

