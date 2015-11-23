import Effects exposing (Never)
import ArticleList exposing (init, update, view)
import StartApp
import Task exposing (Task)


app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = [ Signal.map (\_ -> ArticleList.LoadNextPage) loadNextPage]
    }


main = app.html


port tasks : Signal (Task Never ())
port tasks =
  app.tasks


port loadNextPage : Signal String
