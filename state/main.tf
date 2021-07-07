module "remote_state" {
  source = "github.com/TurnerLabs/terraform-remote-state"
  application = "cubelog"
  role = "reedville-admin"
  tags = {
    application = "cubelog"
    creator = "mjreed"
    repo = "github.com/markjreed/cubelog"
  }
}

output "bucket" {
  value = module.remote_state.bucket
}
