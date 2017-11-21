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
#req2 <- GET("https://api.github.com/users/torvalds/followers", gtoken)
# Take action on http error
stop_for_status(req)
#stop_for_status(req2)

# Extract content from a request
json1 = content(req)
#json2 = content(req2)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))
#gitDF2 = jsonlite::fromJSON(jsonlite::toJSON(json2))

# Subset data.frame
#gitDF[gitDF$full_name == "sorchaobyrne/datasharing", "created_at"] 



data = fromJSON("https://api.github.com/users/eljoyce/followers")
login = data$login

login_names = "eljoyce"
limit = 0
while(limit < 30){
  followerFunction(login)
}
# vector that will hold usernames that have been accessed.

followerFunction <- function(username)
  #function(vector of inputted username followers)
{
  for ( i in 1:length(username))
  {
    u = username[i]
    #Follower of username
    if( (u %in% login_names) == FALSE){
      #If statement checks if username is in login names
      url =paste("https://api.github.com/users/", u, "/followers", sep="")
      followers = fromJSON(url)
      f = followers$login
      append(login_names, u, (length(login_names)))
      print(login_names)
      followerFunction(f)
      limit = limit + 1
    }
    next
  }
}
