if (obj.status == 618 && obj.response == "redirect-to-apex") {
    set obj.status = 308;
    set obj.http.Location = "https://${hostname}" + req.url;
    return (deliver);
}