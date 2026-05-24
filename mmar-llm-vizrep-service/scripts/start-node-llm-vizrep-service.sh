#!/bin/bash
# If environment variable $PRODUCTION is set to true, start production server
PRODUCTION=${PRODUCTION}
echo "PRODUCTION = $PRODUCTION"

    # Create a log loop to warn the user 10 times that this takes some time
    # The script should go on even if the loop is running
    for i in {1..1}
    do
        echo "........................................................................................................................................."
        echo "Starting LLM VizRep service. This may take some time..."
        echo "The branch checked out is $GIT_BRANCH."
        echo "LLM VizRep service will be exposed on http://localhost:${LLM_SERVICE_PORT:-3000}"
        echo "!!!!!! If you change the port in the conf/.env files, you have to change the port in docker-compose.yml as well !!!!!"
        echo "........................................................................................................................................."

        sleep 10
    done &

    echo "----------------------------------------------"
    echo "Starting LLM VizRep service in mmar/mmar-llm-vizrep-service..."
    cd /usr/src/app/shared/mmar/mmar-llm-vizrep-service

    if [ "$PRODUCTION" = true ]; then
        npm run build
        npm run start &
        SERVER_PID=$!
        echo "LLM VizRep service started in production with PID $SERVER_PID"
    else
        npm run dev &
        SERVER_PID=$!
        echo "LLM VizRep service started in development with PID $SERVER_PID"
    fi

# Keep the container running
echo "----------------------------------------------"
echo "Container is running. Press Ctrl+C to stop."
tail -f /dev/null