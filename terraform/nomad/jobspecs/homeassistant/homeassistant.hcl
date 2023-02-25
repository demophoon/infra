job "homeassistant" {
  datacenters = ["cascadia"]
  priority = 100

  group "appdaemon" {
    count = 1
    restart { mode = "delay" }

    volume "appdaemon" {
      type = "host"
      source = "appdaemon"
    }
    network {
      port "appdaemon"  {
        to = 5050
        static = 5050
      }
    }
    task "appdaemon" {
      driver = "docker"

      config {
        network_mode = "host"
        image = "acockburn/appdaemon:latest"
        image_pull_timeout = "15m"
        ports = ["appdaemon"]
      }
      volume_mount {
        volume = "appdaemon"
        destination = "/conf"
      }
      resources {
        cpu = 512
        memory = 256
      }
      service {
        name = "had"
        port = "appdaemon"
        tags = [
          "traefik.enable=true"
        ]
      }
    }
  }

  group "homeassistant" {
    count = 1
    restart { mode = "delay" }

    network {
      port "homeassistant" {
        to = 8123
        static = 8123
      }
    }
    volume "homeassistant" {
      type = "host"
      source = "homeassistant"
    }
    task "homeassistant" {
      driver = "docker"

      config {
        network_mode = "host"
        image = "homeassistant/home-assistant:2023.9"
        image_pull_timeout = "15m"
        privileged = true
        volumes = [
          "/run/dbus:/run/dbus:ro",
          "/etc/localtime:/etc/localtime:ro",
        ]
      }
      volume_mount {
        volume = "homeassistant"
        destination = "/config"
      }
      resources {
        cpu = 4096
        memory = 2048
      }
      service {
        name = "ha"
        port = "homeassistant"
        tags = [
          "traefik.enable=true",
          "traefik.http.middlewares.ha-redirect.redirectregex.regex=^https?://ha.cascadia.demophoon.com/",
          "traefik.http.middlewares.ha-redirect.redirectregex.replacement=https://ha.services.demophoon.com/",
          "traefik.http.routers.ha.rule=Host(`ha.services.demophoon.com`) || Host(`ha.cascadia.demophoon.com`)",
          "traefik.http.routers.ha.middlewares=ha-redirect",
        ]
      }
    }
  }

  group "mqtt-server" {
    count = 1
    restart { mode = "delay" }

    network {
      port "mqtt-unencrypted" {
        to = 1883
        static = 1883
      }
    }
    volume "mosquitto" {
      type = "host"
      source = "mosquitto"
    }
    task "mosquitto" {
      driver = "docker"
      config {
        image = "eclipse-mosquitto:latest"
        image_pull_timeout = "15m"
        ports = ["mqtt-unencrypted"]
      }
      volume_mount {
        volume = "mosquitto"
        destination = "/mosquitto"
      }
      resources {
        cpu = 512
        memory = 256
      }
      service {
        name = "mosquitto"
        port = "mqtt-unencrypted"
      }
    }
  }

  group "zigbee2mqtt" {
    count = 1
    restart { mode = "delay" }
    network {
      port "ui" { to = 8080 }
    }
    volume "zigbee2mqtt" {
      type = "host"
      source = "zigbee2mqtt"
    }

    task "coordinator" {
      driver = "docker"
      env {
        TZ = "America/Los_Angeles"
      }
      config {
        image = "koenkk/zigbee2mqtt:1.31.2"
        image_pull_timeout = "15m"
        ports = ["ui"]
      }
      volume_mount {
        volume = "zigbee2mqtt"
        destination = "/app/data"
      }
      resources {
        cpu = 512
        memory = 256
      }
      service {
        name = "coordinator"
        port = "ui"
      }
    }
  }

  group "esphome" {
    count = 0
    restart { mode = "delay" }

    network {
      port "esp" { static = 6052 }
    }

    task "esphome" {
      driver = "docker"
      config {
        network_mode = "host"
        image = "ghcr.io/esphome/esphome:latest"
        image_pull_timeout = "15m"
        privileged = true
        volumes = [
          "/mnt/nfs/gpool0/services/homeassistant/esphome:/config",
          "/etc/localtime:/etc/localtime:ro",
        ]
        ports = ["esp"]
      }
      resources {
        cpu = 1024
        memory = 1024
      }
      service {
        name = "espweb"
        port = "esp"
        tags = [
          "internal=true",
        ]
      }
    }
  }
}
