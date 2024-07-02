resource "google_compute_network" "terraform_network_tf" {
  name = "terraform-network-tf"
  auto_create_subnetworks = true
}

resource "google_compute_router" "nat_router_tf" {
  name = "nat-router-tf"
  network = google_compute_network.terraform_network_tf.name
  region = var.region 
}

resource "google_compute_router_nat" "nat_tf" {
  name = "nat-tf"
  router = google_compute_router.nat_router_tf.name
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  region = var.region
}
