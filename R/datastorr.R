#' Load the CITES database
#'
#' This function loads the CITES database as an out-of-memory **dplyr**
#' table.  It will download the latest database from the remote repo the first
#' time you use it or if you specify a version of the database not on your
#' computer.  Available versions can be found at
#' \url{https://github.com/ecohealthalliance/cites/releases}
#'
#' More information about the CITES database can be found
#' \url{https://trade.cites.org/cites_trade_guidelines/en-CITES_Trade_Database_Guide.pdf}
#'
#'
#' @param version Version number.  The default will load the most
#'   recent version on your computer or the most recent version known
#'   to the package if you have never downloaded the data before.
#'   With \code{cites_del}, specifying \code{version=NULL} will
#'   delete \emph{all} data sets.
#'
#' @param path Path to store the data at.  If not given,
#'   \code{datastorr} will use \code{rappdirs} to find the best place
#'   to put persistent application data on your system.  You can
#'   delete the persistent data at any time by running
#'   \code{cites_del(NULL)} (or \code{cites_del(NULL, path)} if you
#'   use a different path).
#'
#' @export
cites_data <- function(version=NULL, path=NULL) {
  datastorr::github_release_get(cites_info(path), version)
}

#' @export
#' @rdname cites_data
#'
#' @param local Logical indicating if local or github versions should
#'   be polled.  With any luck, \code{local=FALSE} is a superset of
#'   \code{local=TRUE}.  For \code{cites_version_current}, if
#'   \code{TRUE}, but there are no local versions, then we do check
#'   for the most recent github version.
#'
#' @importFrom datastorr github_release_versions
cites_versions <- function(local=TRUE, path=NULL) {
  datastorr::github_release_versions(cites_info(path), local)
}

#' @export
#' @rdname cites_data
cites_version_current <- function(local=TRUE, path=NULL) {
  datastorr::github_release_version_current(cites_info(path), local)
}

#' @export
#' @rdname cites_data
cites_del <- function(version, path=NULL) {
  datastorr::github_release_del(cites_info(path), version)
}

## Core data:
cites_info <- function(path) {
  datastorr::github_release_info(
    "ecohealthalliance/cites",
    private = TRUE,
    filename = NULL,
    read = cites::fst_tbl,
    path = path
  )
}

#' Maintainer-only function for releasing data.  This will look at
#' the version in the DESCRIPTION file and make a data release if the
#' GitHub repository contains the same version as we have locally.
#' Requires the \code{GITHUB_TOKEN} environment variable to be set.
#'
#' @title Make a data release.
#' @param ... Parameters passed through to \code{\link{github_release_create}}
#' @param path Path to the data (see \code{\link{cites}}).
#' @noRd
cites_release <- function(..., path=NULL) {
  datastorr::github_release_create(cites_info(path), ...)
}
