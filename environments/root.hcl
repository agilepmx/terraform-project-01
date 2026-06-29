locals{
    account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
    region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

    account_name = local.account_vars.locals.account_name
    account_id = local.account_vars.locals.account_id
    aws_region = local.region_vars.locals.aws_region
}


remote_state {
    backend = "s3"
    config = {
        bucket = "agile-terraform-state-${local.account_name}-${local.account_id}"
        key = "${local.aws_region}/${path_relative_to_include()}/terraform.tfstate"
        region = "${local.aws_region}"
        encrypt = true
        use_lockfile  = true
    }
    generate = {
        path = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}

generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
    provider "aws" {
        region = "${local.aws_region}"
        assume_role {
            role_arn = "arn:aws:iam::${local.account_id}:role/OrganizationAccountAccessRole"
        }
        default_tags {
            tags = {
                "Project" = "agile"
                "Environment" = "${local.account_name}"
                "Region" = "${local.aws_region}"
                "ManagedBy" = "Terraform"
            }
        }
    }
    EOF
}