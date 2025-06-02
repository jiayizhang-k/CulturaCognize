# cultura_cognize_pipeline.R

# Load Required Libraries
library(quanteda)
library(quanteda.textmodels)
library(topicmodels)
library(textmineR)
library(LDAvis)
library(tidyverse)
library(Rtsne)
library(rsconnect)
library(shiny)

# Load and Prepare Data
corpus_raw <- read_csv("data/reviews.csv")
corpus_text <- corpus_raw$content

# Tokenization and Stopword Removal
corpus_tokens <- tokens(corpus_text, remove_punct = TRUE, remove_numbers = TRUE)
corpus_tokens <- tokens_remove(corpus_tokens, pattern = stopwords("zh", source = "marimo"))

custom_stopwords <- c("蝶衣","霸王", "一个", "自己", "虞姬", "电影", "小豆", "没有", "时候", "就是", "最后", "有用", "他们")
corpus_tokens <- tokens_remove(corpus_tokens, pattern = custom_stopwords)

# Construct Document-Feature Matrix
dfm <- dfm(corpus_tokens)
dfm <- dfm_trim(dfm, min_termfreq = 5, min_docfreq = 3)

# Exploratory t-SNE Visualization
dfm_matrix <- convert(dfm, to = "matrix")
dfm_tsne <- Rtsne(as.matrix(dist(dfm_matrix)), dims = 2, perplexity = 30)
plot(dfm_tsne$Y, col = "blue", pch = 19, main = "t-SNE Plot of Document Similarity")

# Define Seed Topics
dict_seeds <- dictionary(list(
  Anomie = c('悲剧','绝望','动荡','无情','失去','痛苦','悲哀','疯狂','黑暗','挣扎','害怕','混乱','折磨','暴力','悲惨','可悲','沉重','残忍','悲伤','苦难','崩溃','残酷','艰苦','辛苦'),
  Fatalism = c('命运','注定','死了','突然','成就','死亡','死去','凡人','乱世','毁灭','宿命','天命', '无力','命苦','认命'),
  Powerlessness = c('可惜','不愿','难以','普通','妥协','平凡','承受','屈服','隐忍','牺牲','可怜','压抑', '孤独','无奈','放弃'),
  Integrity = c('人性','人心','人格','抛弃','扭曲','出卖','转变','背叛','揭发','批斗','自保','六亲', '不认')
))

# Fit Semi-Supervised LDA Model
set.seed(2025)
dfm_sslda <- dfm_weight(dfm, scheme = "count")
model <- textmodel_seededlda(dfm_sslda, seeds = dict_seeds, residual = 3,
                              auto_iter = FALSE, max_iter = 2000, verbose = TRUE)

# Generate LDAvis JSON
json_lda <- createJSON(
  phi = model$phi,
  theta = model$theta,
  doc.length = rowSums(dfm_sslda),
  vocab = colnames(dfm_sslda),
  term.frequency = colSums(dfm_sslda)
)
write(json_lda, file = "output/ldavis.json")
serVis(json_lda, out.dir = "output/LDAvis_output", open.browser = FALSE)

# Shiny App
ui <- shinyUI(
  fluidPage(
    h1('How we make sense of the past?'),
    p('An RShiny page for LDAvis, by Jiayi Zhang'),
    visOutput('myChart')
  )
)

server <- shinyServer(function(input, output, session){
  output$myChart <- renderVis({
    readChar("output/ldavis.json", file.info("output/ldavis.json")$size)
  })
})

# Uncomment to launch the app locally
# shinyApp(ui = ui, server = server)
