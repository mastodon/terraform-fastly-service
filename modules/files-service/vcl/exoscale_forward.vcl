if (req.method == "GET" && !req.backend.is_shield) {
  set bereq.url = "/mastodon-online" + req.url;
}

if (req.url.ext ~ "(?i)^(jpe?g|png|gif|mp4|mp3|gz|svg|avif|webp)$") {
  
} else {
  error 404;
}