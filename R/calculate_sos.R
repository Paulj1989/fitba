#' Calculate strength of schedule using team ratings and schedule created using
#' calculate_team_ratings() and get_fixtures()
#'
#' @param ratings dataframe containing team and rating
#' @param schedule dataframe containing team, opponent, and home_or_away
#'
#' @keywords strength of schedule
#'
#' @export
#'
#' @examples
#' remaining_schedule <-
#'   worldfootballR::fb_match_results(
#'     country = "ENG", gender = "M", season_end_year = 2024
#'     ) |>
#'   get_fixtures(remaining = TRUE)
#'
#' team_ratings <-
#'   worldfootballR::fb_season_team_stats(
#'     country = "ENG", gender = "M", season_end_year = 2024,
#'     stat_type = "standard", tier = "1st"
#'     ) |>
#'   calculate_team_ratings()
#'
#' calculate_sos(ratings = team_ratings, schedule = remaining_schedule)
#'
#' @importFrom rlang .data

calculate_sos <-
  function(ratings, schedule) {

    opp <-
      schedule |>
      dplyr::left_join(ratings, by = dplyr::join_by("opponent" == "team")) |>
      dplyr::mutate(
        rating =
          dplyr::if_else(.data$home_or_away == "Away", .data$rating + (abs(.data$rating) * 0.25), .data$rating)
      ) |>
      dplyr::summarise(opponent_rating = mean(.data$rating), .by = .data$team)

    opp_opp <-
      schedule |>
      dplyr::left_join(ratings) |>
      dplyr::mutate(
        rating =
          dplyr::if_else(.data$home_or_away == "Home", .data$rating + (abs(.data$rating) * 0.25), .data$rating)
      ) |>
      dplyr::summarise(rating = mean(.data$rating), .by = .data$opponent) |>
      dplyr::full_join(schedule) |>
      dplyr::summarise(opponent_opponent_rating = mean(.data$rating), .by = .data$team)

    schedule |>
      dplyr::distinct(.data$team) |>
      dplyr::left_join(opp, by = dplyr::join_by("team")) |>
      dplyr::left_join(opp_opp, by = dplyr::join_by("team")) |>
      dplyr::mutate(
        unstandardized = ((2 * .data$opponent_rating) + .data$opponent_opponent_rating) / 3,
        sos = as.vector(scale(.data$unstandardized))
      ) |>
      dplyr::select(.data$team, .data$sos)
  }
