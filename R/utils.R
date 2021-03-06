#' Создание графа друзей
#' 
#' @param users_ids Список пользователей, по которым требуется построить граф друзей
#' @export
getNetwork <- function(users_ids='') {
  n <- length(users_ids)
  adjacency_matrix <- data.frame(matrix(data = rep(0, n*n), nrow = n, ncol = n), row.names = users_ids)
  colnames(adjacency_matrix) <- users_ids
  
  mutual_friends <- getMutual(target_uids = paste(users_ids, collapse=","))
  for (friend_id in 1:length(users_ids)) {
    friends <- mutual_friends$common_friends[[friend_id]]
    if (length(friends) > 0) {
      share_friends <- intersect(users_ids, friends)
      if (length(share_friends) > 0) {
        for (shared_user_id in 1:length(share_friends)) {
          #if (is.na(share_friends[shared_user_id])) break
          #if (is.null(share_friends[shared_user_id])) break
          adjacency_matrix[as.character(share_friends[shared_user_id]), as.character(users_ids[friend_id])] <- 1
        }
      }
    }
  }
  
  adjacency_matrix
}


#' Получить список друзей для пользователей, указанных в векторе ids
#' @param ids Вектор со списком пользователей, для которых требуется получить список друзей 
getFriendsBy25 <- function(ids) {
  code <- "var all_friends = {}; var request;"
  for (idx in 1:length(ids)) {
    code <- paste(code, "request=API.friends.get({\"user_id\":", ids[idx], "}); all_friends.user", ids[idx], "=request;", sep="")
  }
  code <- paste(code, "return all_friends;")
  response <- execute(code)
  names(response) <- ids
  response
}


# For more details see \url{http://stackoverflow.com/questions/6451152/how-to-catch-integer0}
# @param x Integer value
# @author Richie Cotton
# is.integer0 <- function(x) {
#   is.integer(x) && length(x) == 0L
# }


#' Создание графа друзей для произвольного списка пользователей
#' 
#' @param users_ids Произвольный список пользователей, по которым требуется построить граф друзей
#' @export
getArbitraryNetwork <- function(users_ids) {
  counter <- 0
  from <- 1
  to <- 25
  users_lists <- list()
  
  repeat {
    # Для пользователей из списка users_ids получаем список друзей
    # Обрабатываем по 25 человек за запрос
    ids <- na.omit(users_ids[from:to])
    users_lists <- append(users_lists, getFriendsBy25(ids))
    
    if (to >= length(users_ids)) break
    
    from <- to + 1
    to <- to + 25
    
    counter <- counter + 1
    if (counter %% 3)
      Sys.sleep(1.0)
  }
  
  # Создаем матрицу смежности
  n <- length(users_lists)
  adjacency_matrix <- data.frame(matrix(data = rep(0, n*n), nrow = n, ncol = n), row.names = users_ids)
  colnames(adjacency_matrix) <- users_ids
  
  # Расставляем связи
  for (user_id in 1:(length(users_ids)-1)) {
    for (current_user_id in (user_id + 1):length(users_ids)) {
      if (users_ids[user_id] %in% users_lists[[current_user_id]]) {
        adjacency_matrix[as.character(users_ids[user_id]), as.character(users_ids[current_user_id])] <- 1
        adjacency_matrix[as.character(users_ids[current_user_id]), as.character(users_ids[user_id])] <- 1
      }
    }
  }
  
  adjacency_matrix
}


#' Прогнозирование возраста указанного пользователя
#' 
#' @param user_id Идентификатор пользователя, для которого необходимо определить возраст
#' @export
age_predict <- function(user_id='') {
  friends <- getFriends(user_id=user_id, fields='bdate')$items
  friends$bdate <- as.Date.character(friends$bdate, format="%d.%M.%Y")
  friends <- friends[!is.na(friends$bdate), ]
  friends$year_of_birth <- as.numeric(format(friends$bdate, "%Y"))
  data.frame(uid = user_id, year_of_birth = median(friends$year_of_birth), 
             nfriends = length(friends$year_of_birth))
}