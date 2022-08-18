provider "google" {
  project = "kennytest-357116"
  region  = "europe-west4"
  zone    = "europe-west4-a"
}
resource "google_compute_instance_template" "webserver" {
  name        = "appserver-template"
  description = "This template is used to create app server instances."

  tags = ["foo", "bar"]

  labels = {
    environment = "dev"
  }

  instance_description = "description assigned to instances"
  machine_type         = "e2-medium"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image      = "debian-cloud/debian-11"
    auto_delete       = true
    boot              = true
    // backup the disk every day
    resource_policies = [google_compute_resource_policy.daily_backup.id]
  }

  // Use an existing disk resource
  disk {
    // Instance Templates reference disks by name, not self link
    source      = google_compute_disk.foobar.name
    auto_delete = false
    boot        = false
  }

  network_interface {
    network    = "services-nl-networks"
    subnetwork = "enum-euwe4"

    access_config {
#      network_tier = "PREMIUM"
    }

  }

  metadata = {
    foo = "bar"
  }


}

data "google_compute_image" "my_image" {
  family  = "debian-11"
  project = "debian-cloud"
}

resource "google_compute_disk" "foobar" {
  name  = "existing-disk"
  image = data.google_compute_image.my_image.self_link
  size  = 10
  type  = "pd-ssd"
  zone  = "europe-west4-a"
}

resource "google_compute_resource_policy" "daily_backup" {
  name   = "every-day-4am"
  region = "europe-west4"
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "04:00"
      }
    }
  }
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
