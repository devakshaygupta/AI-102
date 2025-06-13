#!/bin/bash
# This script tests the REST API of the Azure AI service for text analytics.
# Update the ENDPOINT variable with your actual service endpoint.

ENDPOINT="http://major-gazelle.eastus.azurecontainer.io:5000/language/:analyze-text?api-version=2023-04-01"

# Prepare the request payload as a JSON file for better readability and maintainability
cat > payload.json <<EOF
{
    "analysisInput": {
        "documents": [
            {
                "id": 1,
                "text": "hello"
            }
        ]
    },
    "kind": "LanguageDetection"
}
EOF

# Send the POST request
curl -X POST "$ENDPOINT" \
  -H "Content-Type: application/json" \
  --data-binary @payload.json \
  --silent | jq

# Clean up
rm payload.json
