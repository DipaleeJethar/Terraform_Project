# Terraform_Project
In this repository you can see the complete 3-Tier Project using terraform.

Terraform Notes (Simple & Short)

1. What is Terraform?
Terraform is an Infrastructure as Code (IaC) tool by HashiCorp. It helps automate cloud resource provisioning, management, and scaling using a declarative language (HCL).

2. Key Features of Terraform
Multi-Cloud Support – Works with AWS, Azure, GCP, etc.
Declarative Syntax – Define what you want, and Terraform handles the rest.
State Management – Stores resource details in terraform.tfstate.
Automation – Enables efficient and repeatable infrastructure deployment.

4. Terraform Workflow
Write – Define resources in .tf files.
Init – Run terraform init to set up Terraform.
Plan – Check what Terraform will do (terraform plan).
Apply – Deploy resources (terraform apply).
Destroy – Remove resources (terraform destroy).

6. Terraform Components
Provider – Cloud services (e.g., AWS, Azure).
Resources – Cloud components like EC2, S3, RDS.
Variables – Store configurable values.
Modules – Reusable Terraform configurations.
State File – Tracks infrastructure changes.

8. Terraform Commands
Command	Purpose
terraform init	Initializes Terraform in a directory.
terraform plan	Shows the changes Terraform will make.
terraform apply	Creates/updates resources.
terraform destroy	Deletes infrastructure.
terraform fmt	Formats .tf files properly.
terraform validate	Checks for syntax errors.
terraform show	Displays the current state.

10. Terraform Best Practices
✅ Store state files in AWS S3 with DynamoDB locking.
✅ Use variables instead of hardcoded values.
✅ Use modules for better reusability.
✅ Follow Git-based version control for Terraform code.
✅ Avoid manual changes in the cloud console.

This covers the basics of Terraform in an easy-to-understand way.
