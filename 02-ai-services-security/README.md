# AI-102 Lab: 02-ai-services-security

## REST API Test Scripts

This folder contains scripts to test the Azure AI service for language detection using REST APIs.

---

## Prerequisites

- Azure CLI installed and logged in (`az login`)
- An Azure AI service endpoint and a valid subscription key
- Update the scripts to use your own endpoint and subscription key before running

---

## Running the Scripts

### Bash (Linux/macOS)

```bash
./rest-test.sh
```

### PowerShell (Windows)

You can run the Bash script in Windows Subsystem for Linux (WSL) or Git Bash.
Alternatively, use the equivalent `curl` command in PowerShell:

```powershell
$endpoint = "<your-endpoint>/text/analytics/v3.1/languages"
$subscriptionKey = "<your-key>"
$payload = @{
    documents = @(
        @{
            id = "1"
            text = "Vamanos, mi nombre es Juan y soy de Espana. Me gusta mucho la comida espanola."
        }
    )
} | ConvertTo-Json

curl -Method Post `
     -Uri $endpoint `
     -Headers @{ "Ocp-Apim-Subscription-Key" = $subscriptionKey; "Content-Type" = "application/json" } `
     -Body $payload
```

Replace `<your-endpoint>` and `<your-key>` with your actual Azure AI service endpoint and subscription key.

---

## Azure CLI Commands

Use these commands to manage your Azure Cognitive Services, Azure AD, and Key Vault resources:

1. **List Cognitive Services account keys:**

    ```sh
    az cognitiveservices account keys list --name <replace-name> --resource-group rg-<replace-name>
    ```

2. **Regenerate a Cognitive Services account key:**

    ```sh
    az cognitiveservices account keys regenerate --name <replace-name> --resource-group rg-<replace-name> --key-name key1
    ```

3. **Create an Azure AD service principal with owner role:**

    ```sh
    az ad sp create-for-rbac -n "api://app-<replace-name>" --role owner --scopes subscriptions/<subscription-id>/resourceGroups/rg-<replace-name>
    ```

4. **Show details for a specific service principal:**

    ```sh
    az ad sp show --id e4e94178-27d6-4a20-b819-e9894588c62c
    ```

5. **Set Key Vault policy for an object ID:**

    ```sh
    az keyvault set-policy -n kv-<replace-name> --object-id <object-id> --secret-permissions get list
    ```

6. **Create RBAC with contributor access for terraform

    ```bash
    az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<subscription-id>
    ```

---

## Example Output

The scripts will return a JSON response with the detected language for the provided text.

---

## Files

- `rest-test.sh` &mdash; Bash script for testing the REST API.
