import StartApp
import Effects exposing (Effects, Never)
import Task exposing (Task)
import Maybe
import Html exposing (Html, div, text)
import Http


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
    [ text (toString model) ]


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
