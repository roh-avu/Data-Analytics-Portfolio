

```{r setup, include=FALSE}
# some useful settings
knitr::opts_chunk$set(echo = TRUE, tidy.opts = list(width.cutoff = 55), tidy = TRUE, fig.align="center")
```

# Problem 1

## Part (a)
```{r}
setwd("~/Desktop/ravuthuecon124")
nba <- read.csv('nba.csv')
rowSums(is.na(nba))
help("rowSums")
```
rowSums(is.na(nba)) calculates how many missing values (NAs) are in each row of the NBA data set. This can be very useful for data cleaning and processing, allowing to identify rows with a high number of missing values that might need to be addressed, either by filling in these missing values or by removing the rows from the data set.


## Part (b)
```{r fig.height = 3, fig.width = 3}
sum(rowSums(is.na(nba)) > 0)
```
There are 51 rows in the dataframe that contain missing values


## Part (c)
```{r}
nba_omited <- na.omit(nba)
```
new dataframe that excludes all rows with missing
data.

## Part (d)
```{r}
nba_imputed <- nba 
for (i in 9:ncol(nba_imputed)) {
missing_rows <- is.na(nba_imputed[, i])
nba_imputed[missing_rows, i] <- mean(nba_imputed[, i],
na.rm = TRUE)
}
```
The first line stores the original datafram nba into nba_imputed.The second line starts a forloop that iterates through the columns. i in 9: ncol... is saying to ignore the first 9 columns because they may be character data, or may not have any missing values.The next line identifies which rows have missing values (NA). The function is.na() checks each element of the column i for NA values, returning a logical vector (TRUE for NAs and FALSE for non-NAs). This logical vector is stored in the variable missing_rows. The last line is where the imputing happens. It replaces all the NA values in column i with the mean of the non-NA values in that same column. 


## Part (e)
```{r}
column_sums <- colSums(nba[, (10:ncol(nba))], na.rm = TRUE)
sort(column_sums, decreasing = FALSE)

```
Turnovers, Defensive Rebounds, and Usage Percentage


## Part (f)
```{r}
# Set the plotting area to a 2 by 3 layout
par(mar = c(2, 2, 2, 2), mfrow = c(2, 3))

# Create histograms for the three variables using nba_omited dataframe
hist(nba_omited$TOV., freq = FALSE, main = "Turnovers (Omitted Data)", xlab = "TOV.", col = "blue")
hist(nba_omited$DRB., freq = FALSE, main = "Defensive Rebounds (Omitted Data)", xlab = "Defensive Rebounds", col = "green")
hist(nba_omited$USG., freq = FALSE, main = "Usage Percentage (Omitted Data)", xlab = "Usage Percentage", col = "red")

# Create histograms for the three variables using nba_imputed dataframe
hist(nba_imputed$TOV., freq = FALSE, main = "Turnovers (Imputed Data)", xlab = "Turnovers", col = "blue")
hist(nba_imputed$DRB., freq = FALSE, main = "Defensive Rebounds (Imputed Data)", xlab = "Defensive Rebounds", col = "green")
hist(nba_imputed$USG., freq = FALSE, main = "Usage Percentage (Imputed Data)", xlab = "Usage Percentage", col = "red")


```


# Problem 2
```{r}
nba_restricted <- nba_imputed[nba_imputed$G >= 50, ]

PER_max <- max(nba_restricted$PER, na.rm = TRUE)
Player_name <- nba_restricted$Player[nba_restricted$PER == PER_max]
cat(Player_name, ":", PER_max, "\n")

TS_max <- max(nba_restricted$TS, na.rm = TRUE)
Player_name2 <- nba_restricted$Player[nba_restricted$TS == TS_max]
cat(Player_name2, ":", TS_max, "\n")

VORP_max <- max(nba_restricted$VORP, na.rm = TRUE)
Player_name3 <- nba_restricted$Player[nba_restricted$VORP == VORP_max]
cat(Player_name3, ":", VORP_max)
```


# Problem 3
```{r}
# Extract Stephen Curry's stats
Steph_PER <- nba_restricted$PER[nba_restricted$Player == "Stephen Curry"]
Steph_TS <- nba_restricted$TS[nba_restricted$Player == "Stephen Curry"]
Steph_VORP <- nba_restricted$VORP[nba_restricted$Player == "Stephen Curry"]

# Total number of players in the dataset
total_players <- nrow(nba_restricted)

# Percentage of players with higher PER than Stephen Curry
players_higher_PER <- sum(nba_restricted$PER > Steph_PER, na.rm = TRUE)
percent_higher_PER <- (players_higher_PER / total_players) * 100
print(paste("Percentage of players with higher PER:", percent_higher_PER, "%"))

# Percentage of players with higher TS than Stephen Curry
players_higher_TS <- sum(nba_restricted$TS > Steph_TS, na.rm = TRUE)
percent_higher_TS <- (players_higher_TS / total_players) * 100
print(paste("Percentage of players with higher TS:", percent_higher_TS, "%"))

# Percentage of players with higher VORP than Stephen Curry
players_higher_VORP <- sum(nba_restricted$VORP > Steph_VORP, na.rm = TRUE)
percent_higher_VORP <- (players_higher_VORP / total_players) * 100
print(paste("Percentage of players with higher VORP:", percent_higher_VORP, "%"))
```
Steph has the highest True Shooting thats why it returns character(0) for that line of code. only 3 players have PER above Steph and 10 players have VORP above Steph


# Problem 4
## part (a)
```{r}
nba_USA <- nba_imputed[nba_imputed$NBA_Country == "USA", ]
nba_USA = subset(nba_USA, select = -NBA_Country)
```

## part (b)
```{r}
# Set the seed for reproducibility
set.seed(0)

n <- nrow(nba_USA)

training_set_indices <- sample(1:n, size = round(n * 0.9))

training_set <- nba_USA[training_set_indices, ]
test_set <- nba_USA[-training_set_indices, ]
```

# Problem 5
## part (a)
```{r}

logit_training <- glm(log(Salary) ~ ., data = training_set[,2:26])
summary(logit_training)
```

## part (b)
Looking at the regression results, while doing this we can see that TRB, AST, STL, BLK, and BPM may be important or can lead to higher salary, but it is just not statistically significant. PER has higher significance. This could mean that players who are more specialized in certain skills are just supposed to do that job. For example, a center will get rebounds, but at the end of the day the person who scores more will get paid more. 

# Problem 6
## part (a)
```{r}

realvaluedev <- function(Y, pred) {
  return(sum((Y - pred)^2))
}
```

## part (b)
```{r}
#1st way
builtindev <- deviance(logit_training)
builtindev


#2nd way
Y <- log(training_set$Salary)
pred <- predict(logit_training, newdata = training_set)
manualdev <- realvaluedev(Y, pred)
manualdev


```

## part (c)
```{r}
# IS R²
Y_train <- log(training_set$Salary)
pred_train <- predict(logit_training, newdata = training_set)
IS_R2 <- 1 - (realvaluedev(Y_train, pred_train) / sum((Y_train - mean(Y_train))^2))
IS_R2

# OOS R²
Y_test <- log(test_set$Salary)
pred_test <- predict(logit_training, newdata = test_set)
OOS_R2 <- 1 - (realvaluedev(Y_test, pred_test) / sum((Y_test - mean(Y_test))^2))
OOS_R2

```
The IS 𝑅² is 0.616, which shows that the model fits the training data fairly well. However, the OOS 𝑅² drops to 0.311, indicating that the model doesn't generalize as well to the test data. This suggests that the model might be overfitting the training data, so it might need some adjustments or regularization to perform better on new, unseen data.

