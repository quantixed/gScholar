if(!require(scholar)){
  install.packages("scholar")
}
require(scholar)
require(ggplot2)
require(gridExtra)
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
# Get publications
pubs <- get_publications(ID)
# Add a column containing rank to dataframe and save as csv
pubs$rank <- seq.int(nrow(pubs))
write.csv(pubs, file = "citations.csv")
# Predict h-index and convert to real years
hIndex <- predict_h_index(ID)
hIndex$years_ahead <- hIndex$years_ahead + thisYear
# Now make some plots
# Ranked total cites of papers and h slope with h in top right
p1 <- ggplot(pubs, aes(x = rank, y = cites)) +
  geom_line(colour = "orange", alpha = 0.7, size = 2) +
  geom_abline(intercept = 0, slope = 1, linetype = "dashed") +
  annotate("text", y= max(pubs$cites), x =max(pubs$rank),label=profile$h_index,hjust=1) + labs(x = "Rank", y = "Citations per paper") + theme(axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"))
# Ranked total cites of papers and h slope with h in top right
p2 <- ggplot(citeByYear, aes(x = year, y = cites)) + 
  geom_col(fill = "blue", alpha = 0.7) + 
  labs(x = "Year", y = "Total Cites") +
  theme(axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"))
# Citations per paper versus year published
p3 <- ggplot(pubs, aes(x = year, y = cites)) + 
  geom_point(colour = "orange", alpha = 0.5, size = 2) + 
  labs(x = "Citations per paper", y = "Year published") + 
  theme(axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"))
# Citations per paper versus year published
p4 <- ggplot(hIndex, aes(x = years_ahead, y = h_index)) +
  xlim(min(hIndex$years_ahead)-1,max(hIndex$years_ahead)+1) +
  geom_col(alpha = 0.7) + 
  labs(x = "Year", y = "H-index prediction") +
  theme(axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"))
# make the grid
png("scholar.png", width = 1200, height = 1200)
grid.arrange(p1, p2, p3, p4, nrow = 2)
dev.off()
