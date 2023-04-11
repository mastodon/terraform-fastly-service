if (req.url.ext ~ "^(mp4|mp3|gz|zip)$") {
  set req.enable_segmented_caching = true;
}