#!/bin/bash
set -e
/usr/src/app/clone-repos-initiator.sh

# Initialize npm installation
echo "--------------------------------------------------------"
echo "npm installation..."
/usr/src/app/npm-installation-initiator.sh

# Initialize database
echo "--------------------------------------------------------"
echo "Set-Up database..."
/usr/src/app/init-db-initiator.sh