app [Model, init!, respond!] { pf: platform "https://github.com/roc-lang/basic-webserver/releases/download/0.11.0/yWHkcVUt_WydE1VswxKFmKFM5Tlu9uMn6ctPVYaas7I.tar.br" }

import pf.Stdout
import pf.Http exposing [Request, Response]
import pf.Utc

# Model is produced by `init`.
Model : {}

init! : {} => Result Model []
init! = \{} -> Ok {}


hello! : Request => Str
hello! = \req -> "Hello from server"

echo! : Request => Str
echo! = \req -> 
    body = Inspect.toStr req
    "$(body)"

respond! : Request, Model => Result Response [ServerErr Str]_
respond! = \req, _ ->
    # Log request datetime, method and url
    datetime = Utc.to_iso_8601 (Utc.now! {})

    try Stdout.line! "$(datetime) $(Inspect.toStr req.method) $(req.uri)"
    
    when req.uri is
        "/" -> Ok {
            status: 200,
            headers: [],
            body: Str.toUtf8 "<b>Hello from server</b></br>",
        }
        "/test" -> Ok {
            status: 200,
            headers: [],
            body: Str.toUtf8 (hello! req),
        }
        "/echo" -> Ok {
            status: 200,
            headers: [
                { name: "Content-Type", value: "text/plain" },
            ],
            body: Str.toUtf8 (echo! req),
        }
        _ -> Ok {
            status: 404,
            headers: [],
            body: Str.toUtf8 "Not found",
        }