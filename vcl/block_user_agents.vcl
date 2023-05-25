# this is from Fastly support

 if (req.http.user-agent ~ "(?i)(firefox|chrome)[\/]([\d]+)"){
  log "browser name:" re.group.1;
  log "browser version:" re.group.2;
  set req.http.version= re.group.2;
  if (req.http.version ~ "^([0-9]|[1-8][0-9]|90)$"){
    error 403;
  }
}
