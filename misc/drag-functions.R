library(lattice)
library(tactile)

## TODO: doesn't seem to


df <- c('G1', 'G2', 'G3', 'G4', 'G5', 'G6', 'G7', 'G8')

x <- lapply(df, function(i) {
  .b <- bsim(df = i)
  .b$drag.function <- i
  .b
})

x <- do.call('rbind', x)

xyplot(path ~ range | drag.function, data = x, type = 'l', las = 1, par.settings = tactile.theme(), scales = list(alternating = 1), as.table = TRUE)


bsim()

plot(windage ~ range, data = x, type = 'l', las = 1)

plot(velocity ~ range, data = x, type = 'l', las = 1)

