module Article where

import Date exposing (Date)
import Html exposing (Html, a, div, text)
import Html.Attributes exposing (class, href, target)

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
