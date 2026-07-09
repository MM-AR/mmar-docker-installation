#!/bin/bash
set -e

echo "--------------------------------------------------------"
echo "Waiting for requirements.txt to be available..."
while [ ! -f /usr/src/app/shared/mmar/mmar-pm-service/requirements.txt ]; do
    echo "Waiting for requirements.txt in /usr/src/app/shared/mmar/mmar-pm-service..."
    sleep 5
done

echo "--------------------------------------------------------"
echo "Copying .env file..."
if [ "$PRODUCTION" = "true" ]; then
    cp /usr/src/app/mmar-config-files/.env-mmar-pm-service-prod \
       /usr/src/app/shared/mmar/mmar-pm-service/.env
else
    cp /usr/src/app/mmar-config-files/.env-mmar-pm-service-development \
       /usr/src/app/shared/mmar/mmar-pm-service/.env
fi

echo "--------------------------------------------------------"
echo "Installing Python dependencies..."
cd /usr/src/app/shared/mmar/mmar-pm-service
pip install -r requirements.txt

echo "----------------------------------------"
echo "Starting PM service..."
echo "----------------------------------------"
if [ "$PRODUCTION" = "true" ]; then
    uvicorn main:app --host 0.0.0.0 --port 8001
else
    uvicorn main:app --host 0.0.0.0 --port 8001 --reload
fi