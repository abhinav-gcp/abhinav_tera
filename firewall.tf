resource "google_compute_firewall" "allow_http_tf" {
  name = "allow-http-tf"
  network = google_compute_network.terraform_network_tf.name

  allow {
    protocol = "tcp"
    ports = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow-ssh-from-iap" {
  name    = "allow-ssh-from-iap"
  network = google_compute_network.terraform_network_tf.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}