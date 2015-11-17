module Api where


import Http
import Effects exposing (Effects)
import String
import Task exposing (Task)


mainUrl : String
mainUrl =
  "https://elm-articles.apispark.net/v1/"


authorization : String
authorization =
  "Basic ZTIxOTZlYmMtMjc4YS00MjhlLTkwYmQtMTNjMzg0YTU1ZWQxOmY0YTE5NWU0LWI3YTctNDBjOC1iYjZhLTUzNWNlZjk1NTk1NA=="


type Verb = Get | Post | Patch | Delete


type alias Path = String


{-| `Task Http.RawError Http.Response` means that the task will either fail
with an Http.RawError or succed with an Http.Response
-}
request : Verb -> Path -> Task Http.RawError Http.Response
request verb path =
  Http.send
    Http.defaultSettings
    { verb = String.toUpper (toString verb)
    , headers = [("authorization", authorization)]
    , url = mainUrl ++ path
    , body = Http.empty
    }
