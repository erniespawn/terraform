provider "google" {
  project     = "kennytest-357116"
  region      = "europe-west4"
}

#resource "google_compute_instance_group" "staging_group" {
#  name      = "example-group"
#  zone         = "europe-west4-a"
#  instances = [google_compute_instance.staging_vm.id]
#
#  named_port {
#    name = "http"
#    port = "8080"
#  }
#
#  named_port {
#    name = "https"
#    port = "8443"
#  }
#
#  lifecycle {
#    create_before_destroy = true
#  }
#}

data "google_compute_image" "debian_image" {
  family  = "debian-11"
  project = "debian-cloud"
}

resource "google_compute_instance" "staging_vm" {
  name         = "staging-vm"
  machine_type = "f1-micro"
  zone         = "europe-west4-a"
  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_image.self_link
    }
  }

  network_interface {
    network = "services-nl-networks"
    subnetwork = "enum-euwe4"
  }
}

resource "google_compute_backend_service" "staging_service" {
  name      = "staging-service"
  port_name = "https"
  protocol  = "HTTPS"

  backend {
    group = google_compute_instance_group.staging_group.id
  }

  health_checks = [
    google_compute_https_health_check.staging_health.id,
  ]
}

resource "google_compute_https_health_check" "staging_health" {
  name         = "staging-health"
  request_path = "/health_check"
}

resource "google_compute_instance_group_manager" "instance_group_manager" {
  name               = "instance-group-manager"
  instance_template  = "${google_compute_instance_template.instance_template.self_link}"
  base_instance_name = "instance-group-manager"
  zone               = "europe-west4-a"
  target_size        = "1"
}


#
## Create a single Compute Engine instance
#resource "google_compute_instance" "default" {
#  name         = "flask-vm"
#  machine_type = "f1-micro"
#  zone         = "europe-west4-a"
#  tags         = ["ssh"]
#
#  metadata = {
#    enable-oslogin = "TRUE"
#  }
#  boot_disk {
#    initialize_params {
#      image = "debian-cloud/debian-11"
#    }
#  }
#
#  # Install Flask
#  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"
#
#  network_interface {
#    network = "default"
#
#    access_config {
#      # Include this section to give the VM an external IP address
#    }
#  }
#}

#
resource "google_compute_instance_group" "staging_group" {
  name      = "staging-instance-group"
  zone      = "europe-west4-a"
  instances = [google_compute_instance.staging_vm.id]
  named_port {
    name = "http"
    port = "8080"
  }

  named_port {
    name = "https"
    port = "8443"
  }

  lifecycle {
    create_before_destroy = true
  }
}
#
#data "google_compute_image" "debian_image" {
#  family  = "debian-10"
#  project = "debian-cloud"
#}
#
#resource "google_compute_instance" "staging_vm" {
#  name         = "staging-vm"
#  machine_type = "f1-micro"
#  zone         = "europe-west4-a"
#  boot_disk {
#    initialize_params {
#      image = data.google_compute_image.debian_image.self_link
#    }
#  }
#
#  network_interface {
#    network = "default"
#  }
#}
#
#resource "google_compute_backend_service" "staging_service" {
#  name      = "staging-service"
#  port_name = "https"
#  protocol  = "HTTPS"
#
#  backend {
#    group = google_compute_instance_group.staging_group.id
#  }
#
#  health_checks = [
#    google_compute_https_health_check.staging_health.id,
#  ]
#}
#
#resource "google_compute_https_health_check" "staging_health" {
#  name         = "staging-health"
#  request_path = "/health_check"
#}
