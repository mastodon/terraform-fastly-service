if ( req.url.path ~ "^/[a-zA-Z]{2}(?:-[a-zA-Z]{2})?/" ) {
  req.http.Vary = "Accept-Language";
}
