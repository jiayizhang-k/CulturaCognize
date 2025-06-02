# CulturaCognize
*CulturaCognize* is a semi-supervised NLP pipeline designed to explore the intersection of **cognition** and **culture** through **film review analysis** in Chinese. By combining topic modeling (LDA), dimensionality reduction (t-SNE), and interactive visualizations (LDAvis), this tool empowers researchers to uncover emergent interpretive frames in audience discourse—especially in contexts shaped by political memory and collective emotion.
> **Note**: The customized stopwords and dictionary design showcased in this pipeline are based on our research using Douban reviews of *Farewell My Concubine* (Jiayi Zhang and Chandler Rosenberger). While the repository serves as a general-purpose tutorial for semi-supervised topic modeling and visualization, it also reflects the methodological foundation of our applied work. The examples are intended as illustrative guides for broader use and adaptation.

## Features
- **Semi-supervised LDA** using seeded topic dictionaries
- **Custom stopword handling** for domain-specific corpora (e.g., Chinese film reviews)
- **t-SNE visualization** for pre-labeling clusters to aid human coding
- **LDAvis integration** for interactive topic distance maps
- Tunable parameters like seed strength, topic number, and iterations
- Built for **R** using `quanteda`, `textmineR`, `LDAvis`, and `Rtsne`

## Why CulturaCognize?
This pipeline is especially useful for digital humanists, cognitive sociologists, and cultural analysts who want to:
- Study interpretive communities in online spaces
- Visualize ideological clusters in textual data
- Ground qualitative insights in empirical, computational evidence

## Quickstart
1. Clone this repo:
    ```bash
    git clone https://github.com/jiayizhang-k/CulturaCognize.git
    ```

2. Load the core script:
    ```r
    source("cultura_cognize_pipeline.R")
    ```

3. Customize:
    - Load your corpus (e.g., film reviews)
    - Update your domain-specific stopwords
    - Seed your dictionary for semi-supervised LDA

4. Visualize results in:
    - `t-SNE`: for clusterable patterns
    - `LDAvis`: for inter-topic distance and prevalence

## File Structure (after running the full pipeline)
- `data/` — Input
  - `reviews.csv`: Raw and preprocessed film review data 

- `output/` — Output files from modeling and visualization  
  - `lda_model.RDS`: Fitted LDA model  
  - `tsne_coordinates.csv`: t-SNE 2D coordinates  
  - `ldavis.json`: JSON input for LDAvis app
  - `LDAvis_output`/: Folder containing LDAvis HTML files 

- `dictionaries/` —  Input (custom seed words) 
  - `seed_topics.csv`: Custom seed dictionaries for semi-supervised LDA  

- `scripts/` — Source 
  - `cultura_cognize_pipeline.R`: Main R pipeline script
  - `utils.R`: Optional helper functions (to be filled)

- `figures/` — Output (optional)
  - `topics_overview.png`: Saved plot(s) from t-SNE or LDA diagnostics
 
- `vignettes/` —  Documentation
  - `semi-supervised-lda.Rmd`: Tutorial-style walk-through of pipeline

- `LICENSE` — MIT License

- `README.md` — Project overview and usage instructions

- `CulturaCognize.Rproj` — RStudio project file


## License
This project is licensed under the MIT License.  
You are free to use, modify, and redistribute with attribution.  
If you publish with it, please consider citing:
> Zhang, J. (2025). *CulturaCognize: A Semi-Supervised Topic Modeling Pipeline for Cultural Analysis*. GitHub. https://github.com/jiayizhang-k/CulturaCognize

## About the Author
Developed by Jiayi Zhang, a researcher interested in computational humanities, cultural memory, and audience cognition.  

--- 
> **“In fragments we chatter, in patterns we conspire — this is our poetry, murmured by the crowd.”**  

