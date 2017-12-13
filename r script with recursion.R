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
req <- GET("https://api.github.com/users/defunkt", gtoken)
# Take action on http error
stop_for_status(req)
#stop_for_status(req2)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))


# Subset data.frame

firstData = GET("https://api.github.com/users/defunkt/followers", gtoken)
stop_for_status(firstData)
dataF = content(firstData)
data = jsonlite::fromJSON(jsonlite::toJSON(dataF))

login = data$login
login_names = c()
login_names = "defunkt"
# vector that will hold usernames that have been accessed.

followerFunction <- function(username)
  #function(vector of inputted username followers)
{
  for ( i in 1:length(username))
    #for ( i in 1:2)
  {
    if(length(login_names) < 100){
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
      next
    }
  }
}

while(length(login_names) < 100){
  followerFunction(login)
}

for(j in 1:5){
  urlRepos =paste("https://api.github.com/users/",login_names[j],"/repos", sep="")
  repoAccess = GET(urlRepos, gtoken)
  repoContent = content(repoAccess)
  reposDF = jsonlite::fromJSON(jsonlite::toJSON(repoContent))
  reposName = reposDF$name

  dates = c()
  numberCommits = c()
  for(i in 1:length(reposName)){
    urlCommiters = paste("https://api.github.com/repos/", login_names[j],"/",reposName[i],"/contributors", sep = "")
    commitersAccess = GET(urlCommiters, gtoken)
    commitersContent = content(commitersAccess)
    commitersDF = jsonlite::fromJSON(jsonlite::toJSON(commitersContent))
    numberCommits[i] = length(commitersDF$login)
    
    urlDate = paste("https://api.github.com/repos/", login_names[j],"/", reposName[i],"", sep = "")
    dateAccess = GET(urlDate, gtoken)
    dateContent = content(dateAccess)
    dateDF = jsonlite::fromJSON(jsonlite::toJSON(dateContent))
    str = substr(dateDF$created_at,1,10)
    dates[i] = weekdays(as.Date(str))
  }
  x <- factor(dates, levels = c("Dé Luain", "Dé Máirt", "Dé Céadaoin", 
                            "Déardaoin", "Dé hAoine", "Dé Sathairn", "Dé Domhnaigh"),
              ordered = TRUE)
  plot(as.integer(x), numberCommits, xaxt="n", xlab = "Day of Week", ylab = "Number of Commits")
  axis(side = 1, at = x, labels = x)
}
?plot

#Quick display of two cabapilities of GGally, to assess the distribution and correlation of variables
library(GGally)

# Create data
sample_data <- data.frame( v1 = 1:100 + rnorm(100,sd=20), v2 = 1:100 + rnorm(100,sd=27), v3 = rep(1, 100) + rnorm(100, sd = 1))
sample_data$v4 = sample_data$v1 ** 2
sample_data$v5 = -(sample_data$v1 ** 2)

# Check correlation between variables
cor(sample_data)

# Check correlations (as scatterplots), distribution and print corrleation coefficient
ggpairs(sample_data)

# Nice visualization of correlations
ggcorr(sample_data, method = c("everything", "pearson"))

#commits people make to repos that arent their own
#Is there a correlation between how long they have been a user & the number of commits a day?