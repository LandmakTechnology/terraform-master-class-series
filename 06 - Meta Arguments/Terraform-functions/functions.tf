#1. COUNT:

resource "aws_iam_user" "example" {
  count = 3
  name  = "neo.${count.index}"
}

#######################################
variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["neo", "trinity", "morpheus"]
}

resource "aws_iam_user" "count" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}

output "first_arn" {
  value       = aws_iam_user.count[0].arn
  description = "The ARN for the first user"
}

output "all_arns" {
  value       = aws_iam_user.count[*].arn
  description = "The ARNs for all users"
}

#2. LOOP WITH FOR_EACH - ONLY loops over sets and maps - convert lists into sets using toset

resource "aws_iam_user" "for_each" {
  for_each = toset(var.user_names)
  name     = each.value
}

#Once you’ve used for_each on a resource, it becomes a map of resources,

output "all_users" {
  value = aws_iam_user.for_each
}

output "all_user_arns" {
  value = values(aws_iam_user.for_each)[*].arn
}

#3. FOR LOOP

#[for <ITEM> in <LIST> : <OUTPUT>]
# Loop over a list
output "upper_names" {
  value = [for name in var.user_names : upper(name)]
}

output "short_upper_names" {
  value = [for name in var.user_names : upper(name) if length(name) < 5]
}

# Loop over a map
variable "hero_thousand_faces" {
  description = "map"
  type        = map(string)
  default = {
    neo      = "hero"
    trinity  = "love interest"
    morpheus = "mentor"
  }
}
output "bios" {
  value = [for name, role in var.hero_thousand_faces : "${name} is the ${role}"]
}

#You can also use for expressions to output a map rather than a list using the following syntax:

# Loop over a list and output a map
#  {for <ITEM> in <LIST> : <OUTPUT_KEY> => <OUTPUT_VALUE>}

# Loop over a map and output a map
#  {for <KEY>, <VALUE> in <MAP> : <OUTPUT_KEY> => <OUTPUT_VALUE>}

#The only differences are that (a) you wrap the expression in curly braces rather than square brackets, and (b) rather than
#outputting a single value each iteration, you output a key and value, separated by an arrow.

output "upper_roles" {
  value = { for name, role in var.hero_thousand_faces : upper(name) => upper(role) }
}

# Conditional expressions
#Terraform supports conditional expressions of the format <CONDITION> ? <TRUE_VAL> : <FALSE_VAL>.
#This ternary syntax, which may be familiar to you from other programming languages, will evaluate the Boolean logic in CONDITION,
#and if the result is true, it will return TRUE_VAL, and if the result is false, it’ll return FALSE_VAL.

resource "aws_iam_user" "count1" {
  count = length(var.user_names) > 0 ? 1 : 0
  name  = var.user_names[count.index]
}


#{ for name in var.user_names : key => value }
#{ for name, role in var.user_names : key => value }

#4. Conditional expressions - ternary syntax - returns bool value
#condition ? true : false

resource "aws_iam_user" "ternary" {
  count = var.check && length(var.user_names) > 0 && length(var.group) > 0 ? length(var.user_names) : 0
  name  = var.user_names[count.index]
}

variable "check" {
  type    = bool
  default = true
}

variable "group" {
  type    = list(string)
  default = ["dev", "prod", "uat"]
}