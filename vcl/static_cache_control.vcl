# This is needed because Rails does not properly set them
# See https://github.com/mastodon/mastodon/issues/24021

if (req.url.path == "/sw.js") {
  set beresp.http.Cache-Control = "public, max-age=300, stale-while-revalidate, immutable";
} else if(req.url.path ~ "^/sounds/.+") {
  set beresp.http.Cache-Control = "public, max-age=3600, stale-while-revalidate, immutable";
} else if(req.url.path ~ "^/avatars/.+") {
  set beresp.http.Cache-Control = "public, max-age=3600, stale-while-revalidate, immutable";
} else if(req.url.path ~ "^/emoji/.+") {
  set beresp.http.Cache-Control = "public, max-age=3600, stale-while-revalidate, immutable";
} else if(req.url.path ~ "^/shortcuts/.+") {
  set beresp.http.Cache-Control = "public, max-age=3600, stale-while-revalidate, immutable";
} else if(req.url.path ~ "^/headers/.+") {
  set beresp.http.Cache-Control = "public, max-age=3600, stale-while-revalidate, immutable";
} else if(req.url.path ~ "^/(robots\.txt|oops\.png|oops\.gif|inert\.css|favicon\.ico|embed\.js|badge\.png)$") {
  set beresp.http.Cache-Control = "public, max-age=3600, stale-while-revalidate, immutable";
}