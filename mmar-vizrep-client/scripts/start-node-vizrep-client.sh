#!/bin/bash
# If environment variable $PRODUCTION is set to true, start production server
PRODUCTION=${PRODUCTION}
echo "PRODUCTION = $PRODUCTION"

    # Create a log loop to warn the user 10 times that this takes some time
    # The script should go on even if the loop is running
    for i in {1..1}
    do
        echo "........................................................................................................................................."
        echo "Starting $PRODUCTION server. This may take some time..."
        echo "The branch checked out is $GIT_BRANCH."
        echo "Applications will be exposed on http://localhost:8000, http://localhost:8070, http://localhost:8080, and http://localhost:8090"        
        echo "!!!!!! If you change the ports in the conf/.env files, you have to change the ports in the docker-compose.yml file as well !!!!!"
        echo "........................................................................................................................................."

        sleep 10
    done &

    echo "----------------------------------------------"
    echo "Starting npm run start in mmar/mmar-vizrep-client..."
    cd /usr/src/app/shared/mmar/mmar-vizrep-client
    
    if [ "$PRODUCTION" = true ]; then
    npm run start:prod &
    SERVER_PID=$!
    echo "Server started in production with PID $SERVER_PID"
    else
    npm run start &
    SERVER_PID=$!
    echo "Server started in develop with PID $SERVER_PID"
    fi


# Keep the container running
echo "----------------------------------------------"
echo "Container is running. Press Ctrl+C to stop."
tail -f /dev/null