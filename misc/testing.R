
# https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/SHLIB

# compile shared library
# R CMD SHLIB -o libballistics.dll angle.c atmosphere.c ballistics.c pbr.c

# # very simple wrapper function
# R CMD SHLIB -o libballistics.dll angle.c atmosphere.c ballistics.c pbr.c wrapper.c
#
# # load shared library
# dyn.unload('src/libballistics.dll')
# dyn.load('src/libballistics.dll')
#
# ## TODO: adapt to the modern .Call() interface
#
# # minimal R wrapper
# f <- function(bc = 0.5, v = 1200, sh = 1.6, angle = 0, zero = 100, windspeed = 0, windangle = 0) {
#   .C('w',
#      as.double(bc),
#      as.double(v),
#      as.double(sh),
#      as.double(angle),
#      as.double(zero),
#      as.double(windspeed),
#      as.double(windangle)
#   )
# }
#
# x <- f()
#
#
# x <- f(bc = 0.5, windspeed = 50, windangle = 90)



# .Call() interface
R CMD SHLIB -o libballistics.dll angle.c atmosphere.c ballistics.c pbr.c bsim.c

# load shared library
dyn.unload('src/libballistics.dll')
dyn.load('src/libballistics.dll')

source('R/bsim.R')

options(scipen = 10)

bsim()

bsim(s = c(0, 10, 20))

bsim(windspeed = 10, windangle = -90)


bsim(windspeed = 100, windangle = 180)
bsim(windspeed = 100, windangle = 0)

x <- bsim(s = seq(0, 1000, by = 10), windspeed = 10, windangle = -90)

plot(path ~ range, data = x, type = 'l', las = 1)

plot(windage ~ range, data = x, type = 'l', las = 1)

plot(velocity ~ range, data = x, type = 'l', las = 1)


