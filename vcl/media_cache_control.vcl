if (req.backend == ${backend} || req.backend == F_${backend}) {
  set beresp.http.Cache-Control = "public, max-age=3600, stale-while-revalidate, immutable";
}
