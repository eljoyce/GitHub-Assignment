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

req3 <- GET("https://api.github.com/users", gtoken)
# Take action on http error
stop_for_status(req)

# Extract content from a request
json2 = content(req)

data1 <- fromJSON("https://api.github.com/users/eljoyce/followers")
login = data1$login
login
UserLogin = c(login)

login_names = UserLogin
login_names
for (i in 1:length(UserLogin))
{
  u = UserLogin[i]
  u
  url_name <-paste("https://api.github.com/users/", u, "/followers", sep = "")
  followers = fromJSON(url_name)
  follower_logins = c(followers$login)
  #follower_logins
  #length(follower_logins)
  #(follower_logins[j] %in% login_names)
  for(j in 1:length(follower_logins)){
    if((follower_logins[j] %in% login_names) == FALSE){
      append(login_names, follower_logins[j], (length(login_names)))
      next
    }
  }
  next
}

login_names
u2 = eljoyce
url_name2 <-paste("https://api.github.com/users/", u2, "/followers", sep = "")
followers2 = fromJSON(url_name)

?fromJSON
#Current problem - followers can only store 30 followers
install.packages("ff")
library(ff)

install.packages("RJSONIO")

install.packages("RNeo4j")
graph = startGraph("http://localhost:7474/db/data/")
