module ArticleList where


-- MODEL


type alias Article =
  { id : String
  , url : String
  , title : String
  , picture_url : String
  , author : String
  , published_on : Date
  }


type alias Model =
  { articles : List Article }
