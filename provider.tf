terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.74"  
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    bucket = "nobel-tf-state-bucket"
    key    = "tedsearch.tfstate"
    region = "us-east-1"
  }
}



provider "aws" {
  region = "us-east-1"
       default_tags {
        tags = {
            Owner = "Nobel-tedsearch"
            expiration_date = "01-29-2023"
            bootcamp = "ghana1"
            managed_by ="nobel-terraform"
             }
         }

}
