# Function to clone a repository and run npm install if package.json exists
npm_installation() {
    local target_dir=$1

    if [ -f "$target_dir/package.json" ]; then
        # if $REMOVE_NODE_MODULES is true, remove node_modules directory
        if [ "$REMOVE_NODE_MODULES" = true ]; then
            echo "--------------------------------------------------------"
            echo "Removing node_modules directory in $target_dir..."
            rm -rf $target_dir/node_modules
        fi        


        echo "----------------------------------------"
        echo "Running npm install in $target_dir..."
        echo "------------be patient ...--------------"
        cd $target_dir
        # rm -rf node_modules
        npm install
    else
        echo "No package.json found in $target_dir. Skipping npm install."
    fi
}


# install code-server extensions if needed, only if not in production
if [ "$NODE_ENV" != "production" ]; then
    echo "----------------------------------------"
    echo "Installing code-server extensions..."
    # install code-server extensions
    code-server --install-extension dbaeumer.vscode-eslint
else
    echo "----------------------------------------"
    echo "Not installing code-server extensions in production."
fi


npm_installation "/usr/src/app/mmar/mmar-global-data-structure"
npm_installation "/usr/src/app/mmar/mmar-server"
npm_installation "/usr/src/app/mmar/mmar-modeling-client"
npm_installation  "/usr/src/app/mmar/mmar-metamodeling-client"


#copy the env files for the node servers
echo "----------------------------------------"
echo "Copying .env files for the node servers..."
echo "----------------------------------------"
cp /usr/src/app/mmar-config-files/.env-mmar-api /usr/src/app/mmar/mmar-server/.env
cp /usr/src/app/mmar-config-files/.env-mmar-modeling-client-development /usr/src/app/mmar/mmar-modeling-client/.env.development
cp /usr/src/app/mmar-config-files/.env-mmar-modeling-client-prod /usr/src/app/mmar/mmar-modeling-client/.env
cp /usr/src/app/mmar-config-files/.env-mmar-metamodeling-client-development /usr/src/app/mmar/mmar-metamodeling-client/.env.development
cp /usr/src/app/mmar-config-files/.env-mmar-metamodeling-client-prod /usr/src/app/mmar/mmar-metamodeling-client/.env

#wait 2 seconds
sleep 2


#start the production if needed
echo "----------------------------------------"
echo "Starting node servers if needed..."
bash /usr/src/app/start_node_servers.sh






