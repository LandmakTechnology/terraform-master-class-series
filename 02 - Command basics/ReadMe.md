## **Terraform basic commands**

**terraform init**
- Initializes a working directory containing Terraform configuration files.
- performs
   - backend initialization
   - storage for terraform state file.
   - modules installation,
   - downloaded from terraform registry to local path
   - provider(s) plugins installation,
   - the plugins are downloaded in the sub-directory of the present working directory at the path of .terraform/plugins
- Supports -upgrade to update all previously installed plugins to the newest version that complies with the configuration’s version constraints
- Is safe to run multiple times, to bring the working directory up to date with changes in the configuration
- Does not delete the existing configuration or state

**terraform validate**
- Validates syntactically for format and correctness.
- Is used to validate/check the syntax of the Terraform files.
- Verifies whether a configuration is syntactically valid and internally consistent, regardless of any provided variables or existing state.
- A syntax check is done on all the terraform files in the directory, and will display an error if any of the files don’t validate.

**terraform plan**
- Create a execution plan
- Traverses each vertex and requests each provider using parallelism
- Calculates the difference between the last-known state and
the current state and presents this difference as the output of the terraform plan operation to user in their terminal
- Does not modify the infrastructure or state.
- Allows a user to see which actions Terraform will perform prior to making any changes to reach the desired state
- Will scan all *.tf  files in the directory and create the plan
- Will perform refresh for each resource and might hit rate limiting issues as it calls provider APIs
- All resources refresh can be disabled or avoided using
      -refresh=false or
       target=xxxx or break resources into different directories.
- Supports -out to save the plan

**terraform apply**
- Apply changes to reach the desired state.
- Scans the current directory for the configuration and applies the changes appropriately.
- Can be provided with a explicit plan, saved as out from terraform plan
- If no explicit plan file is given on the command line, terraform apply will create a new plan automatically
  and prompt for approval to apply it
- Will modify the infrastructure and the state.
- If a resource successfully creates but fails during provisioning,
    - Terraform will error and mark the resource as “tainted”.
    - A resource that is tainted has been physically created, but can’t be considered safe to use since provisioning failed.
    - Terraform also does not automatically roll back and destroy the resource during the apply when the failure happens, because that would go against the execution plan: the execution plan would’ve said a resource will be created, but does not say it will ever be deleted.
- Does not import any resource.
- Supports -auto-approve to apply the changes without asking for a confirmation
- Supports -target to apply a specific module

**terraform refresh**
- Used to reconcile the state Terraform knows about (via its state file) with the real-world infrastructure
- Does not modify infrastructure, but does modify the state file

**terraform destroy**
- Destroy the infrastructure and all resources
- Modifies both state and infrastructure
  - terraform destroy -target can be used to destroy targeted resources
  - terraform plan -destroy allows creation of destroy plan

**terraform import**
- Helps import already-existing external resources, not managed by Terraform, into Terraform state and allow it to manage those resources
- Terraform is not able to auto-generate configurations for those imported modules, for now, and requires you to first write the resource definition in Terraform and then import this resource

**terraform taint**
- Marks a Terraform-managed resource as tainted, forcing it to be destroyed and recreated on the next apply.
- Will not modify infrastructure, but does modify the state file in order to mark a resource as tainted. Infrastructure and state are changed in next apply.
- Can be used to taint a resource within a module

**terraform fmt**
- Lints the code into a standard format

**terraform console**
- Provides an interactive console for evaluating expressions.
