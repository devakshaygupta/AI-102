#!/bin/bash

# This script tests the REST API of the Azure AI service for language detection.
# Make sure to replace the subscription key and endpoint with your own values.
# Example usage: ./rest-test.sh
# Note: The endpoint URL and subscription key are placeholders and should be replaced with actual values.
# Define the endpoint and subscription key
ENDPOINT="https://lab3-11-june.services.ai.azure.com/text/analytics/v3.1/languages"
SUBSCRIPTION_KEY="<replace-this>"
# Define the JSON payload
PAYLOAD='{
  "documents": [
    {
      "id": "1",
      "text": "Vamanos, mi nombre es Juan y soy de Espana. Me gusta mucho la comida espanola."
    }
  ]
}'
# Make the POST request using curl
curl -X POST "$ENDPOINT" -H "Content-Type: application/json" -H "Ocp-Apim-Subscription-Key: $SUBSCRIPTION_KEY" --data-ascii "$PAYLOAD"
