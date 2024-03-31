#' Calculate team ratings
#'
#' Calculate team ratings from non-penalty goal difference and non-penalty
#' expected goal difference.
#'
#' @param team_stats dataframe containing FB Ref standard team stats (created
#' using `worldfootballR::fb_season_team_stats()` or following the same structure)
#'
#' @return returns a dataframe with four columns - `team`, `npxgd`, `npgd`, `rating`
#'
#' @importFrom rlang .data
#'
#' @export
#'
#' @examples
#' \dontrun{
#' team_stats <-
#'   worldfootballR::fb_season_team_stats(
#'     country = "ENG", gender = "M", season_end_year = 2024,
#'     stat_type = "standard", tier = "1st"
#'     )
#'
#' calculate_team_ratings(team_stats)
#' }

calculate_team_ratings <-
  function(team_stats) {
    team_stats |>
      dplyr::tibble() |>
      janitor::clean_names(
        replace = c(
          "Squad" = "team",
          "_Expected" = "",
          "G_minus_PK" = "npg",
          "npxG" = "npxg"
        )
      ) |>
      dplyr::select(.data$team, .data$team_or_opponent, .data$npxg, .data$npg) |>
      dplyr::mutate(team = stringr::str_remove(.data$team, "vs ")) |>
      tidyr::pivot_wider(
        names_from = .data$team_or_opponent,
        values_from = c(.data$npg, .data$npxg),
        names_glue = "{team_or_opponent}_{.value}"
      ) |>
      dplyr::summarise(
        npxgd = .data$team_npxg - .data$opponent_npxg,
        npgd = .data$team_npg - .data$opponent_npg,
        rating = (.data$npxgd * 0.7) + (.data$npgd * 0.3),
        .by = .data$team
      )
  }
