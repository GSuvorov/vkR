% Generated by roxygen2 (4.0.2): do not edit by hand
\name{databaseGetRegions}
\alias{databaseGetRegions}
\title{Returns a list of regions}
\usage{
databaseGetRegions(country_id = "", q = "", offset = "", count = "100")
}
\arguments{
\item{country_id}{Country ID, received in databaseGetCountries() method.}

\item{q}{Search query.}

\item{offset}{Offset needed to return specific subset of regions.}

\item{count}{Number of regions to return.}
}
\value{
Returns a list of region objects each containing region_id and title fields.
}
\description{
Returns a list of regions
}
\examples{
databaseGetRegions(229)
}

