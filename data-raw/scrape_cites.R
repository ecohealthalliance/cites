# !/usr/bin/env Rscript

stop("Don't run this whole script, go through step by step as needed.")

library(httr)
library(glue)
library(methods)
library(tidyverse)
library(fst)
library(janitor)
library(stringi)
library(aws.s3)

years <- 1975:2017

for (yr in years) {
  cites_url <- glue("https://trade.cites.org/cites_trade/exports/download?filters[time_range_start]={yr}&filters[time_range_end]={yr}&filters[exporters_ids][]=&filters[importers_ids][]=all_imp&filters[sources_ids][]=all_sou&filters[purposes_ids][]=all_pur&filters[terms_ids][]=all_ter&filters[taxon_concepts_ids][]=&filters[reset]=&filters[selection_taxon]=taxonomic_cascade&web_disabled=&filters[report_type]=comptab&filters[csv_separator]=comma")
  cites_file <- glue("data-raw/cites_{yr}.csv")
  if (!file.exists(cites_file) || file.info(cites_file)$size < 1) {
    cat(cites_file, "\n")
    RETRY("GET", cites_url, write_disk(path = cites_file, overwrite = TRUE))
  }
}


csv_files <- list.files("data-raw", pattern = "csv", full.names = TRUE) %>%
  keep(~file.info(.)$size > 1)
sizes <- csv_files %>%
  map_dfr(~data_frame(
    year = stri_extract_first_regex(., "\\d{4}"),
    MB = file.info(.)$size / 1e6
  ))

ggplot(sizes, aes(x = year, y = MB)) +
  geom_point()

cites_tab <- map_dfr(csv_files, read_csv, col_types = "icccccccccddcccc") %>%
  clean_names()

write_fst(cites_tab, "data-raw/cites.fst", compress = 100)
cites_tab %>%
  count(year) %>%
  ggplot(aes(x = year, y = n)) + geom_point()

aws.signature::use_credentials()
aws_success <- map_lgl(csv_files, ~put_object(
  file = ., object = basename(.),
  bucket = "cites-trade-data"
))

#h <- here::here
#cites:::cites_release(description = "Initial test release", filename = h("data-raw", "cites.fst"),
#                                            target = "master", ignore_dirty = TRUE)
