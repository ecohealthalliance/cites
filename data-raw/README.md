# Data processing for **cites**

The scripts in this directory process the data for the CITES package.
`cites_codes.R` uses the **tabulizer** package to extract codes from
the [database guide](https://trade.cites.org/cites_trade_guidelines/en-CITES_Trade_Database_Guide.pdf) `cites_codes()`, `cites_metadata()`, `cites_parties()`. 

`scrape_cites.R` processes the larger CITES database.  It does do by
querying the CITES website repeatedly to get yearly-scale CSVs of the data.
For many years, the website GUI won't let you download files of these size
(those > 1 million records), but querying the export directly is fine, if slow.

The raw exported annual CITES files are kept on AWS S3 at <https://s3.console.aws.amazon.com/s3/buckets/cites-trade-data/> (public link: <https://s3.amazonaws.com/cites-trade-data/>).

Once the `.fst` file is generated, it can be attached to this package as a 
release using `datastorr::github_release_create`.  Please read the help file
for this function before doing so.  Also, before relase,
one should update the package version in `DESCRIPTION` and commit all changes to GitHub.

v0.1.0 of **cites** has the CITES data as extracted on 2018-03-06.
