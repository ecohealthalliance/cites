library(tidyverse)
library(tabulizer)
library(stringi)
library(janitor)
# devtools::load_all()
metadata_1 <- tabulizer::extract_areas("data-raw/en-CITES_Trade_Database_Guide.pdf", pages = 7)
metadata_2 <- tabulizer::extract_areas("data-raw/en-CITES_Trade_Database_Guide.pdf", pages = 8)
metadata_raw <- rbind(metadata_1[[1]], metadata_2[[1]])

metadata_all <- metadata_raw %>%
  as_data_frame() %>%
  rename(variable = V1, description = V2) %>%
  mutate(variable = na_if(variable, "")) %>%
  fill(variable) %>%
  group_by(variable) %>%
  summarize(description = paste(description, collapse = " "))

cites_head <- head(read_csv("data-raw/cites_1975.csv")) %>% clean_names()

cites_metadata_ <- data_frame(
  variable = names(cites_head),
  description = c(
    metadata_all$description[c(16, 6, 15)],
    NA, NA, NA, NA,
    metadata_all$description[c(13, 7, 14, 9, 1, 11, 12, 8, 10)]
  )
) %>%
  fill(description)

terms_raw <- tabulizer::extract_areas("data-raw/en-CITES_Trade_Database_Guide.pdf", pages = 11)[[1]]
terms_raw2 <- terms_raw
terms_raw2[6, 5] <- paste(terms_raw2[6, 5], terms_raw2[7, 5])
terms_raw2[7, 5] <- ""
terms_raw2 <- cbind(terms_raw2[, 1:4], stri_split_regex(terms_raw2[, 5], "\\s+", n = 2, simplify = TRUE))

terms <- data_frame(
  field = "term",
  code = c(terms_raw2[1:36, c(1, 3, 5)]),
  description = c(terms_raw2[1:36, c(2, 4, 6)])
) %>%
  filter(code != "", description != "")

units_raw <- tabulizer::extract_areas("data-raw/en-CITES_Trade_Database_Guide.pdf", pages = 11)[[1]]
units <- data_frame(
  field = "unit",
  code = c(units_raw[2:14, c(1, 3, 5)]),
  description = c(units_raw[2:14, c(2, 4, 6)])
) %>%
  filter(code != "", description != "")

purpose_raw <- tabulizer::extract_areas("data-raw/en-CITES_Trade_Database_Guide.pdf", pages = 12)[[1]]
purpose <- purpose_raw %>%
  as_data_frame() %>%
  rename(code = V1, description = V2) %>%
  mutate(field = "purpose") %>%
  select(3, 1, 2)

source_raw <- tabulizer::extract_areas("data-raw/en-CITES_Trade_Database_Guide.pdf", pages = 12)[[1]]
source <- source_raw %>%
  as_data_frame() %>%
  rename(code = V1, description = V2) %>%
  mutate(code = na_if(code, "")) %>%
  fill(code) %>%
  group_by(code) %>%
  summarize(description = paste(description, collapse = " ")) %>%
  mutate(field = "source") %>%
  select(1, 3, 2)

country_raw <- tabulizer::extract_areas("data-raw/en-CITES_Trade_Database_Guide.pdf", pages = c(14, 15, 16))
country_raw2 <- do.call(rbind, country_raw)

country <- data_frame(
  field = "country",
  code = c(country_raw2[, c(1, 3)]),
  description = c(country_raw2[, c(2, 4)])
) %>%
  filter(code != "" | description != "") %>%
  mutate(code = na_if(code, "")) %>%
  fill(code) %>%
  group_by(field, code) %>%
  summarize(description = paste(description, collapse = " "))

parties_raw <- tabulizer::extract_areas("data-raw/en-CITES_Trade_Database_Guide.pdf", pages = c(17, 18))
parties_raw2 <- do.call(rbind, parties_raw)
cites_parties_ <- data_frame(
  name = c(parties_raw2[, c(1, 3)]),
  date = c(parties_raw2[, c(2, 4)])
) %>%
  filter(name != "" | date != "") %>%
  rownames_to_column() %>%
  mutate(rowname = if_else(date == "", NA_character_, rowname)) %>%
  fill(rowname, .direction = "up") %>%
  group_by(rowname) %>%
  summarize(name = paste(name, collapse = " "), date = date[date != ""]) %>%
  select(-rowname) %>%
  extract(name, into = c("country", "code"), regex = "^([^\\(]+)\\s\\(([^\\)]+)\\)") %>%
  mutate(date = lubridate::dmy(date)) %>%
  arrange(date)


cites_codes_ <- bind_rows(terms, units, purpose, source)
cites_parties_

devtools::use_data(cites_codes_, cites_metadata_, cites_parties_, internal = TRUE, overwrite = TRUE)
