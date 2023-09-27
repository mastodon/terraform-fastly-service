table globeviz_config {
  "service_name": "${service}", 
  "sample_rate": "50"  // send (1 / sample_rate) requests, target is 20-50
}

// https://deviceatlas.com/device-data/explorer/#defined_property_values/7/2705619
table globeviz_known_browsers {
  "Chrome": "C",
  "Chrome Mobile": "C",
  "Firefox": "F",
  "Firefox for Mobile": "F",
  "Edge": "E",
  "Kindle Browser": "K",
  "Safari": "S",
  "Samsung Browser": "A"
}

// Record the following data (space separated)
//    PIO             Name of source service (3 char)
//    LCY             Name of Fastly POP (3 char)
//    51.43,-0.23     Client location (var length)
//    17234           Duration (var length)
//    EN              Normalized Accept-Language (2 char)
//    M               Cache state (1 char: H, M, P)
//    2               HTTP version (numeric, variable length)
//    1.2             TLS version (numeric, variable length)
//    C               Browser (1 char: C, F, E, K, S, A)
//
sub vcl_log {
  // Record only non-shielding, non-VPN requests at the specified sample frequency
  if (fastly.ff.visits_this_service == 0 && client.geo.proxy_type == "?" && client.geo.latitude != 0 && randombool(1,std.atoi(table.lookup(globeviz_config, "sample_rate", "100000")))) {
    log "syslog " req.service_id " fastly-globeviz :: "
      table.lookup(globeviz_config, "service_name", "-") " "
      server.datacenter " "
      client.geo.latitude "," client.geo.longitude " "
      time.elapsed.usec " "
      std.toupper(
        accept.language_lookup(
          "en:de:fr:nl:jp:es:ar:zh:gu:he:hi:id:it:ko:ms:pl:pt:ru:th:uk",
          "en",
          req.http.Accept-Language
        )
      ) " "
      substr(fastly_info.state, 0, 1) " "
      regsuball(req.proto, "[^\d.]", "") " "
      regsuball(tls.client.protocol, "[^\d.]", "") " "
      table.lookup(globeviz_known_browsers, client.browser.name, "Z")
    ;
  }
}