% Generated by roxygen2 (4.0.2): do not edit by hand
\name{getGroups}
\alias{getGroups}
\title{Returns a list of the communities to which a user belongs.}
\usage{
getGroups(user_id = "", extended = "", filter = "", fields = "",
  offset = "", count = "", v = "5.33")
}
\arguments{
\item{user_id}{User ID.}

\item{extended}{1 — to return complete information about a user's communities, 0 — to return a list of community IDs without any additional fields (default).}

\item{filter}{Types of communities to return:
\itemize{
\item \strong{admin} — to return communities administered by the user;
\item \strong{editor} — to return communities where the user is an administrator or editor;
\item \strong{moder} — to return communities where the user is an administrator, editor, or moderator;
\item \strong{groups} — to return only groups;
\item \strong{publics} — to return only public pages;
\item \strong{events} — to return only events.
}}

\item{fields}{Profile fields to return.}

\item{offset}{Offset needed to return a specific subset of communities.}

\item{count}{Number of communities to return.}

\item{v}{API version}
}
\value{
Returns a list of IDs of the communities to which the user belongs.
If extended is set to 1, returns a list of community objects
}
\description{
Returns a list of the communities to which a user belongs.
}
\examples{
groups <- getGroups('1', fields='sex,bdate,city,country,photo_50,education,interests,music,movies,tv,books,games,about,quotes,personal')
}

