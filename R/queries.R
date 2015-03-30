#' Возвращает строку запроса, созданную из переданных аргументов (плохо, криво, но кое-как работает ^_^)
#'
#' @param method_name Имя метода
#' @... Список параметров
queryBuilder <- function(method_name, ...) {
  query <- paste("https://api.vk.com/method/", method_name, "?", sep="")
  arguments <- sapply(substitute(list(...))[-1], deparse)
  arg_names <- names(arguments)
  for (arg_pos in seq(length(arguments))) {
    if (arg_names[arg_pos] != "") {
      if (is.character(arguments[arg_pos])) {
        #arg_value <- gsub("\"", "", arguments[arg_pos])
        arg_value <- list(...)[arg_names[arg_pos]]
      } else {
        # В этом моменте я перестал понимать, что пишу, видимо все условие проверки лишнее
        # Короче говоря, ветки else быть вовсе не должно
        arg_value <- arguments[arg_pos]
      }
      query <- paste(query, ifelse(arg_value != "", paste("&", arg_names[arg_pos], "=", arg_value, sep=""), ""), sep="")
    }
  }
  query <- paste(query, '&access_token=', access_token, sep="")
  query
}


#' Execute для увеличения числа запросов
#' @export
execute <- function(code) {
  query <- paste("https://api.vk.com/method/execute?code=", code, "&access_token=", access_token, sep="")
  #response <- fromJSON(URLencode(query))
  response <- fromJSON(rawToChar(GET(URLencode(query))$content))
  response$response
}