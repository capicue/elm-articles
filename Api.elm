module Api where


import Http exposing (fromJson)
import Effects exposing (Effects)
import String
import Task exposing (Task)
import Json.Decode as Decode exposing (Decoder, (:=), float, int, list, null, oneOf, string, succeed)


import Models exposing (Article)


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


(|:) : Decoder (a -> b) -> Decoder a -> Decoder b
(|:) = Decode.object2 (<|)


article : Decoder Article
article =
  succeed Article
    |: ("id" := string)
    |: ("url" := string)
    |: ("title" := string)
    |: ("summary" := oneOf [string, null ""])
    |: ("author" := string)
    |: ("published_on" := float)


articles : Decoder (List Article)
articles =
  list article


articlesIndex : Task Http.Error (List Article)
articlesIndex =
  request Get "articles?$sort=published_on%20DESC"
    |> fromJson articles
