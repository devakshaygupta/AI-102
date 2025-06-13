# Azure AI Infrastructure with Terraform

This project contains Terraform scripts to provision and manage Azure AI resources. Follow the steps below to initialize, format, validate, plan, apply, and destroy your Azure infrastructure using Terraform.

---

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed
- Azure CLI installed and authenticated (`az login`)
- Proper Azure credentials set as environment variables (see `set-secrets.ps1`)

---

## Workflow

### 1. Initialize Terraform

Initialize the working directory containing Terraform configuration files.

```sh
terraform init
```

---

### 2. Format Terraform Files

Automatically format your Terraform configuration files for readability and consistency.

```sh
terraform fmt
```

---

### 3. Validate Terraform Configuration

Check whether the configuration is valid.

```sh
terraform validate
```

---

### 4. Create a Terraform Plan

Generate and review an execution plan.

```sh
terraform plan -var="ai_services_kind=ContentSafety" -out main.tfplan
```

---

### 5. Apply the Terraform Plan

Apply the changes required to reach the desired state of the configuration.

```sh
terraform apply main.tfplan
```

---

### 6. Create a Destroy Plan

Generate a plan to destroy all resources managed by Terraform.

```sh
terraform plan -destroy -out=main.destroy.tfplan
```

---

### 7. Apply the Destroy Plan

Destroy the infrastructure as defined in the destroy plan.

```sh
terraform apply main.destroy.tfplan
```

---

## Notes

- Always review the plan before applying changes.
- Use version control to manage your Terraform files.
- Store sensitive values (like secrets) securely and never commit them to source control.

---

## Resources

- [Terraform Documentation](https://www.terraform.io/docs/)
- [Azure Provider for Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
