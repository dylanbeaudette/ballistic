

#'
#'
#'
#' @title bsim
#' @description A short description
#'
#'
#' @param s a
#' @param bc a
#' @param df drag function: G1, G2, G3, G4, G5, G6, G7, or G8
#' @param v a
#' @param sh a
#' @param angle a
#' @param zero a
#' @param windspeed a
#' @param windangle a
#'
#' @useDynLib ballistic bsim_C
#' @export
#'
bsim <- function(s = seq(0, 1000, by = 100), bc = 0.5, df = c('G1', 'G2', 'G3', 'G4', 'G5', 'G6', 'G7', 'G8'), v = 1200, sh = 1.6, angle = 0, zero = 100, windspeed = 0, windangle = 0) {

  # sanity checks
  df <- match.arg(df)

  # convert drag function to an integer
  df <- factor(df, levels = c('G1', 'G2', 'G3', 'G4', 'G5', 'G6', 'G7', 'G8'))
  df <- as.integer(df)

  # note: drag_function is treated as an enum in C,
  # but it is really just an integer in the range 1 -> 8

  # returns a list
  .res <- .Call('bsim_C',
               as.double(s),
               as.double(bc),
               as.integer(df),
               as.double(v),
               as.double(sh),
               as.double(angle),
               as.double(zero),
               as.double(windspeed),
               as.double(windangle), PACKAGE = 'ballistic'
  )

  r <- data.frame(
    range = .res[[1]],
    path = .res[[2]],
    windage = .res[[3]],
    time = .res[[4]],
    velocity = .res[[5]]
  )

  # truncate results to a reasonable level of precision
  r$range <- round(r$range, 4)
  r$path <- round(r$path, 4)
  r$windage <- round(r$windage, 4)
  r$velocity <- round(r$velocity, 4)




  return(r)
}

