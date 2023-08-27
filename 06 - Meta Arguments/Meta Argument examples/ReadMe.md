# Terraform Meta-Arguments

- Meta arguments alter the behavior of a resource.
- There are 5 Meta-Arguments in Terraform which are as follows:
```
depends_on
count
for_each
provider
lifecycle

```

## a) depends_on
- Terraform has a feature of identifying resource dependency. This means that Terraform internally knows the sequence in which the dependent resources needs to be created whereas the independent resources are created in parallel.

- But in some scenarios, some dependencies are there that cannot be automatically inferred by Terraform. In these scenarios, a resource relies on some other resource’s behaviour but it doesn’t access any of the resource’s data in arguments.
- For those dependencies, we’ll use depends_on meta-argument to explicitly define the dependency.

- **depends_on** meta-argument must be a list of references to other resources in the same calling resource.

This argument is specified in resources as well as in modules (Terraform version 0.13+)

```
resource "aws_iam_role" "role" {
  name = "demo-role"
  assume_role_policy = "..."
}

# Terraform can infer automatically that the role must be created first.
resource "aws_iam_instance_profile" "instance-profile" {
  role = aws_iam_role.role.name
}

resource "aws_iam_role_policy" "policy" {
  name   = "demo-policy"
  role   = aws_iam_role.role.name
  policy = jsonencode({
  "Statement" = [{
  "Action" = "s3:*",
  "Effect" = "Allow",
  }],
 })
}


# Terraform can infer from this that the instance profile must
# be created before the EC2 instance.

resource "aws_instance" "ec2" {
  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.instance-profile

  depends_on = [
  aws_iam_role_policy.policy
  ]
 }
 
# However, if software running in this EC2 instance needs access
# to the S3 API in order to boot properly, there is also a "hidden"
# dependency on the aws_iam_role_policy that Terraform cannot
# automatically infer, so it must be declared explicitly:
```        
## b) count

- In Terraform, a resource block actually configures only one infrastructure object by default. If we want multiple resources with same configurations, we can define the count meta-argument. 
- This will reduce the overhead of duplicating the resource block that number of times.

- count require a whole number and will then create that resource that number of times. To identify each of them, we use the count.index which is the index number that corresponds to each resource. The index ranges from 0 to count-1.

- This argument is specified in resources as well as in modules (Terraform version 0.13+). Also, count meta-argument cannot be used with for_each.

```
# create four similar EC2 instances

resource "aws_instance" "server" {
  count = 4
  ami           = "ami-a1b2c3d4"
  instance_type = "t2.micro"

 tags = {
 # Usage of count.index in providing a distinct name for every Instance
 Name = "Server-${count.index}"
  }
 }

output "instance_id" {
# Select all instance id using * in place of index value
value = aws_instance.server[*].id
}
```

## c) for_each
- As specified in the count meta-argument, that the default behaviour of a resource is to create a single infrastructure object which can be overridden by using count, but there is one more flexible way of doing the same which is by using for_each meta argument.

- The for_each meta argument accepts a map or set of strings. Terraform will create one instance of that resource for each member of that map or set. To identify each member of the for_each block, we have 2 objects:

   each.key: The map key or set member corresponding to each member.
   each.value: The map value corresponding to each member.
This argument is specified in resources (Terraform version 0.12.6) as well as in modules (Terraform version 0.13+)

```
## Example for map
resource "azurerm_resource_group" "rg" {
  for_each = {
  group_A = "eastus"
  group_B = "westus2"
 }
  name     = each.key
  location = each.value
}

## Example for set
resource "aws_iam_user" "accounts" {
for_each = toset( ["Developer", "Tester", "Administrator", "Cloud-Architect"] )
name     = each.key
}
```

## d) provider
- provider meta-argument specifies which provider to be used for a resource. This is useful when you are using multiple providers which is usually used when you are creating multi-region resources. For differentiating those providers, you use an alias field.
- The resource then reference the same alias field of the provider as **provider.alias** to tell which one to use.
```
## Default Provider
provider "google" {
  region = "us-central1"
}

## Another Provider
provider "google" {
  alias  = "europe"
  region = "europe-west1"
}

## Referencing the other provider
resource "google_compute_instance" "example" {
  provider = google.europe
}
```

## e) lifecycle

- The lifecycle meta-argument defines the lifecycle for the resource. As per the resource behaviour, Terraform can do the following:

    create a resource
    destroy a resource
    updated resource in place
    update resource by deleting existing and create new

- lifecycle is a nested block under resource that is used to customise that behaviour. Here are the following customisation that are available under lifecycle block

**create_before_destroy: (Type: Bool)**
For resource, where Terraform cannot do an in place updation due to API limitation, its default behaviour is to destroy the resource first and then re-create it. This can be changed by using this argument. It will first create the updated resource and then delete the old one.

**prevent_destroy: (Type: Bool)**
This will prevent the resource from destroying. It is a useful measure where we want to prevent a resource against accidental replacement such as database instances.

**ignore_changes: (Type: List(Attribute Names))**
By default, If Terraform detects any difference in the current state, it plans to update the remote object to match configuration. The ignore_changes feature is intended to be used when a resource is created with references to data that may change in the future, but should not affect said resource after its creation. It expects a list or map of values, whose updation will not recreate the resource. If we want all attributes to be passed here, we can simply use all.

- Ignore tag changes and won't recreate this resource if tags are updated
```
resource "aws_instance" "example" {
  lifecycle {
    ignore_changes = [
     tags,
   ]
   }
}
```