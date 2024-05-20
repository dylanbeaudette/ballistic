

w <- runif(n = 10, min = 0, max = 15)

x <- lapply(w, function(i) {
  .b <- bsim(windspeed = i, windangle = 45)
  .b$w <- i
  .b
})

x <- do.call('rbind', x)
x


xyplot(windage ~ range, data = x, type = 'p', las = 1, par.settings = tactile.theme(), scales = list(alternating = 1), as.table = TRUE)

xyplot(path ~ range, data = x, type = 'p', las = 1, par.settings = tactile.theme(), scales = list(alternating = 1), as.table = TRUE)


xyplot(path ~ windage, data = x, type = 'p', las = 1, par.settings = tactile.theme(), scales = list(alternating = 1), as.table = TRUE, subset = round(range) == 600)

