module Article where

import Date exposing (Date)
import Effects exposing (Effects)
import Html exposing (Html, a, div, text)
import Html.Attributes exposing (class, href, target)

import Api
import Utils.String
import Utils.Date


-- MODEL

type alias Model =
  { id : String
  , url : String
  , title : String
  , summary : String
  , author : String
  , publishedOn : Date
  }


init : Api.RawArticle -> Model
init raw =
  { id = raw.id
  , url = raw.url
  , title = raw.title
  , summary = raw.summary
  , author = raw.author
  , publishedOn = Date.fromTime raw.published_on
  }


-- UPDATE

type Action = NoOp


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ class "article row" ]
    [ div
      [ class "article-source four columns" ]
      [ div
        [ class "article-date" ]
        [ text (Utils.Date.showDate model.publishedOn) ]
      , div
        [ class "article-author" ]
        [ text ("by " ++ model.author) ]
      ]
    , div
      [ class "article-detail eight columns" ]
      [ div
        [ class "article-title" ]
        [ a
          [ href model.url
          , target "_blank"
          ]
          [ text model.title ]
        ]
        , div
        [ class "article-summary" ]
        [ text (Utils.String.truncate 500 model.summary) ]
      ]
    ]
