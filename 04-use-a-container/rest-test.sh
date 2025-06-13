#!/bin/bash
# This script tests the REST API of the Azure AI service for text analytics.
# Update the ENDPOINT variable with your actual service endpoint.

ENDPOINT="http://major-gazelle.eastus.azurecontainer.io:5000/text/analytics/v3.1/sentiment"

# Prepare the request payload as a JSON file for better readability and maintainability
cat > payload.json <<EOF
{
  "documents": [
    {
      "id": "1",
      "text": "The performance was amazing! The sound could have been clearer."
    },
    {
      "id": "2",
      "text": "The food and service were unacceptable. While the host was nice, the waiter was rude and food was cold."
    }
  ]
}
EOF

# Send the POST request
curl -X POST "$ENDPOINT" \
  -H "Content-Type: application/json" \
  --data-binary @payload.json \
  --silent | jq

# Clean up
rm payload.json
