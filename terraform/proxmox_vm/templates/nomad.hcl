data_dir  = "/opt/nomad"

bind_addr = "{{ GetInterfaceIP \"tailscale0\" }}"

server {
  enabled = true
}

client {
  enabled       = true
  network_interface = "tailscale0"

  node_class = "ephemeral"
  meta {
    provider = "${provider}"
    region = "${region}"
  }

  host_volume "docker-sock-ro" {
    path = "/var/run/docker.sock"
    read_only = true
  }

  host_volume "gpool0" { path = "/mnt/nfs/gpool0" }

  # Home Assistant
  host_volume "homeassistant" { path = "/mnt/nfs/gpool0/services/homeassistant/homeassistant" }
  host_volume "appdaemon"     { path = "/mnt/nfs/gpool0/services/homeassistant/appdaemon" }
  host_volume "mosquitto"     { path = "/mnt/nfs/gpool0/services/homeassistant/mosquitto" }
  host_volume "zigbee2mqtt"   { path = "/mnt/nfs/gpool0/services/homeassistant/zigbee2mqtt/data" }

  # Vaultwarden
  host_volume "vaultwarden" {
    path = "/mnt/nfs/gpool0/services/vaultwarden"
  }

  # Authelia
  host_volume "authelia_config"  { path = "/mnt/nfs/gpool0/services/authelia/config" }
  host_volume "authelia_secrets" { path = "/mnt/nfs/gpool0/services/authelia/secrets" }
  host_volume "authelia_redis"   { path = "/mnt/nfs/gpool0/services/authelia/redis" }

  # Uptime Kuma
  host_volume "uptime_kuma" { path = "/mnt/nfs/uptime-kuma" }

  # Nextcloud
  host_volume "nextcloud_app" { path = "/mnt/nfs/nextcloud" }
  host_volume "nextcloud_db"  { path = "/mnt/nfs/nextcloud-db" }

  # Syncthing
  host_volume "syncthing" { path = "/mnt/nfs/syncthing" }

  # Immich
  host_volume "immich-upload"   { path = "/mnt/nfs/immich/uploads" }
  host_volume "immich-database" { path = "/mnt/nfs/immich/database" }

  # Plex
  host_volume "plex-config" { path = "/mnt/nfs/plex-config" }

  # Gitlab
  host_volume "gitlab-etc" { path = "/mnt/nfs/gitlab/etc" }
  host_volume "gitlab-log" { path = "/mnt/nfs/gitlab/log" }
  host_volume "gitlab-opt" { path = "/mnt/nfs/gitlab/opt" }

  # Static Files
  host_volume "local-static" { path = "/mnt/nfs/static" }

  # Grafana
  host_volume "grafana" { path = "/mnt/nfs/grafana" }
  host_volume "loki" { path = "/mnt/nfs/loki" }

  # Docker Registry
  host_volume "registry-data" { path = "/mnt/nfs/registry/data" }
  host_volume "registry-certs" { path = "/mnt/nfs/registry/certs" }
  host_volume "registry-auth" { path = "/mnt/nfs/registry/auth" }

  # Waypoint
  host_volume "waypoint-server" { path = "/mnt/nfs/waypoint/server" }
  host_volume "waypoint-runner" { path = "/mnt/nfs/waypoint/runner" }

  # Prometheus
  host_volume "prometheus-config" { path = "/mnt/nfs/prometheus/config" }
  host_volume "prometheus-data" { path = "/mnt/nfs/prometheus/data" }

  # Changedetection
  host_volume "changedetection" { path = "/mnt/nfs/changedetection" }

  # Minio
  host_volume "minio" { path = "/mnt/nfs/minio" }

  # Mastodon
  host_volume "mastodon-db" { path = "/mnt/nfs/mastodon/db" }
  host_volume "mastodon-redis" { path = "/mnt/nfs/mastodon/redis" }
  host_volume "mastodon-es" { path = "/mnt/nfs/mastodon/elasticsearch" }

  # Truecommand
  host_volume "truecommand" { path = "/mnt/nfs/truecommand" }

  # Empyrion
  host_volume "empyrion-steam" { path = "/mnt/nfs/empyrion/steam" }
  host_volume "empyrion-data" { path = "/mnt/nfs/empyrion/data" }

  # *arr services
  host_volume "transmission-data"   { path = "/mnt/nfs/arr/transmission/data" }
  host_volume "transmission-config" { path = "/mnt/nfs/arr/transmission/config" }
  host_volume "transmission-ovpn"   { path = "/mnt/nfs/arr/transmission/ovpn" }
  host_volume "prowlarr-config"     { path = "/mnt/nfs/arr/prowlarr" }
  host_volume "lidarr-config"       { path = "/mnt/nfs/arr/lidarr" }
  host_volume "sonarr-config"       { path = "/mnt/nfs/arr/sonarr" }
  host_volume "radarr-config"       { path = "/mnt/nfs/arr/radarr" }
  host_volume "overseerr-config"    { path = "/mnt/nfs/arr/overseerr" }

  # Valheim
  host_volume "valheim-config" { path = "/mnt/nfs/valheim/config" }
  host_volume "valheim-data" { path = "/mnt/nfs/valheim/data" }
}

consul {
  address = "127.0.0.1:8500"
  tags = ["ephemeral"]
  server_auto_join = true
}

vault {
  enabled = true
  address = "https://active.vault.service.consul.demophoon.com:8200"
  token   = "${vault_token}"
  create_from_role = "nomad-cluster"
}

telemetry {
  prometheus_metrics = true
}

plugin "docker" {
  config {
    pull_activity_timeout = "10m"
    auth {
      config = "/root/.docker/config.json"
    }
    allow_privileged = true
    allow_caps = ["all"]
    volumes {
      enabled = true
    }
    extra_labels = ["job_name", "task_group_name", "task_name", "namespace", "node_name"]
  }
}

ui {
  enabled = true
}
