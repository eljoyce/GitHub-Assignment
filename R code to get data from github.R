install.packages('httr')
install.packages('jsonlite')
install.packages('httpuv')
install.packages('gh')

#install.packages("jsonlite")
library(jsonlite)
#install.packages("httpuv")
library(httpuv)
#install.packages("httr")
library(httr)

# Can be github, linkedin etc depending on application
oauth_endpoints("github")

# Change based on what you 
myapp <- oauth_app(appname = "Software_Engineering_Assignment",
                   key = "e71c7277d63b0d86a4ea",
                   secret = "371f44d5b20c4a337156f493855f79510d4170d9")


# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Use API for eljoyce
gtoken2 <- config(token = github_token)
req2 <- GET("https://api.github.com/users/eljoyce/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json2 = content(req)
