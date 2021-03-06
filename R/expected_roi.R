#' Expected Return on Investment
#'
#' This function calculates the expected return on investment for a given bet.
#'
#' @param payout The dollar amount won if the bet pays out (500)
#' @param risk The dollar amount wagered (550)
#' @param win_prob The probability that the bet wins (0.54)
#'
#' @return Expected Return on Investment
#' @export
#'
#' @examples expected_roi(100, 110, 0.55)
#' @examples expected_roi(175, 100, 0.35)
expected_roi <- function(payout, risk, win_prob){
  exp_roi <- ((payout * win_prob) - ((1 - win_prob) * risk)) / risk
  return(exp_roi)
}
