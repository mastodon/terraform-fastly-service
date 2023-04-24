if (req.http.host == "www.${hostname}" ) {
  error 618 "redirect-to-apex";
}