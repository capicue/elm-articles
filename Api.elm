module Api where


import Date
import Http exposing (fromJson)
import Effects exposing (Effects)
import String
import Task exposing (Task)
import Json.Decode as Decode exposing (Decoder, (:=), float, int, list, null, oneOf, string, succeed)


mainUrl : String
mainUrl =
  "https://elm-articles.apispark.net/v1/"


authorization : String
authorization =
  "Basic ZTIxOTZlYmMtMjc4YS00MjhlLTkwYmQtMTNjMzg0YTU1ZWQxOmY0YTE5NWU0LWI3YTctNDBjOC1iYjZhLTUzNWNlZjk1NTk1NA=="


type Verb = Get | Post | Patch | Delete


type alias Path = String


type alias RawArticle =
  { id : String
  , url : String
  , title : String
  , summary : String
  , author : String
  , published_on : Float
  }


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


article : Decoder RawArticle
article =
  succeed RawArticle
    |: ("id" := string)
    |: ("url" := string)
    |: ("title" := string)
    |: ("summary" := oneOf [string, null ""])
    |: ("author" := string)
    |: ("published_on" := float)


articles : Decoder (List RawArticle)
articles =
  list article


getArticles : Int -> Task Http.Error (List RawArticle)
getArticles page =
  request Get ("articles?$sort=published_on%20DESC&$page=" ++ (toString page))
    |> fromJson articles
