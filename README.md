
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![CircleCI](https://circleci.com/gh/ecohealthalliance/cites.svg?style=shield)](https://circleci.com/gh/ecohealthalliance/cites)

# cites

Authors: *Noam Ross*

The **cites** package provides a complete extract of the [CITES wildlife
trade database](https://trade.cites.org/).

## Installation

Install the **cites** package with this command:

``` r
source("https://install-github.me/ecohealthalliance/cites")
```

## Usage

The main function in **cites** is `cites_data()`. This returns the main
CITES database as a **dplyr** tibble.

**cites** makes use of
[**datastorr**](https://github.com/ropenscilabs/datastorr) to manage
data download. The first time you run `cites_data()` the package will
download the most recent version of the database (~32MB). Subsequent
calls will load the database from storage on your computer.

The CITES database is stored as an efficiently compressed [`.fst`
file](https://github.com/fstpackage/fst), and loading it loads it a a
[remote dplyr source](https://github.com/krlmlr/fstplyr). This means
that it does not load fully into memory, but can be filtered and
manipulated on-disk. If you wish to manipulate it as a data frame,
simply call `dplyr::collect()` to load it fully into memory, like so:

``` r
all_cites <- cites_data() %>% 
  collect()
```

Note that the full database will be approximately 270 MB in memory.

`cites_codes()` returns a data frame with descriptions of the codes in
the various columns of `cites_data()`. This is useful for lookup or
joining with the main data for more descriptive outputs. The
`?cites_code` help file also has a searchable table of these codes.
`cites_metadata()` provides field descriptions and `cites_parties()`
lists the CITES party countries and the date they joined the treaty.

See the [developer
README](https://github.com/ecohealthalliance/cites/tree/master/data-raw/README.md)
for more on the data-cleaning process.

## About

Please give us feedback or ask questions by filing
[issues](https://github.com/ecohealthalliance/cites/issues)

**cites** is developed at [EcoHealth
Alliance](https://github.com/ecohealthalliance). Please note that this
project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its
terms.

[![http://www.ecohealthalliance.org/](inst/figs/eha-footer.png)](http://www.ecohealthalliance.org/)
