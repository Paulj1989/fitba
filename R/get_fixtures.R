#' Get past or remaining league fixtures
#'
#' Returns the past or remaining league fixtures for every team in the league,
#' with each fixture shown twice (once for the home team and once for the away
#' team), from a match results dataframe created using
#' `worldfootballR::fb_match_results()` or following the same structure.
#'
#' @param matches dataframe containing match results (created using
#' `worldfootballR::fb_match_results()` or following the same structure)
#' @param remaining get remaining fixtures (`TRUE`) or past fixtures (`FALSE`)
#' (default = `TRUE`)
#'
#' @return returns a dataframe with three columns - `team`, `home_or_away`,
#' `opponent` - with each fixture appearing twice, once for the home team and
#' once for the away team
#'
#' @importFrom rlang .data
#'
#' @export
#'
#' @examples
#' \dontrun{
#' results <-
#'   worldfootballR::fb_match_results(
#'     country = "ENG", gender = "M", season_end_year = 2024
#'     )
#'
#' get_fixtures(results, remaining = TRUE)
#' }

get_fixtures <-
  function(matches, remaining = TRUE) {

    if (isTRUE(remaining)) {
      matches |>
        dplyr::tibble() |>
        janitor::clean_names() |>
        dplyr::filter(is.na(.data$home_goals) | is.na(.data$away_goals)) |>
        dplyr::mutate(
          team = .data$home,
          opponent = .data$away,
          home_or_away = "Home"
        ) |>
        dplyr::bind_rows(
          matches |>
            janitor::clean_names() |>
            dplyr::filter(is.na(.data$home_goals) | is.na(.data$away_goals)) |>
            dplyr::mutate(
              team = .data$away,
              opponent = .data$home,
              home_or_away = "Away"
            )
        ) |>
        dplyr::select(.data$team, .data$home_or_away, .data$opponent)

    } else if (isFALSE(remaining)) {

      matches |>
        dplyr::tibble() |>
        janitor::clean_names() |>
        dplyr::filter(!is.na(.data$home_goals) | !is.na(.data$away_goals)) |>
        dplyr::mutate(
          team = .data$home,
          opponent = .data$away,
          home_or_away = "Home"
        ) |>
        dplyr::bind_rows(
          matches |>
            dplyr::filter(!is.na(.data$home_goals) | !is.na(.data$away_goals)) |>
            dplyr::mutate(
              team = .data$away,
              opponent = .data$home,
              home_or_away = "Away"
            )
        ) |>
        dplyr::select(.data$team, .data$home_or_away, .data$opponent)

    } else {
      stop("remaining must equal TRUE or FALSE")
    }

  }
