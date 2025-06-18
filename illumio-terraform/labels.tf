# Define labels to be used by the example application

resource "illumio-core_label" "role_db" {
  key   = "role"
  value = "db"
}

resource "illumio-core_label" "role_processing" {
  key   = "role"
  value = "processing"
}

resource "illumio-core_label" "role_web" {
  key   = "role"
  value = "web"
}

resource "illumio-core_label" "app_yelb" {
  key   = "app"
  value = "yelb"
}
