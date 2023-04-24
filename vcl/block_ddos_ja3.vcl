# From Fastly support

# Block with JA3 -- snippet goes in vcl_recv
if (req.restarts == 0 && fastly.ff.visits_this_service == 0) {
  if(tls.client.ja3_md5 == "d24e6f4486fa4b0edc7721026489bccf" || tls.client.ja3_md5 == "6c2a1325c6541a7fd4624cfdaaca445e") {
    error 403;
  }
}