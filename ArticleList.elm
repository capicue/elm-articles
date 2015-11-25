module ArticleList where

import Effects exposing (Effects)
import Html exposing (Html, div, hr, text)
import Html.Attributes exposing (class, hidden)
import Http
import String
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
  let
    firstPage = 1
  in
    ( { articles = []
      , error = ""
      , loading = False
      , page = firstPage
      , loadedAll = False
      }
    , getPage firstPage
    )


-- UPDATE

type Action
  = NoOp
  | LoadNextPage
  | AppendArticles (Result Http.Error (List Api.RawArticle))
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
        ( model, getPage model.page )

    AppendArticles result ->
      case result of
        Ok articles ->
          ( { model |
              articles = model.articles ++ (List.map Article.init articles)
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


-- EFFECTS

getPage : Int -> Effects Action
getPage pageNumber =
  Api.getArticles pageNumber
    |> Task.toResult
    |> Task.map AppendArticles
    |> Effects.task
