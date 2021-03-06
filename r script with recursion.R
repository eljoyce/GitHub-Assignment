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

install.packages("plotly")

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

finalDF = data.frame(matrix(vector(), 0, 5,
                      dimnames=list(c(), c("User", "Average Number of Commiters",
                              "Followers of User", "Number of Repos a User Has",
                              "Number of Stars User Has"))),stringsAsFactors=F)
for(j in 1:length(login_names)){
  stars = 0
  #Get a list of the repositoty names for the user
  urlRepos =paste("https://api.github.com/users/",login_names[j],"/repos", sep="")
  repoAccess = GET(urlRepos, gtoken)
  repoContent = content(repoAccess)
  reposDF = jsonlite::fromJSON(jsonlite::toJSON(repoContent))
  reposName = reposDF$name
  #get the number of repos each user has
  numberRepos = length(reposName)
  
  #Number of stars on each repo
  if(numberRepos != 0){
  stars = Reduce("+", reposDF$stargazers_count)
  }
  
  #For loop to collect the number of contributers to each repo that the user owns
  numberCommiters = c()
  for(i in 1:length(reposName)){
    urlCommiters = paste("https://api.github.com/repos/", login_names[j],"/",reposName[i],"/contributors", sep = "")
    commitersAccess = GET(urlCommiters, gtoken)
    commitersContent = content(commitersAccess)
    commitersDF = jsonlite::fromJSON(jsonlite::toJSON(commitersContent))
    if(is.null(nrow(commitersDF["login"]))){
      numberCommiters[i] = 0
    }
    else{
      numberCommiters[i] = nrow(commitersDF["login"])
    }
  }
  #Average number of commiters for this user's repos
  avgCommiters = mean(numberCommiters)
  
  #Get the number of followers of user
  urlFollowers =paste("https://api.github.com/users/", login_names[j], "/followers", sep="")
  followersAccess = GET(urlFollowers, gtoken)
  followersContent = content(followersAccess)
  followersDF = jsonlite::fromJSON(jsonlite::toJSON(followersContent))
  noFollowers = length(followersDF$login)
  
  finalDF[j,] = c(login_names[j], avgCommiters, noFollowers, numberRepos, stars)
}
plot(finalDF[,2], finalDF[,3],main = "Plot", xlab = "Average number of Commiters to the Repos", ylab = "Number of Followers")

#Sets row names equal to the user names
rownames(finalDF) = finalDF[,1]
finalDF[,1] = NULL

# Write CSV in R into current folder
write.csv(finalDF, file = "FinalDataSet.csv")


#Quick display of two cabapilities of GGally, to assess the distribution and correlation of variables
install.packages(GGally)
library(GGally)

cor(finalDF)
# Check correlations (as scatterplots), distribution and print corrleation coefficient
ggpairs(finalDF)
# Nice visualization of correlations
ggcorr(finalDF, method = c("everything", "pearson"))

#Install necessary plotting packages
require(devtools)
library(plotly)

#Produce a scatter plot of Followers vs Following
Plot1 = plot_ly(data = finalDF, x = ~finalDF[,1], y = ~, text = ~paste("Following: ", Following, 
                                                                                  "<br>Followers: ", Followers))
MyPlot

#Upload the plot to Plotly
Sys.setenv("plotly_username" = "eljoyce")
Sys.setenv("plotly_api_key" = "TPPzofmBxgXp5KWhrHTi")
api_create(MyPlot, filename = "Average Number of Commiters to User's Repos vs Followers of User")
