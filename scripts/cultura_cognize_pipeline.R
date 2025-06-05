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


# ---  Exploratory t-SNE Visualization for Term Similarity ---
# (use voyant if you like)

# Frequency-based t-SNE
term_matrix_freq <- t(as.matrix(dfm))
top_terms_freq <- names(sort(rowSums(term_matrix_freq), decreasing = TRUE))[1:80]
term_matrix_top_freq <- term_matrix_freq[top_terms_freq, ]
term_matrix_top_freq <- term_matrix_top_freq[!duplicated(term_matrix_top_freq), ]
tsne_freq <- Rtsne(term_matrix_top_freq, dims = 2, perplexity = 20)
term_df_freq <- as.data.frame(tsne_freq$Y)
colnames(term_df_freq) <- c("Dim1", "Dim2")
term_df_freq$Term <- rownames(term_matrix_top_freq)
set.seed(1)
term_df_freq$Cluster <- as.factor(kmeans(term_df_freq[,1:2], centers = 5)$cluster)
plot_freq <- plot_ly(term_df_freq, x = ~Dim1, y = ~Dim2, type = 'scatter', mode = 'markers+text',
                     color = ~Cluster, colors = "Set1", text = ~Term, textposition = "top center",
                     marker = list(size = 8)) %>%
  layout(title = "t-SNE (Top 80 Terms by Frequency)",
         xaxis = list(title = "t-SNE 1"), yaxis = list(title = "t-SNE 2"))

# TF-IDF-based t-SNE
tfidf_matrix <- as.matrix(t(dfm_tfidf(dfm)))
top_terms_tfidf <- names(sort(rowMeans(tfidf_matrix), decreasing = TRUE))[1:80]
term_matrix_top_tfidf <- tfidf_matrix[top_terms_tfidf, ]
term_matrix_top_tfidf <- term_matrix_top_tfidf[!duplicated(term_matrix_top_tfidf), ]
tsne_tfidf <- Rtsne(term_matrix_top_tfidf, dims = 2, perplexity = 20)
term_df_tfidf <- as.data.frame(tsne_tfidf$Y)
colnames(term_df_tfidf) <- c("Dim1", "Dim2")
term_df_tfidf$Term <- rownames(term_matrix_top_tfidf)
set.seed(2)
term_df_tfidf$Cluster <- as.factor(kmeans(term_df_tfidf[,1:2], centers = 5)$cluster)
plot_tfidf <- plot_ly(term_df_tfidf, x = ~Dim1, y = ~Dim2, type = 'scatter', mode = 'markers+text',
                      color = ~Cluster, colors = "Set2", text = ~Term, textposition = "top center",
                      marker = list(size = 8)) %>%
  layout(title = "t-SNE (Top 80 Terms by TF-IDF)",
         xaxis = list(title = "t-SNE 1"), yaxis = list(title = "t-SNE 2"))

# Show both side by side
subplot(plot_freq, plot_tfidf, nrows = 1, margin = 0.05) %>%
  layout(title = "Term-Level t-SNE: Frequency vs. TF-IDF (w/ Labels & Clusters)")

# ---  Exploratory Unsupervised LDA  ---
```r
set.seed(2024)
lda_model <- textmodel_lda(dfm, k = 8)
terms(lda_model, 10)  # Top 10 terms per topic
```

# ------------------------------------------------------------------------

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
