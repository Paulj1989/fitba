#' Calculate team ratings
#'
#' Calculate team ratings from non-penalty goal difference per 90 and non-penalty
#' expected goal difference per 90.
#'
#' @param team_stats dataframe containing FBref standard team stats (created
#' using `worldfootballR::fb_season_team_stats()` or following the same structure)
#'
#' @return returns a dataframe with four columns - `team`, `npxgd90`, `npgd90`,
#' `rating`
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
          "npxG" = "npxg",
          "_Per_Minutes" = "90"
        )
      ) |>
      dplyr::select(.data$team, .data$team_or_opponent, .data$npxg90, .data$npg90) |>
      dplyr::mutate(team = stringr::str_remove(.data$team, "vs ")) |>
      tidyr::pivot_wider(
        names_from = .data$team_or_opponent,
        values_from = c(.data$npg90, .data$npxg90),
        names_glue = "{team_or_opponent}_{.value}"
      ) |>
      dplyr::summarise(
        npxgd90 = .data$team_npxg90 - .data$opponent_npxg90,
        npgd90 = .data$team_npg90 - .data$opponent_npg90,
        rating = (.data$npxgd90 * 0.7) + (.data$npgd90 * 0.3),
        .by = .data$team
      )
  }
