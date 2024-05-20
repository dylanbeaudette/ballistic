#include <R.h>
#include <Rinternals.h>
#include <stdio.h>
#include "ballistics/ballistics.h"

// TODO:
// * how do I use enum types?
// * manually specifying other drag functions seems to have no effect (bug?)
// * add attribution
// * add license

SEXP bsim_C(SEXP s, SEXP bc, SEXP df, SEXP v, SEXP sh, SEXP angle, SEXP zero, SEXP windspeed, SEXP windangle) {

  int n = length(s);

  // ideas: http://adv-r.had.co.nz/C-interface.html#c-vectors

  SEXP range_ = PROTECT(allocVector(REALSXP, n));
  SEXP path_ = PROTECT(allocVector(REALSXP, n));
  SEXP windage_ = PROTECT(allocVector(REALSXP, n));
  SEXP time_ = PROTECT(allocVector(REALSXP, n));
  SEXP velocity_ = PROTECT(allocVector(REALSXP, n));

  SEXP res = PROTECT(allocVector(VECSXP, 5));
  SET_VECTOR_ELT(res, 0, range_);
  SET_VECTOR_ELT(res, 1, path_);
  SET_VECTOR_ELT(res, 2, windage_);
  SET_VECTOR_ELT(res, 3, time_);
  SET_VECTOR_ELT(res, 4, velocity_);


  // debugging:

  // check input from R

  // drag_function interpreted from integer: OK
  // Rprintf("%i\n", asInteger(df));

  //
  int k = 0;
  Ballistics* solution;

  // useful starting values
  /*
   double bc=0.5; // The ballistic coefficient for the projectile.
   double v=1200; // Intial velocity, in ft/s
   double sh=1.6; // The Sight height over bore, in inches.
   double angle=0; // The shooting angle (uphill / downhill), in degrees.
   double zero=100; // The zero range of the rifle, in yards.
   double windspeed=0; // The wind speed in miles per hour.
   double windangle=0; // The wind angle (0=headwind, 90=right to left, 180=tailwind, 270/-90=left to right)
   */


  // If we wish to use the weather correction features, we need to
  // Correct the BC for any weather conditions.  If we want standard conditions,
  // then we can just leave this commented out.

  // bc = atmosphere_correction(bc, 0, 29.59, 100, .7);


  // First find the angle of the bore relative to the sighting system.
  // We call this the "zero angle", since it is the angle required to
  // achieve a zero at a particular yardage.  This value isn't very useful
  // to us, but is required for making a full ballistic solution.
  // It is left here to allow for zero-ing at altitudes (bc) different from the
  // final solution, or to allow for zero's other than 0" (ex: 3" high at 100 yds)
  double zeroangle = zero_angle(asInteger(df), asReal(bc), asReal(v), 1.6, asReal(zero), 0);

  // Now we have everything needed to generate a full solution.
  // So we do.  The solution is stored in the pointer "sln" passed as the last argument.
  // k has the number of yards the solution is valid for, also the number of rows in the solution.
  k = Ballistics_solve(
    &solution,
    asInteger(df),
    asReal(bc),
    asReal(v),
    asReal(sh),
    asReal(angle),
    zeroangle,
    asReal(windspeed),
    asReal(windangle)
  );


  //
  for (int i = 0; i < n; i++) {
    REAL(range_)[i] = Ballistics_get_range(solution, REAL(s)[i]);
    REAL(path_)[i] = Ballistics_get_path(solution, REAL(s)[i]);
    REAL(windage_)[i] = Ballistics_get_windage(solution, REAL(s)[i]);

    REAL(time_)[i] = Ballistics_get_time(solution, REAL(s)[i]);
    REAL(velocity_)[i] = Ballistics_get_v_fps(solution, REAL(s)[i]);
  }


  // clean-up local memory
  Ballistics_free(solution);

  // R garbage collection OK to proceed
  UNPROTECT(6);

  return res;
}

