backend F_sigsci_waf {
	.always_use_host_header = true;
	.between_bytes_timeout = 60s; # real timeouts are in waf
	.connect_timeout = 1s;
	.dynamic = true;
	.first_byte_timeout = 600s; # real timeouts are in waf
	.host = "${host}";
	.host_header = "${host}";
	.max_connections = 200;
	.port = "443";
	.share_key = "${shared_key}";
	.ssl = true;
	.ssl_cert_hostname = "${host}";
	.ssl_check_cert = always;
	.ssl_sni_hostname = "${host}";
	.probe = {
		.dummy = false; # this is a real healthcheck for fail open
		.initial = 1;
		.interval = 12s;
		.request = "HEAD / HTTP/1.1" "Host: ${host}" "Connection: close" "x-sigsci-backend: health check" "x-sigsci-host: host health check";
		.expected_response = 200;
		.threshold = 1;
		.timeout = 2s;
		.window = 5;
	}
}

sub edge_security {
	if (!req.backend.is_origin) {
		return;
	}

	if (!backend.F_sigsci_waf.healthy) {
		set bereq.http.x-sigsci-no-inspection = "unhealthy_waf";
	}
	
	# if the Enabled key is absent then default to Enabled=0%
	if (bereq.http.x-sigsci-no-inspection || !randombool(std.atoi(table.lookup(Edge_Security, "Enabled", "0")), 100)) {
		unset bereq.http.x-sigsci-no-inspection;
		unset bereq.http.x-sigsci-requestid;
		unset bereq.http.x-sigsci-tlscipher;
		unset bereq.http.x-sigsci-tlsprotocol;
		unset bereq.http.x-sigsci-bot-data;
		return;
	}

	if (!waf.executed) {
		set bereq.http.x-sigsci-backend = regsub(req.backend, "^[a-zA-Z0-9]+--(?:F_)?", "");
		set bereq.http.x-sigsci-host = bereq.http.host;
		set bereq.http.x-sigsci-scheme = req.protocol;
		if (!bereq.http.x-sigsci-ip-address) {
			set bereq.http.x-sigsci-ip-address = req.http.fastly-client-ip;
		}
		set bereq.http.x-sigsci-protocol = req.proto;
		set bereq.http.x-sigsci-serviceid = req.service_id;
		set bereq.http.x-sigsci-edgemodule = "vcl 1.11.1";
		set req.backend = F_sigsci_waf;
		set waf.executed = true;
	}
}

sub vcl_recv {
	if (req.restarts == 0) {
		if (fastly.ff.visits_this_service == 0) {
			set req.http.fastly-client-ip = client.ip;
			set req.http.x-sigsci-tlscipher = tls.client.cipher;
			set req.http.x-sigsci-tlsprotocol = tls.client.protocol;
			set req.http.x-sigsci-bot-data = {"{"}
				{""a":"} client.as.number {","}
				{""c":""} tls.client.ciphers_list {"","}
				{""e":""} tls.client.tlsexts_list {"","}
				{""h":""} fastly_info.h2.fingerprint {"","}
				{""j":""} tls.client.ja3_md5 {"""}
			{"}"};
		}

		unset req.http.x-sigsci-ip-address;
		unset req.http.x-sigsci-no-inspection;

		set req.http.x-sigsci-requestid = uuid.version4();
	}
}
