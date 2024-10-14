locals {
  name = var.name != "" ? var.name : var.hostname

  backend_name     = var.backend_name != "" ? var.backend_name : "${var.hostname} - backend"
  ssl_hostname     = var.ssl_hostname != "" ? var.ssl_hostname : var.hostname
  healthcheck_host = var.healthcheck_host != "" ? var.healthcheck_host : var.hostname
  healthcheck_name = var.healthcheck_name != "" ? var.healthcheck_name : "${var.hostname} - healthcheck"

  media_backend_name = var.media_backend["name"] != "" ? var.media_backend["name"] : "${local.backend_name} - media"
  media_ssl_hostname = var.media_backend["ssl_hostname"] != "" ? var.media_backend["ssl_hostname"] : var.media_backend["address"]

  edge_security_dict_name = "Edge_Security"

  datadog_format         = replace(file("${path.module}/logging/datadog.json"), "__service__", var.datadog_service)
  fastly_globeviz_format = file("${path.module}/logging/fastly_globeviz.json")

  associated_domain_response = file("${path.module}/responses/associated_domain.json")
  deep_link_response         = file("${path.module}/responses/deep_link.json")

  vcl_main = file("${path.module}/vcl/main.vcl")
  vcl_sigsci_config = templatefile("${path.module}/vcl/sigsci_config.vcl", {
    host       = var.signal_science_host,
    shared_key = var.signal_science_shared_key
  })

  vcl_apex_error            = templatefile("${path.module}/vcl/apex_error.vcl", { hostname = var.hostname })
  vcl_apex_redirect         = templatefile("${path.module}/vcl/apex_redirect.vcl", { hostname = var.hostname })
  vcl_backend_403           = file("${path.module}/vcl/backend_403.vcl")
  vcl_block_user_agents     = file("${path.module}/vcl/block_user_agents.vcl")
  vcl_custom_error_redirect = file("${path.module}/vcl/custom_error_redirect.vcl")
  vcl_custom_error          = templatefile("${path.module}/vcl/custom_error.vcl", { hostname = var.hostname })
  vcl_static_cache_control  = file("${path.module}/vcl/static_cache_control.vcl")
  vcl_tarpit                = file("${path.module}/vcl/tarpit.vcl")
  vcl_globeviz              = templatefile("${path.module}/vcl/globeviz.vcl", { service = var.globeviz_service })
  vcl_media_redirect        = templatefile("${path.module}/vcl/media_redirect.vcl", {
    backend  = "F_${replace(local.media_backend_name, " ", "_")}}",
    redirect = var.media_backend["redirect_uri"]
  })
}

resource "fastly_service_vcl" "app_service" {
  name = local.name

  default_ttl    = var.default_ttl
  http3          = true
  stale_if_error = true

  domain {
    name = var.hostname
  }
  dynamic "domain" {
    for_each = var.domains
    content {
      name = domain.value
    }
  }

  # Backend
  backend {
    name    = local.backend_name
    address = var.backend_address

    auto_loadbalance      = false
    between_bytes_timeout = var.backend_between_bytes_timeout
    first_byte_timeout    = var.backend_first_byte_timeout
    healthcheck           = local.healthcheck_name
    keepalive_time        = 0
    override_host         = local.ssl_hostname
    port                  = var.backend_port
    max_conn              = var.max_conn
    min_tls_version       = var.min_tls_version
    shield                = var.shield_region
    ssl_ca_cert           = var.backend_ca_cert
    ssl_check_cert        = var.backend_ssl_check
    ssl_cert_hostname     = var.backend_ssl_check ? local.ssl_hostname : ""
    ssl_sni_hostname      = local.ssl_hostname
    use_ssl               = var.use_ssl
  }

  # Media backend
  dynamic "backend" {
    for_each = var.media_backend["address"] != "" ? [1] : []
    content {
      address = var.media_backend["address"]
      name    = var.media_backend["name"] != "" ? var.media_backend["name"] : "${local.backend_name} - media"

      auto_loadbalance      = false
      between_bytes_timeout = var.backend_between_bytes_timeout
      first_byte_timeout    = var.backend_first_byte_timeout
      keepalive_time        = 0
      override_host         = var.media_backend["address"]
      port                  = var.backend_port
      max_conn              = var.max_conn
      min_tls_version       = var.min_tls_version
      request_condition     = var.media_backend["condition"] != "" ? var.media_backend["condition_name"] : ""
      ssl_check_cert        = var.media_backend["ssl_check"]
      ssl_cert_hostname     = var.media_backend["ssl_check"] ? local.media_ssl_hostname : ""
      ssl_sni_hostname      = var.media_backend["ssl_check"] ? local.media_ssl_hostname : ""
      use_ssl               = var.use_ssl
    }
  }

  dynamic "condition" {
    for_each = var.media_backend["condition"] != "" ? [1] : []
    content {
      name      = var.media_backend["condition_name"]
      statement = var.media_backend["condition"]
      type      = "REQUEST"
      priority  = 10
    }
  }

  # Healthcheck
  healthcheck {
    name = local.healthcheck_name
    host = local.healthcheck_host
    path = var.healthcheck_path

    check_interval    = 60000
    expected_response = var.healthcheck_expected_response
    initial           = 1
    method            = var.healthcheck_method
    threshold         = 1
    timeout           = 5000
    window            = 2
  }

  # Datadog logging
  dynamic "logging_datadog" {
    for_each = var.datadog ? [1] : []
    content {
      name   = "Datadog ${var.datadog_region}"
      format = local.datadog_format
      token  = var.datadog_token

      region = var.datadog_region
    }
  }

  # Fastly global visualization logging
  dynamic "logging_https" {
    for_each = var.fastly_globeviz_url != "" ? [1] : []
    content {
      name   = "fastly-globeviz"
      format = local.fastly_globeviz_format
      url    = var.fastly_globeviz_url

      content_type = "text/plain"
      method       = "POST"
      placement    = "none"
    }
  }

  # Force TLS/HSTS settings
  # Creates similar objects to what the GUI switch creates.

  dynamic "request_setting" {
    for_each = var.force_tls_hsts ? [1] : []
    content {
      name = "Generated by force TLS and enable HSTS"

      bypass_busy_wait = false
      force_miss       = false
      force_ssl        = true
      max_stale_age    = 0
      timer_support    = false
      xff              = ""
    }
  }

  dynamic "header" {
    for_each = var.force_tls_hsts ? [1] : []
    content {
      action      = "set"
      destination = "http.Strict-Transport-Security"
      name        = "Generated by force TLS and enable HSTS"
      type        = "response"

      ignore_if_set = false
      priority      = 100
      source        = "\"max-age=${var.hsts_duration}\""
    }
  }

  # Dynamic compression
  dynamic "header" {
    for_each = var.dynamic_compression ? [1] : []
    content {
      action      = "set"
      destination = "http.X-Compress-Hint"
      name        = "Dynamic Compression"
      type        = "response"

      priority = 100
      source   = "\"on\""
    }
  }

  # Signal Sciences integration
  # We need to enable a custom main VCL file in order to do what we need here

  dynamic "vcl" {
    for_each = var.signal_science_host != "" && var.signal_science_shared_key != "" ? [1] : []
    content {
      name    = "Main VCL File"
      content = local.vcl_main

      main = true
    }
  }

  dynamic "vcl" {
    for_each = (var.signal_science_host != "") && (var.signal_science_shared_key != "") ? [1] : []
    content {
      name    = "sigsci_config"
      content = local.vcl_sigsci_config
    }
  }

  # Redirect www

  dynamic "snippet" {
    for_each = var.apex_redirect ? [1] : []
    content {
      name     = "Redirect www to APEX - ERROR"
      content  = local.vcl_apex_error
      type     = "error"
      priority = 100
    }
  }

  dynamic "snippet" {
    for_each = var.apex_redirect ? [1] : []
    content {
      name     = "Redirect www to APEX - RECV"
      content  = local.vcl_apex_redirect
      type     = "recv"
      priority = 100
    }
  }

  # Cache control for static files
  dynamic "snippet" {
    for_each = var.static_cache_control ? [1] : []
    content {
      name     = "Add cache-control headers for static files"
      content  = local.vcl_static_cache_control
      type     = "fetch"
      priority = 100
    }
  }

  # Mastodon official error page

  dynamic "snippet" {
    for_each = var.mastodon_error_page ? [1] : []
    content {
      name     = "Custom 503 error page"
      content  = local.vcl_custom_error
      type     = "error"
      priority = 100
    }
  }

  dynamic "snippet" {
    for_each = var.mastodon_error_page ? [1] : []
    content {
      name     = "Redirect 503 to custom error page"
      content  = local.vcl_custom_error_redirect
      type     = "fetch"
      priority = 100
    }
  }

  # Tarpit

  dynamic "snippet" {
    for_each = var.tarpit ? [1] : []
    content {
      name     = "Enable tarpit"
      content  = local.vcl_tarpit
      type     = "deliver"
      priority = 100
    }
  }

  dynamic "snippet" {
    for_each = var.tarpit ? [1] : []
    content {
      name     = "Custom header for source 403"
      content  = local.vcl_backend_403
      type     = "fetch"
      priority = 100
    }
  }

  # Fastly Globeviz integration
  dynamic "snippet" {
    for_each = var.globeviz_service != "" ? [1] : []
    content {
      name     = "Collect Globeviz data"
      content  = local.vcl_globeviz
      type     = "init"
      priority = 100
    }
  }

  # Media backend redirect
  dynamic "snippet" {
    for_each = var.media_backend["redirect"] == true ? [1] : []
    content {
      name     = "Rewrite assets requests to Exoscale"
      content  = local.vcl_media_redirect
      type     = "miss"
      priority = 100
    }
  }

  #snippet {
  #  name     = "Block outdated user agents"
  #  content  = local.vcl_block_user_agents
  #  type     = "revc"
  #  priority = 100
  #}

  # User-defined custom VCL snippets
  dynamic "snippet" {
    for_each = var.vcl_snippets
    content {
      content  = snippet.value["content"]
      name     = snippet.value["name"]
      type     = snippet.value["type"]
      priority = snippet.value["priority"]
    }
  }

  # gzip default policy
  dynamic "gzip" {
    for_each = var.gzip_default_policy ? [1] : []
    content {
      content_types = [
        "text/html",
        "application/x-javascript",
        "text/css",
        "application/javascript",
        "text/javascript",
        "application/json",
        "application/vnd.ms-fontobject",
        "application/x-font-opentype",
        "application/x-font-truetype",
        "application/x-font-ttf",
        "application/xml",
        "font/eot",
        "font/opentype",
        "font/otf",
        "image/svg+xml",
        "image/vnd.microsoft.icon",
        "text/plain",
        "text/xml",
      ]
      extensions = [
        "css",
        "js",
        "html",
        "eot",
        "ico",
        "otf",
        "ttf",
        "json",
        "svg",
      ]
      name = "Generated by default compression policy"
    }
  }

  # Additional products
  product_enablement {
    brotli_compression = var.product_enablement.brotli_compression
    domain_inspector   = var.product_enablement.domain_inspector
    image_optimizer    = var.product_enablement.image_optimizer
    origin_inspector   = var.product_enablement.origin_inspector
    websockets         = var.product_enablement.websockets
  }

  # Support Apple Associated Domains

  dynamic "condition" {
    for_each = var.apple_associated_domain ? [1] : []
    content {
      name      = "Associated domain file is requested"
      statement = "req.url.path == \"/.well-known/apple-app-site-association\""
      type      = "REQUEST"
      priority  = 10
    }
  }

  dynamic "response_object" {
    for_each = var.apple_associated_domain ? [1] : []
    content {
      name = "Associated domain"

      content           = local.associated_domain_response
      content_type      = "application/json"
      request_condition = "Associated domain file is requested"
      response          = "OK"
      status            = 200
    }
  }

  dynamic "dictionary" {
    for_each = var.edge_security ? [1] : []
    content {
      name = local.edge_security_dict_name
    }
  }

  # Android deep link

  dynamic "condition" {
    for_each = var.android_deep_link ? [1] : []
    content {
      name      = "Android Deep Link is requested"
      statement = "req.url.path == \"/.well-known/assetlinks.json\""
      type      = "REQUEST"
      priority  = 10
    }
  }

  dynamic "response_object" {
    for_each = var.android_deep_link ? [1] : []
    content {
      name = "Android Deep Link"

      content           = local.deep_link_response
      content_type      = "application/json"
      request_condition = "Android Deep Link is requested"
      response          = "OK"
      status            = 200
    }
  }

  # IP Blocklist settings
  # Creates similar objects & resources to what the GUI IP Blocklist creates.

  dynamic "acl" {
    for_each = var.ip_blocklist ? [1] : []
    content {
      name = var.ip_blocklist_name
    }
  }

  dynamic "condition" {
    for_each = var.ip_blocklist ? [1] : []
    content {
      name      = "Generated by IP block list"
      priority  = 0
      statement = "client.ip ~ ${replace(var.ip_blocklist_name, " ", "_")}"
      type      = "REQUEST"
    }
  }

  dynamic "response_object" {
    for_each = var.ip_blocklist ? [1] : []
    content {
      name = "Generated by IP block list"

      content_type      = "text/html"
      request_condition = "Generated by IP block list"
      response          = "Forbidden"
      status            = 403
    }
  }

  # AS Blocklist settings
  # Any AS numbers that need to be blocked are added to a dictionary, and the
  # related condition/request objects are created.

  dynamic "dictionary" {
    for_each = var.as_blocklist ? [1] : []
    content {
      name = var.as_blocklist_name
    }
  }

  dynamic "dictionary" {
    for_each = var.as_blocklist ? [1] : []
    content {
      name = var.as_request_blocklist_name
    }
  }

  dynamic "condition" {
    for_each = var.as_blocklist ? [1] : []
    content {
      name      = "Generated by ${var.as_blocklist_name}"
      priority  = 10
      statement = "table.lookup(${replace(var.as_blocklist_name, " ", "_")}, client.as.number) == \"block\""
      type      = "REQUEST"
    }
  }

  dynamic "condition" {
    for_each = var.as_blocklist ? [1] : []
    content {
      name      = "Generated by ${var.as_request_blocklist_name}"
      priority  = 10
      statement = "table.lookup(${replace(var.as_request_blocklist_name, " ", "_")}, client.as.number) == \"block\" && req.url.path ~ \"^/(api/|explore)\""
      type      = "REQUEST"
    }
  }

  dynamic "response_object" {
    for_each = var.as_blocklist ? [1] : []
    content {
      name = "Generated by ${var.as_blocklist_name}"

      content_type      = "text/html"
      request_condition = "Generated by ${var.as_blocklist_name}"
      response          = "Forbidden"
      status            = 403
    }
  }

  dynamic "response_object" {
    for_each = var.as_blocklist ? [1] : []
    content {
      name = "Generated by ${var.as_request_blocklist_name}"

      content_type      = "text/html"
      request_condition = "Generated by ${var.as_request_blocklist_name}"
      response          = "Forbidden"
      status            = 403
    }
  }

  # JA3 Blocklist settings
  # Any requests that contain a TLS JA3 in the dictionary is blocked.

  dynamic "dictionary" {
    for_each = var.ja3_blocklist ? [1] : []
    content {
      name = var.ja3_blocklist_name
    }
  }

  dynamic "condition" {
    for_each = var.ja3_blocklist ? [1] : []
    content {
      name      = "Generated by ${var.ja3_blocklist_name}"
      priority  = 10
      statement = "table.lookup(${replace(var.ja3_blocklist_name, " ", "_")}, client.as.number) == \"block\""
      type      = "REQUEST"
    }
  }

  dynamic "response_object" {
    for_each = var.ja3_blocklist ? [1] : []
    content {
      name = "Generated by ${var.ja3_blocklist_name}"

      content_type      = "text/html"
      request_condition = "Generated by ${var.ja3_blocklist_name}"
      response          = "Forbidden"
      status            = 403
    }
  }
}

# Edge Security
resource "fastly_service_dictionary_items" "edge_security" {
  for_each = {
    for d in fastly_service_vcl.app_service.dictionary : d.name => d if d.name == local.edge_security_dict_name
  }
  service_id    = fastly_service_vcl.app_service.id
  dictionary_id = each.value.dictionary_id

  items = { Enabled = 100 }
}

# IP Blocklist entries
resource "fastly_service_acl_entries" "ip_blocklist_entries" {
  for_each = {
    for d in fastly_service_vcl.app_service.acl : d.name => d if d.name == var.ip_blocklist_name
  }
  service_id     = fastly_service_vcl.app_service.id
  acl_id         = each.value.acl_id
  manage_entries = length(var.ip_blocklist_items) > 0 ? true : false

  dynamic "entry" {
    for_each = var.ip_blocklist_items
    content {
      ip      = split("/", entry.value)[0]
      subnet  = length(split("/", entry.value)) == 1 ? "32" : split("/", entry.value)[1]
      negated = false
      comment = "Generated by IP block list"
    }
  }
}

# AS Blocklist dictionary entries

resource "fastly_service_dictionary_items" "as_blocklist_entries" {
  for_each = {
    for d in fastly_service_vcl.app_service.dictionary : d.name => d if d.name == var.as_blocklist_name
  }
  service_id    = fastly_service_vcl.app_service.id
  dictionary_id = each.value.dictionary_id
  manage_items  = length(var.as_blocklist_items) > 0 ? true : false

  items = { for i in var.as_blocklist_items : i => "block" }
}

resource "fastly_service_dictionary_items" "as_request_blocklist_entries" {
  for_each = {
    for d in fastly_service_vcl.app_service.dictionary : d.name => d if d.name == var.as_request_blocklist_name
  }
  service_id    = fastly_service_vcl.app_service.id
  dictionary_id = each.value.dictionary_id
  manage_items  = length(var.as_request_blocklist_items) > 0 ? true : false

  items = { for i in var.as_request_blocklist_items : i => "block" }
}

# JA3 Blocklist dictionary entries
resource "fastly_service_dictionary_items" "ja_blocklist_entries" {
  for_each = {
    for d in fastly_service_vcl.app_service.dictionary : d.name => d if d.name == var.ja3_blocklist_name
  }
  service_id    = fastly_service_vcl.app_service.id
  dictionary_id = each.value.dictionary_id
  manage_items  = length(var.ja3_blocklist_items) > 0 ? true : false

  items = { for i in var.ja3_blocklist_items : i => "block" }
}
