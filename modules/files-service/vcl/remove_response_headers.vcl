unset beresp.http.x-amz-id-2;
unset beresp.http.x-amz-request-id;
unset beresp.http.x-amz-meta-server-side-encryption;
unset beresp.http.x-amz-server-side-encryption;
unset beresp.http.x-amz-bucket-region;
unset beresp.http.x-amzn-requestid;

set beresp.http.Access-Control-Allow-Origin = "*";
set beresp.http.Access-Control-Allow-Methods = "GET";
set beresp.http.Access-Control-Allow-Headers = "DNT,X-CustomHeader,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type";
set beresp.http.Cache-Control = "public, max-age=315576000, immutable";