module Models where


import Date exposing (Date)


type alias Article =
  { id : String
  , url : String
  , title : String
  , picture_url : String
  , author : String
  , published_on : Float
  }
