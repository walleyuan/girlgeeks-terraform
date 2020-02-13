#variable "mongodbatlas_public_key" {}
#variable "mongodbatlas_private_key" {}
#variable "pagerduty_service_key" {}

# Configure the MongoDB Atlas Provider
provider "mongodbatlas" {
  public_key = "zmsyndzb"
  private_key  = "11a8e534-12f7-412a-af41-758bececfe48"
}

resource "mongodbatlas_cluster" "GirlGeek" {
  project_id   = "5e43ad79d5ec135f397d33dd"
  name         = "GirlGeek"
  num_shards   = 3

  backup_enabled               = true
  auto_scaling_disk_gb_enabled = true
  mongo_db_major_version       = "4.0"

  //Provider Settings "block"
  provider_name               = "AZURE"  
  provider_disk_type_name     = "P6"
  provider_instance_size_name = "M30"
  provider_region_name        = "US_EAST_2"
}
#Making connection


