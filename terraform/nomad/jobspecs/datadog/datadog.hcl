job "datadog" {
  datacenters = ["dc1", "cascadia"]
  priority = 100

  type = "system"

  group "agent" {
    count = 1

    task "agent" {
      driver = "docker"

      restart {
        delay = "30s"
        interval = "5m"
        mode = "delay"
      }

      config {
        image = "gcr.io/datadoghq/agent:7"
        labels { group = "metrics" }
        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock:ro",
          "/proc/:/host/proc/:ro",
          "/sys/fs/cgroup/:/host/sys/fs/cgroup:ro",
          "/var/lib/docker/containers:/var/lib/docker/containers:ro",
        ]
      }
      resources {
        cpu = 768
        memory = 512
      }

      # Configuration
      template {
        data = <<-EOF
DD_API_KEY="${datadog_api_key}"
DD_SITE="${datadog_site}"
EOF
        destination = "local/env"
        env = true
      }

    }
  }
}
