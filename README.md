# **Terraform syllabus**

## 1. Introduction to terraform
**a) Key concepts:**
- What is IAC?
- What are the benefits of IAC?
- What is Terraform?
- Who is the vendor of terraform?
- How do you write terraform configuration files?

**b) How to install terraform:**
- What are the prerequisites for using terraform?
- How to install terraform on MACOS / Windows using brew /choco
- How to install Vscode
- How to install AWS CLI
- How to configure AWS credentials

## 2. Command basics:
 **a) Terraform workflow:**
- What is terraform workflow?
- terraform init
- terraform validate
- terraform fmt
- terraform plan
- terraform apply
- terraform destroy

**b) Passing credentials to terraform workflow:**
- Static credentials
- Environmental variables
- Shared credential / configuration files.

**c) Projects** 

## 3. Language syntax:
**a) What are terraform top level blocks?**
- Terraform settings block
- Provider block
- Resource block
- Variables block
- Output block
- Locals block
- Data block
- Modules block
- Moved block
- Import block

**b) What makes up a terraform block?**
- Arguments
- Expressions
- Attributes
- Meta-arguments

**c) Projects**

## 4. Settings
**a) Set up for basic resource creation**
- Set up terraform settings block
- Set up provider block
- Set up resource block
- Set up file function for user data

**b) Projects**

## 5. Variables and data sources
**a) Use of variables to make code reusable**
- What are variables?
- Variable types
- How to reference variables from lists and maps
- Variable files

**b) Data sources**
- What are data sources
- How are data sources used?

## 6. Meta arguments
- Terraform functions
- Count
- for Loops over lists and maps
- for_each loops over sets and maps
- dynamic blocks using for_each loops
- Conditionals using ternary operator

## 7. Modules and provisioners
**a) Modules**
- What are modules?
- Custom modules
- Official modules

**b) Provisioners**
- File
- Remote exec
- Local exec
- Null resource

## 8. Terraform Backend
- Local backend
- Remote backend
- State storage using s3
- DynamoDb state locking

## 9. Local and Remote state data sources
- Remote state data source
- local state data source

## 10. Terraform best practices && Interview question
