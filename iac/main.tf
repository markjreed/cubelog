terraform {
  backend "s3"  {
    bucket = "tf-state-cubelog"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_dynamodb_table" "cubelog" {
  name = "cubelog"
  billing_mode = "PAY_PER_REQUEST"
  hash_key  = "puzzle"
  range_key = "timestamp"

  attribute {
    name = "puzzle"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  tags = {
    Name = "cubelog"
    creator = "mjreed"
    repo = "github.com/markjreed/cubelog"
  }
}

output "table" {
  value = aws_dynamodb_table.cubelog.name
}
