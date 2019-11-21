# Text analytics Using Twitter content to predict the gender of the user



# Read in the original data set

tweets_raw = read.csv("gender_tweets.csv", stringsAsFactors=FALSE)

str(tweets_raw)

# Extract the random tweet text and gender to a new dataframe

tweets <- subset(tweets_raw, select = c(gender, text))

str(tweets)

table(tweets$gender)

# Clean and simplify data set : Keep rows with either a female user or male user (i.e. exclude null values and brands)

tweets_gender = subset(tweets, gender =="female" | gender =="male")

tweets_gender$gender <- as.factor(tweets_gender$gender)


str(tweets_gender)

table(tweets_gender$gender)

# Encode function: turn 'text' column (multibyte) to utf8 form

tweets_gender$text <- iconv(enc2utf8(tweets_gender$text),sub="byte")


#!!!!!! Create dependent variable

#tweets$Negative = as.factor(tweets$Avg <= -1)

#table(tweets$Negative)


# Install new packages

install.packages("tm")
library(tm)
install.packages("SnowballC")
library(SnowballC)


# Create corpus
corpus = VCorpus(VectorSource(tweets_gender$text)) 

# Look at corpus
corpus
corpus[[1]]$content


# Convert to lower-case

corpus = tm_map(corpus, content_transformer(tolower))

corpus[[1]]$content

# Remove punctuation

corpus = tm_map(corpus, removePunctuation)

corpus[[10]]$content

# Look at stop words 
stopwords("english")[1:10]

# Remove stopwords

corpus = tm_map(corpus, removeWords,  stopwords("english"))

corpus[[10]]$content

# Stem document 

corpus = tm_map(corpus, stemDocument)

corpus[[10]]$content






# Create matrix

frequencies = DocumentTermMatrix(corpus)

frequencies

# Look at matrix 

inspect(frequencies[1000:1005,505:515])

# Check for sparsity
#lowfreq = 20
findFreqTerms(frequencies, lowfreq=20)

# Remove sparse terms

sparse = removeSparseTerms(frequencies, 0.995)
sparse

# Convert to a data frame

tweetsSparse = as.data.frame(as.matrix(sparse))

# Make all variable names R-friendly

colnames(tweetsSparse) = make.names(colnames(tweetsSparse))

# Add dependent variable

tweetsSparse$gender = tweets_gender$gender

# Split the data

library(caTools)

set.seed(123)

split = sample.split(tweetsSparse$gender, SplitRatio = 0.7)

trainSparse = subset(tweetsSparse, split==TRUE)
testSparse = subset(tweetsSparse, split==FALSE)



# Video 7

# Build a CART model

library(rpart)
library(rpart.plot)

tweetCART = rpart(gender ~ ., data=trainSparse, method="class")

prp(tweetCART)

# Evaluate the performance of the model
predictCART = predict(tweetCART, newdata=testSparse, type="class")

table(testSparse$gender, predictCART)

# Compute accuracy

(1994+41)/(1994+16+1817+41)
#(294+18)/(294+6+37+18)

# Baseline accuracy 

table(testSparse$gender)

(1994+16)/(1994+16+1817+41)


# Random forest model

library(randomForest)
set.seed(123)

tweetRF = randomForest(gender ~ ., data=trainSparse)

# Make predictions:
predictRF = predict(tweetRF, newdata=testSparse)

table(testSparse$gender, predictRF)

# Accuracy:
#(293+21)/(293+7+34+21)


