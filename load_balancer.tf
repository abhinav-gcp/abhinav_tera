# Define the backend services
resource "google_compute_backend_service" "backend_vm1_tf" {
  name        = "backend-vm1-tf"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  backend {
    group = google_compute_instance_group.ig_vm1_tf.self_link
  }

  health_checks = [google_compute_http_health_check.health_check_vm1_tf.self_link]
}

resource "google_compute_backend_service" "backend_vm2_tf" {
  name        = "backend-vm2-tf"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  backend {
    group = google_compute_instance_group.ig_vm2_tf.self_link
  }

  health_checks = [google_compute_http_health_check.health_check_vm2_tf.self_link]
}

# Define the health checks
resource "google_compute_http_health_check" "health_check_vm1_tf" {
  name               = "health-check-vm1-tf"
  request_path       = "/"
  port               = 80
  check_interval_sec = 1
  timeout_sec        = 1
}

resource "google_compute_http_health_check" "health_check_vm2_tf" {
  name               = "health-check-vm2-tf"
  request_path       = "/"
  port               = 80
  check_interval_sec = 1
  timeout_sec        = 1
}

# Define the URL map with path matchers and default service
resource "google_compute_url_map" "url_map_tf" {
  name = "url-map-tf"

  default_service = google_compute_backend_service.backend_vm2_tf.self_link

  host_rule {
    hosts        = ["*"]
    path_matcher = "path-matcher-tf"
  }

  path_matcher {
    name            = "path-matcher-tf"
    default_service = google_compute_backend_service.backend_vm2_tf.self_link

    path_rule {
      paths   = ["/public"]
      service = google_compute_backend_service.backend_vm1_tf.self_link
    }

    path_rule {
      paths   = ["/internal"]
      service = google_compute_backend_service.backend_vm2_tf.self_link
    }
  }
}

# Define the HTTP proxy
resource "google_compute_target_http_proxy" "http_proxy_tf" {
  name    = "http-lb-proxy-tf"
  url_map = google_compute_url_map.url_map_tf.self_link
}

# Define the global forwarding rule
resource "google_compute_global_forwarding_rule" "http_forwarding_rule_tf" {
  name       = "http-forwarding-rule-tf"
  target     = google_compute_target_http_proxy.http_proxy_tf.self_link
  port_range = "80"
}