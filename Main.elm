import Graphics.Element exposing (..)
import ArticleList
import Api
import Task exposing (Task, andThen)
import Http
import Debug exposing (log)


port foo : Task Http.RawError String
port foo =
  Api.request Api.Get "articles"
    |> Task.map (\res -> log "response" (toString res))


main : Element
main =
  show "Getting Started"
