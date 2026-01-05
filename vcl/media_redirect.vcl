if ((req.backend == ${backend} || req.backend == F_${backend}) && req.method == "GET" && !req.backend.is_shield) {
  set bereq.url = "${redirect}" + req.url;
}
