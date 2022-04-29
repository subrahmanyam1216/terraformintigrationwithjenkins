provider "google" {
 project     = var.project
 credentials = file("credential.json")
}

resource "google_compute_network" "vpc_network" {
 name           = var.vpc-name
 auto_create_subnetworks = false
}
 

resource "google_compute_subnetwork" "subnet" {
  count         = length(var.subnets)
  network       = google_compute_network.vpc_network.id
  name          = var.subnets[count.index]
  region        = var.subnet-regions[count.index]
  ip_cidr_range = var.cidr-ranges[count.index]
}

resource "google_compute_instance" "default" {
  count         = length(var.cidr-ranges)
  name          = "instance-${count.index+1}"
  //region       =  var.subnet-regions[count.index]
  zone          =  "${var.subnet-regions[count.index]}-${var.defzone}"
  machine_type  = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
   network_interface {
    network = google_compute_network.vpc_network.id
    subnetwork = "${var.subnets[count.index]}"
  
    access_config {
      
      // Ephemeral IP
    }
    
  }
}
