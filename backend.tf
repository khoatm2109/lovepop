terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "lovepop-tfstate"
    dynamodb_table = "lovepop-tfstate-lock"
    region         = "ap-northeast-1"
    key            = "terraform.tfstate"
  }
}
# Partition key LockID