library(lattice)
library(tactile)


bsim()



df <- c('G1', 'G2', 'G3', 'G4', 'G5', 'G6', 'G7', 'G8')

x <- lapply(df, function(i) {
  .b <- bsim(df = i, windspeed = 10, windangle = 45)
  .b$drag.function <- i
  .b
})

x <- do.call('rbind', x)

xyplot(path ~ range | drag.function, data = x, type = 'l', las = 1, par.settings = tactile.theme(), scales = list(alternating = 1), as.table = TRUE)


xyplot(windage ~ range, groups = drag.function, data = x, type = 'l', las = 1, par.settings = tactile.theme(), scales = list(alternating = 1), as.table = TRUE)

xyplot(velocity ~ range, groups = drag.function, data = x, type = 'l', las = 1, par.settings = tactile.theme(), scales = list(alternating = 1), as.table = TRUE)


