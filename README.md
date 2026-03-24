# sephora-product-analysis
End-to-end data analytics project on Sephora's product catalog using Python, PostgreSQL, and data visualization.

# Sephora Product Analysis

An end-to-end data analytics project analyzing Sephora's product catalog to uncover insights on brand performance, product ratings, customer reviews, pricing, and skin concern trends.

---

## Tools & Technologies
- **Python** (Pandas, Matplotlib, Seaborn)
- **PostgreSQL** (pgAdmin)
- **Jupyter Notebook**

---

## Project Workflow

**1. Data Collection**
Downloaded the Sephora Products dataset from Kaggle containing 8,494 products across 27 attributes including brand, category, rating, reviews, price, and ingredients.

**2. Data Loading**
Loaded the raw CSV into Python using Pandas and pushed it into a PostgreSQL database using SQLAlchemy.

**3. Data Cleaning**
Identified and handled missing values across 14 columns:
- Dropped 5 columns with more than 50% missing data
- Filled numerical columns with mean values
- Filled categorical columns with "Not Available"
- Result: 8,494 clean records across 22 columns

**4. SQL Analysis**
Wrote and executed 9 SQL queries on the cleaned dataset to answer key business questions.

**5. Data Visualization**
Created 5 charts using Matplotlib and Seaborn to visually present findings.

---

## Key Business Questions Answered

1. How are products distributed across categories?
2. What is the most common rating by product category?
3. Which 5 brands have the most products on Sephora?
4. What is the highest priced product?
5. Which products have more than 1,000 reviews?
6. Which 5 brands have the highest average rating?
7. Which skin concern has the highest product availability?
8. Which Sephora-exclusive limited edition skincare products are top rated?
9. Which brands have the most incomplete ingredient information?

---

## Key Findings

- **Skincare** is the largest category on Sephora by product count
- **Dryness/Hydration** is the most addressed skin concern across all products
- Only a small percentage of products are both Sephora-exclusive and limited edition
- Several top-rated brands maintain consistently high ratings across more than 10 products

---

## Dataset
- **Source:** [Sephora Products and Skincare Reviews — Kaggle](https://www.kaggle.com/datasets/nadyinky/sephora-products-and-skincare-reviews)
- **Size:** 8,494 products
- **Format:** CSV

---

## Files in this Repository

| File | Description |
|------|-------------|
| `Sephora.ipynb` | Main Jupyter Notebook with full analysis |
| `product_info.csv` | Raw dataset from Kaggle |
| `README.md` | Project documentation |
