#' CITES Code Values
#'
#' This function returns a data frame with descriptions of all the code values
#' used in [cites_data()].  This is useful for lookup
#' as well as merging with the data for more descriptive summaries.
#'
#' These values are drawn from
#' ["A guide to using the CITES Trade Database"](https://github.com/ecohealthalliance/cites/tree/master/inst/extdata),
#' from the CITES websites.
#'
#' \if{html}{
#'   \Sexpr[echo=FALSE, results=rd, stage=build]{
#'   in_pkgdown <- any(grepl("as_html.tag_Sexpr", sapply(sys.calls(), function(a) paste(deparse(a), collapse = "\n"))))
#'     if(in_pkgdown) {
#'       mytext <- c('In RStudio, this help file includes a searchable table of values.')
#'     } else {
#'     tmp <- tempfile(fileext=".html")
#'       htmlwidgets::saveWidget(DT::datatable(cites::cites_codes(), rownames = FALSE, width=700), tmp)
#'       mytext <- paste('Below is a searchable table of the CITES codes.',
#'       '\\\out{<div style="width:100\%">',
#'          paste(stringi::stri_subset_regex(readLines(tmp), "^</?(!DOCTYPE|meta|body|html)",negate=TRUE), collapse="\n"),
#'       '</div>}\n',
#'       sep="\n")
#'     }
#'     mytext
#'   }
#' }
#'
#' \if{text,latex}{The HTML version of this help file includes a searchable table of the CITES codes.}
#'
#' @return A tibble with fields and descriptions
#' @importFrom DT datatable
#' @importFrom htmlwidgets saveWidget
#' @importFrom stringi stri_subset_regex
#' @aliases codes
#' @seealso [cites_metadata()] [cites_data()]
#' @export
cites_codes <- function() {
  cites_codes_
}

#' CITES Field Descriptions
#'
#' This function returns a data frame field descriptions for [cites_data()].
#'
#' This information is taken from
#' ["A guide to using the CITES Trade Database"](https://github.com/ecohealthalliance/cites/tree/master/inst/extdata),
#' from the CITES websites.
#'
#' \if{html}{
#'   \Sexpr[echo=FALSE, results=rd, stage=build]{
#'   in_pkgdown <- any(grepl("as_html.tag_Sexpr", sapply(sys.calls(), function(a) paste(deparse(a), collapse = "\n"))))
#'     if(in_pkgdown) {
#'       mytext <- cites:::tabular(cites::cites_metadata())
#'     } else {
#'     tmp <- tempfile(fileext=".html")
#'       htmlwidgets::saveWidget(DT::datatable(cites::cites_metadata(), rownames = FALSE, width=700), tmp)
#'       mytext <- paste('Below is a searchable version of the CITES field descriptions',
#'       '\\\out{<div style="width:100\%">',
#'          paste(stringi::stri_subset_regex(readLines(tmp), "^</?(!DOCTYPE|meta|body|html)",negate=TRUE), collapse="\n"),
#'       '</div>}',
#'       sep="\n")
#'     }
#'     mytext
#'   }
#' }
#'
#' \if{text,latex}{ \Sexpr[echo=FALSE, results=rd, stage=build]{cites:::tabular(cites::cites_metadata())}}
#'
#' @return A tibble with field, code, and code description
#' @importFrom DT datatable
#' @importFrom htmlwidgets saveWidget
#' @importFrom stringi stri_subset_regex
#' @aliases metadata
#' @seealso [cites_codes()] [cites_data()] [cites_parties()]
#' @export
cites_metadata <- function() {
  cites_metadata_
}



#' Parties to the CITES treaty.
#'
#' This function returns a data frame witha list of countries party to CITES
#' and their date of joining the treaty.
#'
#' \if{html}{
#'   \Sexpr[echo=FALSE, results=rd, stage=build]{
#'   in_pkgdown <- any(grepl("as_html.tag_Sexpr", sapply(sys.calls(), function(a) paste(deparse(a), collapse = "\n"))))
#'     if(in_pkgdown) {
#'       mytext <- ""
#'     } else {
#'     tmp <- tempfile(fileext=".html")
#'       htmlwidgets::saveWidget(DT::datatable(cites::cites_parties(), rownames = FALSE, width=700), tmp)
#'       mytext <- paste('Below is a searchable table of CITES parties.',
#'       '\\\out{<div style="width:100\%">',
#'          paste(stringi::stri_subset_regex(readLines(tmp), "^</?(!DOCTYPE|meta|body|html)",negate=TRUE), collapse="\n"),
#'       '</div>}',
#'       sep="\n")
#'     }
#'     mytext
#'   }
#' }
#'
#' \if{text,latex}{ The HTML version of this help file includes a searchable table of the CITES parties }
#'
#' @return A tibble
#' @importFrom DT datatable
#' @importFrom htmlwidgets saveWidget
#' @importFrom stringi stri_subset_regex
#' @aliases parties
#' @seealso [cites_codes()] [cites_metadata()]
#' @export
cites_parties <- function() {
  cites_parties_
}

# Modified from https://cran.r-project.org/web/packages/roxygen2/vignettes/formatting.html#tables

tabular <- function(df, col_names = TRUE, ...) {
  stopifnot(is.data.frame(df))

  align <- function(x) if (is.numeric(x)) "r" else "l"
  col_align <- vapply(df, align, character(1))

  cols <- lapply(df, format, ...)
  contents <- do.call(
    "paste",
    c(cols, list(sep = " \\tab ", collapse = "\\cr\n  "))
  )

  if (col_names) {
    header <- paste0("\\bold{", colnames(df), "}", collapse = " \\tab")
    contents <- paste0(header, "\\cr\n  ", contents)
  }

  paste(
    "\\tabular{", paste(col_align, collapse = ""), "}{\n  ",
    contents, "\n}\n", sep = ""
  )
}
