resource "docker_network" "net_pub" {
  name = "red-publica"
}

resource "docker_network" "net_priv" {
  name = "red-privada"
}

resource "docker_image" "api_img" {
  name = "api-img:latest"
  build {
    context = "../../api"
  }
}

# Contenedor Local
resource "docker_container" "api_local" {
  name  = "api-localhost-01"
  image = docker_image.api_img.image_id
  env   = ["PORT=4002"]
  
  networks_advanced {
    name = docker_network.net_pub.name
  }
  networks_advanced {
    name = docker_network.net_priv.name
  }

  ports {
    internal = 4002
    external = 4002
  }
}

# Contenedor Dev
resource "docker_container" "api_dev" {
  name  = "api-dev-01"
  image = docker_image.api_img.image_id
  env   = ["PORT=5002"]
  
  networks_advanced {
    name = docker_network.net_pub.name
  }
  networks_advanced {
    name = docker_network.net_priv.name
  }

  ports {
    internal = 5002
    external = 5002
  }
}