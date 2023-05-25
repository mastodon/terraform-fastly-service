if (
  fastly.ff.visits_this_service == 0 && (
    (resp.status == 403 && !resp.http.x-403-from-backend) ||
    resp.status == 406 
    # || resp.status == 429
  )
) { 
  #https://developer.fastly.com/reference/vcl/functions/miscellaneous/resp-tarpit/
  resp.tarpit(2, 100);
} 