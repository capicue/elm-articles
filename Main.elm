import Graphics.Element exposing (..)
import ArticleList
import Api
import Task exposing (Task)
import Http


port foo : Task Http.RawError Http.Response
port foo =
  Api.request Api.Get "articles"


main : Element
main =
  show "Getting Started"
