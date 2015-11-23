module Utils.Date where


import Date exposing (Date)


showDate : Date -> String
showDate date =
  let
      year = toString (Date.year date)
      month = toString (Date.month date)
      day = toString (Date.day date)
  in
      month ++ " " ++ day ++ ", " ++ year

