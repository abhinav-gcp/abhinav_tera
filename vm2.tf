resource "google_compute_instance" "vm2_tf" {
  name = "vm2-tf"
  machine_type = "f1-micro"
  zone = var.zone
  can_ip_forward = false  # Ensure no external IP is assigned

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.terraform_network_tf.name
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    echo "Hello from Private Server" > /var/www/html/index.html
    systemctl restart apache2
  EOF
}
