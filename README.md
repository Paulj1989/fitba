
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
#> Using GitHub PAT from the git credential store.
#> Downloading GitHub repo Paulj1989/fitba@HEAD
#> Warning in untar2(tarfile, files, list, exdir, restore_times): skipping pax
#> global extended headers

#> Warning in untar2(tarfile, files, list, exdir, restore_times): skipping pax
#> global extended headers
#> 
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#>          checking for file 'C:\Users\paul.johnson\AppData\Local\Temp\Rtmpgzqu1M\remotes54c41b3539ab\Paulj1989-fitba-23f153d/DESCRIPTION' ...     checking for file 'C:\Users\paul.johnson\AppData\Local\Temp\Rtmpgzqu1M\remotes54c41b3539ab\Paulj1989-fitba-23f153d/DESCRIPTION' ...   ✔  checking for file 'C:\Users\paul.johnson\AppData\Local\Temp\Rtmpgzqu1M\remotes54c41b3539ab\Paulj1989-fitba-23f153d/DESCRIPTION' (489ms)
#>       ─  preparing 'fitba':
#>    checking DESCRIPTION meta-information ...     checking DESCRIPTION meta-information ...   ✔  checking DESCRIPTION meta-information
#>       ─  checking for LF line-endings in source and make files and shell scripts
#>       ─  checking for empty or unneeded directories
#>       ─  building 'fitba_0.0.0.9000.tar.gz'
#>      
#> 
#> Installing package into 'C:/Users/paul.johnson/AppData/Local/Temp/RtmpgpeZyJ/temp_libpath260034a26ded'
#> (as 'lib' is unspecified)
```

## Usage

``` r
team_ratings <-
  worldfootballR::fb_season_team_stats(
    country = "ENG", gender = "M", season_end_year = 2024,
    stat_type = "standard", tier = "1st"
    ) |>
  fitba::calculate_team_ratings()
```
