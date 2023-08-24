# Terraform Configuration Language Syntax

## a) **Terraform top level Blocks**
https://www.terraform.io/docs/configuration/syntax.html
- A block is a container for other content.
- An example of a block template is as below.
## Template

     <BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>"   {
       # Block body
      <IDENTIFIER> = <EXPRESSION> # Argument
     }

## Terraform high level blocks
      - Terraform Settings Block
      - Provider Block
      - Resource Block
      - Input Variables Block
      - Output Values Block
      - Local Values Block
      - Data Sources Block
      - Modules Block
      - Moved Blocks
      - Import block

## AWS Example of a resource block.
```
resource "aws_instance" "ec2demo" {
  # BLOCK BODY
  ami           = "ami-04d29b6f966df1537" # Argument
  instance_type = var.instance_type # Argument with value as expression (Variable value replaced from variables.tf)

      network_interface {
       # ...
    }
  }
```

- A block has a type (resource in this example). Each block type defines how many labels must follow the type keyword. The resource block type expects two labels, which are aws_instance and ec2demo in the example above. A particular block type may have any number of required labels, or it may require none as with the nested network_interface block type.

- After the block type keyword and any labels, the block body is delimited by the { and } characters. Within the block body, further arguments and blocks may be nested, creating a hierarchy of blocks and their associated arguments.

## b) **Arguments, Expressions, Attributes & Meta-Arguments**

## Arguments
- They assign a value to a name. They appear within blocks. Arguments can be required or optional.

## Expressions
- They represent a value, either literally or by referencing and combining other values. They appear as values for arguments, or within other expressions.

## Attributes
- They represent a named piece of data that belongs to some kind of object. The value of an attribute can be referenced in expressions using a dot-separated notation, like aws_instance.example.id.
- The format looks like `resource_type.resource_name.attribute_name`

## Identifiers
- Argument names, block type names, and the names of most Terraform-specific constructs like resources, input variables, etc. are all identifiers.

- Identifiers can contain letters, digits, underscores (_), and hyphens (-). The first character of an identifier must not be a digit, to avoid ambiguity with literal numbers.

## Comments
- The Terraform language supports three different syntax for comments:
```
The # begins a single-line comment, ending at the end of the line.
// also begins a single-line comment, as an alternative to #.
/* and */ are start and end delimiters for a comment that might span over multiple lines.
The # single-line comment style is the default comment style and should be used in most cases. Automatic configuration formatting tools may automatically transform // comments into # comments, since the double-slash style is not idiomatic.
```

