module ArticleList where

import Effects exposing (Effects)
import Html exposing (Html, div, hr, text)
import Html.Attributes exposing (class, hidden)
import Http
import Task exposing (Task)

import Api
import Article


-- MODEL

type alias Model =
  { articles : List Article.Model
  , error : String
  , loading : Bool
  , page : Int
  , loadedAll : Bool
  }


init : (Model, Effects Action)
init =
  ( { articles = []
    , error = ""
    , loading = False
    , page = 1
    , loadedAll = False
    }
  , Effects.none
  )


-- UPDATE

type Action
  = NoOp
  | LoadNextPage
  | AppendArticles (Result Http.Error (List Article.Model))
  | Modify Article.Action


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp ->
      ( model, Effects.none )

    Modify action ->
      ( model, Effects.none )

    LoadNextPage ->
      if (model.loading && not model.loadedAll) then
        ( model, Effects.none )
      else
        let
          effect =
            Api.getArticles model.page
              |> Task.toResult
              |> Task.map AppendArticles
              |> Effects.task
        in
          ( { model | loading = True }
          , effect
          )

    AppendArticles result ->
      case result of
        Ok articles ->
          ( { model |
              articles = model.articles ++ articles
            , loading = False
            , page = model.page + 1
            }
          , Effects.none
          )

        Err err ->
          case err of
            Http.Timeout ->
              ( { model | error = toString err }, Effects.none )
            Http.NetworkError ->
              ( { model | error = toString err }, Effects.none )
            Http.UnexpectedPayload str ->
              ( { model |
                  error = "An unexpected error has occurred. Please report."
                }
              , Effects.none
              )
            Http.BadResponse int str ->
              if int == 400 then
                ( { model |
                    error = ""
                  , loading = False
                  , loadedAll = True
                  }
                , Effects.none
                )
              else
              ( { model | error = toString err }, Effects.none )


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ class "all" ]
    [ div
      [ class "container" ]
      (List.map (viewArticle address) model.articles)
    , div
      [ hidden (not model.loadedAll) ]
      [ hr [] [] ]
    ]


viewArticle : Signal.Address Action -> Article.Model -> Html
viewArticle address model =
  Article.view (Signal.forwardTo address Modify) model
