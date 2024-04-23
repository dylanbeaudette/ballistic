
#' @useDynLib ballistic bsim

bsim <- function(s = seq(0, 1000, by = 100), bc = 0.5, v = 1200, sh = 1.6, angle = 0, zero = 100, windspeed = 0, windangle = 0) {

  # sanity checks

  # returns a list
  .res <- .Call('bsim',
               as.double(s),
               as.double(bc),
               as.double(v),
               as.double(sh),
               as.double(angle),
               as.double(zero),
               as.double(windspeed),
               as.double(windangle)
  )

  r <- data.frame(
    range = .res[[1]],
    path = .res[[2]],
    windage = .res[[3]],
    time = .res[[4]],
    velocity = .res[[5]]
  )

  return(r)
}

