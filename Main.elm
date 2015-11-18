import Date exposing (Date)
import Effects exposing (Effects, Never)
import Html exposing (Html, a, div, h2, p, text)
import Html.Attributes exposing (class, src)
import Http
import Maybe
import StartApp
import Task exposing (Task)


import Api
import Models exposing (Article)


-- MODEL

type alias Model =
  { articles : List Article
  , error : String
  }


initialModel : Model
initialModel =
  Model [] ""


-- UPDATE


type Action = ReplaceArticles (Result Http.Error (List Article))


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    ReplaceArticles result ->
      case result of
        Ok articles ->
          ( { model | articles <- articles }
          , Effects.none
          )

        Err err ->
          ( { model | error <- toString err }
          , Effects.none
          )


-- VIEW


view : Signal.Address Action -> Model -> Html
view address model =
  div []
    (List.map showArticle model.articles)


showArticle : Article -> Html
showArticle article =
  div
    [ class "article" ]
    [ div
      [ class "article-source" ]
      [ div
        [ class "article-date" ]
        [ showDate (Date.fromTime article.published_on) ]
      , div
        [ class "article-author" ]
        [ text ("by " ++ article.author) ]
      ]
    , div
      [ class "article-detail" ]
      [ h2
        [ ]
        [ a
          [ src article.url ]
          [ text article.title ]
        ]
        , div
        [ class "summary" ]
        [ text "placeholder" ]
      ]
    ]


showDate : Date -> Html
showDate date =
  let
      year = toString (Date.year date)
      month = toString (Date.month date)
      day = toString (Date.day date)
  in
      text (month ++ " " ++ day ++ ", " ++ year)


{-|
{ html : Signal Html.Html
, model : Signal a
, tasks : Signal (Task Effects.Never ())
}
-}
app =
  StartApp.start
    { init = (initialModel, populateArticles)
    , update = update
    , view = view
    , inputs = []
    }


main =
  app.html


port tasks : Signal (Task Never ())
port tasks =
  app.tasks


populateArticles : Effects Action
populateArticles =
  Api.articlesIndex
    |> Task.toResult
    |> Task.map ReplaceArticles
    |> Effects.task
