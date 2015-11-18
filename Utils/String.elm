module Utils.String where


import String


truncate : Int -> String -> String
truncate length text =
  if String.length text < length then
    text
  else
    text
      |> String.slice 0 (length - 3)
      |> (\str -> str ++ "...")
