
<!-- README.md is generated from README.Rmd. Please edit that file -->

# fitba

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/Paulj1989/fitba/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Paulj1989/fitba/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Overview

> Fitba – n. Football; The Beautiful Game

fitba (**F**unctions **I**n**T**ended for foot**B**all **A**nalytics) is
a package for carrying out simple football/soccer/fitba analytics in R.
Right now it only includes a small handful of functions for tasks like
calculating simple team ratings and strength of schedule, but there’s
plenty of room for growth!

So far all functions rely on the use of
[**worldfootballR**](https://jaseziv.github.io/worldfootballR/) for
getting the [FBref](https://fbref.com/) data that is required for each
process. The intention isn’t that the package should strictly be an
extension of **worldfootballR**, but it is an excellent package that
makes it much easier to extract football data from sites like
[FBref](https://fbref.com/) &
[Transfermarkt](https://www.transfermarkt.com/), so it makes sense to
work with it.

## Installation

You can install the development version of fitba from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("Paulj1989/fitba")
```

## Usage

You can calculate team ratings using the `calculate_team_ratings()`
function.

``` r
team_ratings <-
  worldfootballR::fb_season_team_stats(
    country = "ENG", gender = "M", season_end_year = 2024,
    stat_type = "standard", tier = "1st"
    ) |>
  fitba::calculate_team_ratings()
```

Strength of Schedule (SOS) can be calculated by first bringing together
the `get_fixtures()` and `calculate_team_ratings()` functions, with data
from **worldfootballR**, before using `calculate_sos()` to compute SOS
values for all teams.

``` r
remaining_schedule <-
  worldfootballR::fb_match_results(
    country = "ENG", gender = "M", season_end_year = 2024
    ) |>
  fitba::get_fixtures(remaining = TRUE)

team_ratings <-
  worldfootballR::fb_season_team_stats(
    country = "ENG", gender = "M", season_end_year = 2024,
    stat_type = "standard", tier = "1st"
    ) |>
  fitba::calculate_team_ratings()

fitba::calculate_sos(
  ratings = team_ratings,
  schedule = remaining_schedule
  )
```
