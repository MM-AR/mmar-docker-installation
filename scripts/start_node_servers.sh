#!/bin/bash
#if environment variable $PRODUCTION is set to true, start production server
echo "PRODUCTION = $PRODUCTION"
if [ "$PRODUCTION" = true ]; then

    # create a log loop to warn the user 10 times, that this takes some time
    # the script should go on even if the loop is running
    for i in {1..6}
    do
        echo "........................................................................................................................................."
        echo "Starting production server. This may take some time..."
        echo "The branch checked out is $GIT_BRANCH".
        echo "Applications will be exposed on http://localhost:8000, http://localhost:8080, and http://localhost:8070"
        echo "!!!!!! if you change the ports in the conf/.env files, you have to change the ports in the docker-compose.yml file as well !!!!!"
        echo "........................................................................................................................................."

        sleep 10
    done &
    

    echo "----------------------------------------------"
    echo "Starting npm run start in mmar/mmar-modeling-client..."
    cd /usr/src/app/mmar/mmar-modeling-client
    npm run start:prod & 
    CLIENT_PID=$!
    echo "Modeling Client started with PID $CLIENT_PID"

    echo "----------------------------------------------"
    echo "Starting npm run start in mmar/mmar-metamodeling-client..."
    cd /usr/src/app/mmar/mmar-metamodeling-client
    npm run start:prod &
    METAMODELING_PID=$!
    echo "Metamodeling Client started with PID $METAMODELING_PID"

    echo "----------------------------------------------"
    echo "Starting npm run start in mmar/mmar-server..."
    cd /usr/src/app/mmar/mmar-server
    npm run start &
    SERVER_PID=$!
    echo "Server started with PID $SERVER_PID"

    # add example metamodels via start_node_servers.sh
    echo "----------------------------------------------"
    echo "Adding example metamodels..."
    echo "----------------------------------------------"
    bash /usr/src/app/add_example_metamodels.sh &
    

else

    echo "........................................................................................................................................."
    echo "You are running in development mode. There is no application startet automatically."
    echo "The branch checked out is $GIT_BRANCH".
    echo "vscode will be exposed on http://localhost:8010, however, we recomment to connect the container via VSCode directly --> see readme file"
    echo "as soon as you open the mmar project folder in vscode, the server will be started ..."
    echo "on http://localhost:8000, http://localhost:8080, and http://localhost:8070"
    echo "!!!!!! if you change the ports in the conf/.env files, you have to change the ports in the docker-compose.yml file as well !!!!!"
    echo "........................................................................................................................................."
    echo "If you want to add example metamodels, you can do this by running the script add_example_metamodels.sh in the container on path /usr/src/app/add_example_metamodels.sh"
    echo "........................................................................................................................................."
fi

# Start supervisord
echo "----------------------------------------"
echo "Starting supervisord..."
echo "----------------------------------------"
exec supervisord -c /etc/supervisor/supervisord.conf
