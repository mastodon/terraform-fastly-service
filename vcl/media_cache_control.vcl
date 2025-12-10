if (req.backend == ${backend}) {
  set beresp.http.Cache-Control = "public, max-age=3600, stale-while-revalidate, immutable";
}
