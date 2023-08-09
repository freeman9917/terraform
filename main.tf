  provider "aws" {
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
 }

variable access_key {}
variable secret_key {}
variable region {}
variable vpc_cidr_block {}
variable pub1_subnet_cidr_block {}
variable pub2_subnet_cidr_block {}
variable avail_zone1 {}
variable avail_zone2 {}
variable env_prefix {}










