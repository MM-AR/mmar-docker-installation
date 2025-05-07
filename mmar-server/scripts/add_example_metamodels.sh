#!/bin/bash


# take port from .env file
port=${API_SERVER_PORT}
echo "PORT for api to add example metamodels = $port"
echo "----------------------------------------"

base_url="http://localhost:$port/"
access_token="null"

signin() {
    # get access token
    response=$(curl -s -X POST -H "Content-Type: application/json" -d '{"username":"admin","password":"admin"}' $base_url"login/signin")
    echo "Response: $response"
    # Remove quotes from the response
    token=$(echo $response | sed 's/^"//;s/"$//')
    echo "Access token for api to add example metamodels = $token"
    # check if access token is null
    if [ "$token" = "null" ] || [ -z "$token" ]; then
        echo "Failed to get access token."
        return 1
    fi
    # set access token
    access_token=$token
    return 0
}

postMetamodel() {
    local file=$1
    echo "----------------------------------------"
    echo "Adding example metamodel: $file"
    
    # Use curl to get both the response body and the HTTP status code
    response=$(curl -s -o /dev/null -w "%{http_code}" -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $access_token" \
        -d @$file $base_url"metamodel/sceneTypes")

    # Check if the HTTP status code is 200 (Success)
    if [ "$response" -ne 200 ]; then
        echo "Failed to add example metamodel: $file (HTTP code: $response)"
        echo "----------------------------------------"
        return 1
    else
        echo "Added example metamodel: $file"
        echo "----------------------------------------"
        return 0
    fi
}

# Retry sign-in every 15 seconds if it fails
while true; do
    if signin; then
        echo "Sign-in successful."
        echo "----------------------------------------"
        # add example metamodels
        for file in /usr/src/app/shared/mmar/mmar-database/example_metamodels/up_to_date/*.json; do
            postMetamodel $file
        done

        break
    else
        echo "Retrying sign-in in 15 seconds..."
        echo "----------------------------------------"
        sleep 15
    fi
done

# remove /usr/src/app/shared/mmar/mmar-database
echo "----------------------------------------"
echo "Removing /usr/src/app/shared/mmar/mmar-database..."
rm -rf /usr/src/app/shared/mmar/mmar-database
echo "----------------------------------------"

