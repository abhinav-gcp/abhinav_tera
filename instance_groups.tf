resource "google_compute_instance_group" "ig_vm1_tf" {
  name = "ig-vm1-tf"
  zone = var.zone
  instances = [google_compute_instance.vm1_tf.self_link]
}

resource "google_compute_instance_group" "ig_vm2_tf" {
  name = "ig-vm2-tf"
  zone = var.zone
  instances = [google_compute_instance.vm2_tf.self_link]
}
