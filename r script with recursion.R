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
req <- GET("https://api.github.com/users/eljoyce", gtoken)
# Take action on http error
stop_for_status(req)
#stop_for_status(req2)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))


# Subset data.frame

firstData = GET("https://api.github.com/users/eljoyce/followers", gtoken)
stop_for_status(firstData)
dataF = content(firstData)
data = jsonlite::fromJSON(jsonlite::toJSON(dataF))

login = data$login
login_names = c()
login_names = "eljoyce"
#login_names = append(login_names, "Sarah", (length(login_names) + 1))
#login_names = append(login_names, "Sarah", (length(login_names) + 1))
limit = 0


# vector that will hold usernames that have been accessed.

followerFunction <- function(username)
  #function(vector of inputted username followers)
{
  for ( i in 1:length(username))
  #for ( i in 1:2)
  {
    u = username[i]
    #Follower of username
    if( (u %in% login_names) == FALSE){
      #If statement checks if username is in login names
      url =paste("https://api.github.com/users/", u, "/followers", sep="")
      followersAccess = GET(url, gtoken)
      followersContent = content(followersAccess)
      if(length(followersContent) == 0){
        next
      }
      followersDF = jsonlite::fromJSON(jsonlite::toJSON(followersContent))
      fLogin = followersDF$login
      login_names <<- append(login_names, u, (length(login_names) + 1))
      print(login_names)
      followerFunction(fLogin)
    }
    limit = limit + 1
    next
  }
}

while(limit < 10){
  followerFunction(login)
}