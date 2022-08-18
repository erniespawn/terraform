provider "google" {
  project = "kennytest-357116"
  region  = "europe-west4"
  zone    = "europe-west4-a"
}

#
#resource "google_compute_instance_template" "webserver" {
#  name                    = "standard-webserver"
#  machine_type            = "f1-micro"
#  metadata_startup_script = "apt-get update && apt-get install -y nginx"
#
#  network_interface {
#    network    = "services-nl-networks"
#    subnetwork = "enum-euwe4"
#    access_config {
#    }
#    tags = ["foo", "bar"]
#  }
#  disk {
#    source_image = "debian-cloud/debian-11"
#    auto_delete  = true
#    boot         = true
#  }
#}


#resource "google_compute_instance_group_manager" "webservers" {
#  #  machine_type = ""
#  name               = "my-webservers"
#  zone               = "europe-west4-a"
#  target_size        = 1
#  #  boot_disk {}
#  #  network_interface {}
#  base_instance_name = "webserver"
#  version {
#    instance_template = ""
#  }
#  named_port {
#    name = "http"
#    port = 80
#  }
#}
#
#
#
#
#
#
#
#
#
#
#
#
#
