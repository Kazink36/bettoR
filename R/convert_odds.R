#' Odds converter
#'
#' This function converts any odds or probability.
#'
#' @param odds Vector of lines for a given bet (-115, -105)
#' @param input Vector of lines for a given bet ("us", "dec", "frac", "prob")
#' @param output Vector of lines for a given bet ("all", "us", "dec", "frac", "prob")
#'
#' @return odds
#' @export
#'
#' @examples convert_odds(c(-110, -110))
#' @examples convert_odds(odds = c(1.1, 2.1, 13, 6.5, 1.909), input = "dec", output = "us")
#' @examples convert_odds(odds = c(1/10, 11/10, 12/1, 11/2, 10/11), input = "frac", output = "all")
convert_odds <- function(odds, input = "us", output = "all"){
  ## American Odds
  if (input == "us") {
    if (output == "all") {
      dec <- odds
      dec[] <- NA_real_
      dec[which(odds <= -100)] <- -100 / odds[which(odds <= -100)] + 1
      dec[which(odds >= 100)] <- odds[which(odds >= 100)] / 100 + 1

      frac <- dec - 1
      frac <- MASS::fractions(frac)

      new_odds <- data.frame(Decimal = round(dec, 4),
                             American = odds,
                             Fraction = as.character(frac),
                             `Implied Probability` = implied_prob(odds = odds, type = "us"))
    }
    if (output == "dec") {
      new_odds <- odds
      new_odds[] <- NA_real_
      new_odds[which(odds <= -100)] <- -100 / odds[which(odds <= -100)] + 1
      new_odds[which(odds >= 100)] <- odds[which(odds >= 100)] / 100 + 1
    }
    if (output == "frac") {
      new_odds <- odds
      new_odds[] <- NA_real_
      new_odds[which(odds <= -100)] <- -100 / odds[which(odds <= -100)]
      new_odds[which(odds >= 100)] <- odds[which(odds >= 100)] / 100
      new_odds <- MASS::fractions(new_odds)
    }
    if (output == "prob") {
      new_odds <- implied_prob(odds, type = "us")
    }
    if (output == "us") {
      new_odds <- odds
    }
  }

  ## Decimal Odds
  if (input == "dec") {
    if (output == "all") {
      dec <- odds
      frac <- odds - 1
      frac <- MASS::fractions(frac)

      us <- odds
      us[] <- NA_real_
      us[which(odds > 1)] <- -100 / (odds[which(odds > 1)] - 1)
      us[which(odds > 2)] <- 100 * (odds[which(odds > 2)] - 1)
      us <- round(us)

      new_odds <- data.frame(Decimal = round(odds, 4),
                             American = us,
                             Fraction = as.character(frac),
                             `Implied Probability` = implied_prob(odds, type = "dec"))
    }
    if (output == "dec") {
      new_odds <- odds
    }
    if (output == "frac") {
      odds <- odds - 1
      new_odds <- MASS::fractions(odds)
    }
    if (output == "prob") {
      new_odds <- implied_prob(odds, type = "dec")
    }
    if (output == "us") {
      new_odds <- odds
      new_odds[] <- NA_real_
      new_odds[which(odds > 1)] <- -100 / (odds[which(odds > 1)] - 1)
      new_odds[which(odds > 2)] <- 100 * (odds[which(odds > 2)] - 1)
      new_odds <- round(new_odds)
    }
  }
  ## Fractional Odds
  if (input == "frac") {
    if (output == "all") {
      dec <- odds + 1
      frac <- MASS::fractions(odds)

      us <- odds
      us[] <- NA_real_
      us[which(dec > 1)] <- -100 / (dec[which(dec > 1)] - 1)
      us[which(dec > 2)] <- 100 * (dec[which(dec > 2)] - 1)
      us <- round(us)

      new_odds <- data.frame(Decimal = round(dec, 4),
                             American = us,
                             Fraction = as.character(frac),
                             `Implied Probability` = implied_prob(odds = odds, type = "frac"))
    }
    if (output == "dec") {
      new_odds <- odds + 1
    }
    if (output == "frac") {
      new_odds <- MASS::fractions(odds)
    }
    if (output == "prob") {
      new_odds <- implied_prob(odds = odds, type = "frac")
    }
    if (output == "us") {
      odds <- odds + 1
      new_odds <- odds
      new_odds[] <- NA_real_
      new_odds[which(odds > 1)] <- -100 / (odds[which(odds > 1)] - 1)
      new_odds[which(odds > 2)] <- 100 * (odds[which(odds > 2)] - 1)
      new_odds <- round(new_odds)
    }
  }
  ## Probabilities
  if (input == "prob") {
    if (output == "all") {
      new_odds <- data.frame(Decimal = round(implied_odds(odds, type = "dec"), 4),
                             American = implied_odds(odds, type = "us"),
                             Fraction = as.character(implied_odds(odds, type = "frac")),
                             `Implied Probability` = odds)
    }
    if (output == "dec") {
      new_odds <- implied_odds(odds, type = "dec")
    }
    if (output == "frac") {
      new_odds <- implied_odds(odds, type = "frac")
    }
    if (output == "prob") {
      new_odds <- odds
    }
    if (output == "us") {
      new_odds <- implied_odds(odds, type = "us")
    }
  }
  return(new_odds)
}
