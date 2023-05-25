if (beresp.status == 403){
  set beresp.http.x-403-from-backend = "true";
}