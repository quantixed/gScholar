if(!require(scholar)){
  install.packages("scholar")
}
library(scholar)
# Add Google Scholar ID of interest here
ID <- ""
# If you didn't add one to the script prompt user to add one
if(ID == ""){
  ID <- readline(prompt="Enter Scholar ID: ")
}
# Get the citation history
citeByYear<-get_citation_history(ID)
# Get profile information
profile <- get_profile(ID)
# Get publications and save as a csv
pubs <- get_publications(ID)
write.csv(pubs, file = "citations.csv")
# Predict h-index
hIndex <- predict_h_index(ID)
# Now make some plots
# Plot of total citations by year
png(file = "citationsByYear.png")
plot(citeByYear$year,citeByYear$cites,
     type="h", xlab="Year", ylab = "Total Cites")
dev.off()
# Plot of ranked paper by citation with h
png(file = "citationsAndH.png")
plot(pubs$cites, type="l",
     xlab="Paper rank", ylab = "Citations per paper")
abline(0,1)
text(nrow(pubs),max(pubs$cites, na.rm = TRUE),
     profile$h_index)
dev.off()
# Plot of cites to paper by year
png(file = "citesByYear.png")
plot(pubs$year, pubs$cites,
     xlab="Year", ylab = "Citations per paper")
dev.off()
# Plot of h-index prediction
thisYear <- as.integer(format(Sys.Date(), "%Y"))
png(file = "hPred.png")
plot(hIndex$years_ahead+thisYear,hIndex$h_index,
     ylim = c(0, max(hIndex$h_index, na.rm = TRUE)),
     type = "h",
     xlab="Year", ylab = "H-index prediction")                       
dev.off()
