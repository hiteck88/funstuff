# very simple odds computation



odds <- function(game){
  
  
  host.win <- game[2]/(game[1] + game[2])
  tie <- game[4]/(game[3] + game[4])
  guest.win <- game[6]/(game[5] + game[6])

  
  total <- host.win + tie + guest.win
  if (host.win > 0.5 * total){
    result <- 2
  }else if(tie  > 0.5 * total){
    result <- 0 
  }else if(guest.win > 0.5 * total){
    result <- -2
  }else{
    outcome <- which.max(c(host.win, tie, guest.win))
    if (outcome == 1){
      result <- 1
    }else if (outcome == 2){
      result <- 0.5
    }else{
      result <- -1
    }
  }
  
  
  return (list('host.win' = host.win, 'tie' = tie, 'guest.win' = guest.win, 'result' = result))
  
}



denmark.australia <- c(21, 20, 23, 10, 13, 4)
odds(denmark.australia)

france.peru <- c(4, 7, 3, 1, 6, 1)
odds(france.peru)

argentina.croatia <- c(59, 50, 9, 4, 29, 10)
odds(argentina.croatia)

brazil.costarica <- c(11, 50, 11, 2, 16, 1)
odds(brazil.costarica)

nigeria.iceland <- c(19, 10, 21, 10, 17, 10)
odds(nigeria.iceland)

serbia.switzerland <- c(17, 10, 21, 10, 19, 10)
odds(serbia.switzerland)

belgium.tunisia <- c(8, 25, 9, 2, 17, 2)
odds(belgium.tunisia)

southkorea.mexico <- c(19, 4, 11, 4, 4, 6)
odds(southkorea.mexico)

german.sweden <- c(11, 25, 18, 5, 7, 1)
odds(german.sweden)

england.panama <- c(1, 6, 23, 4, 20, 1)
odds(england.panama)

japan.senenal <- c(5, 2, 9, 4, 5, 4)
odds(japan.senenal)

poland.columbia <- c(12, 5, 49, 20, 6, 5)
odds(poland.columbia)



