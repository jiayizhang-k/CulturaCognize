# CulturaCognize
*CulturaCognize* is a semi-supervised NLP pipeline designed to explore the intersection of **cognition** and **culture** through **film review analysis**. By combining topic modeling (LDA), dimensionality reduction (t-SNE), and interactive visualizations (LDAvis), this tool empowers researchers to uncover emergent interpretive frames in audience discourse—especially in contexts shaped by political memory and collective emotion.

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

## 📂 File Structure
CulturaCognize/
├── data/ # Raw and preprocessed input data (e.g., reviews.csv)
│
├── output/ # Output files (e.g., LDA topics, t-SNE plots, JSON for LDAvis)
│ ├── lda_model.RDS # Saved LDA model object
│ ├── tsne_coordinates.csv # t-SNE 2D projection of document clusters
│ └── ldavis.json # JSON file for LDAvis visualization
│
├── dictionaries/ # Seed words or custom topic dictionaries for semi-supervised LDA
│ └── seed_topics.csv
│
├── scripts/ # Main pipeline and helper functions
│ ├── cultura_cognize_pipeline.R
│ └── utils.R
│
├── figures/ # Optional folder for exported plots or diagrams
│ └── topics_overview.png
│
├── README.md # Project overview and usage guide
├── LICENSE # MIT License
└── .Rproj # R project file (optional but recommended for IDE support)


## License
This project is licensed under the MIT License.  
You are free to use, modify, and redistribute with attribution.  
If you publish with it, please consider citing:
> Zhang, J. (2025). *CulturaCognize: A Semi-Supervised Topic Modeling Pipeline for Cultural Analysis*. GitHub. https://github.com/jiayizhang-k/CulturaCognize

## About the Author
Developed by Jiayi Zhang, a researcher interested in computational humanities, cultural memory, and audience cognition.  

---
“Culture is the residue of cognition made collective. Let's analyze it—beautifully.”

