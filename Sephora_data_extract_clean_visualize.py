# =============================================================
# Tools: Python, Pandas, SQLAlchemy, PostgreSQL, Matplotlib, Seaborn
# Dataset: Sephora Products and Skincare Reviews (Kaggle)
# =============================================================


import pandas as pd
import sqlalchemy as sal

df = pd.read_csv('/Users/Tanya/Downloads/archive/product_info.csv')

engine = sal.create_engine('postgresql://postgres:asmat786@localhost:5432/sephora_db')
conn = engine.connect()
print("Connected successfully!")

df.to_sql('product_info', con=conn, index=False, if_exists='replace')
print("Data loaded into PostgreSQL!")

conn.close()

df.isna().sum()

print(df.shape)

missing = (df.isna().sum() / len(df) * 100).round(2)
print(missing[missing > 0])

df_clean = df.drop(columns=['variation_desc', 'value_price_usd', 'sale_price_usd', 'child_max_price', 'child_min_price'])
print("Columns dropped!")
print("New shape:", df_clean.shape)

avg_rating = df_clean['rating'].mean().round(2)
df_clean['rating'] = df_clean['rating'].fillna(avg_rating)
print("Rating filled with average:", avg_rating)

df_clean['reviews'] = df_clean['reviews'].fillna(0)
print("Reviews filled with 0!")

df_clean['secondary_category'] = df_clean['secondary_category'].fillna('Unknown')
df_clean['size'] = df_clean['size'].fillna('Not Available')
df_clean['variation_type'] = df_clean['variation_type'].fillna('Not Available')
df_clean['variation_value'] = df_clean['variation_value'].fillna('Not Available')
df_clean['ingredients'] = df_clean['ingredients'].fillna('Not Available')
df_clean['highlights'] = df_clean['highlights'].fillna('Not Available')
df_clean['tertiary_category'] = df_clean['tertiary_category'].fillna('Not Available')
print("All remaining missing values filled!")

print("Missing values remaining:")
print(df_clean.isna().sum().sum())
print("Final shape:", df_clean.shape)

conn = engine.connect()
print("Connected!")

df_clean.to_sql('products_clean', con=conn, index=False, if_exists='replace')
conn.close()
print("Clean data pushed to PostgreSQL!")

print(df_clean.shape)

print(df_clean.dtypes)

conn.close()
print("Connection closed")

import matplotlib.pyplot as plt
import seaborn as sns
print("Ready!")



category_counts = df_clean['primary_category'].value_counts()

plt.figure(figsize=(10, 6))
sns.barplot(x=category_counts.values, y=category_counts.index, palette='magma')
plt.title('Number of Products by Primary Category', fontsize=16)
plt.xlabel('Product Count')
plt.ylabel('Category')
plt.tight_layout()
plt.show()




top_brands = df_clean['brand_name'].value_counts().head(5)

plt.figure(figsize=(10, 6))
sns.barplot(x=top_brands.values, y=top_brands.index, palette='viridis')
plt.title('Top 5 Brands with Most Products', fontsize=16)
plt.xlabel('Number of Products')
plt.ylabel('Brand')
plt.tight_layout()
plt.show()



high_reviews = df_clean[df_clean['reviews'] > 1000].nlargest(10, 'reviews')[['product_name', 'reviews']]

plt.figure(figsize=(12, 6))
sns.barplot(x='reviews', y='product_name', data=high_reviews, palette='coolwarm')
plt.title('Top 10 Products with Most Reviews', fontsize=16)
plt.xlabel('Number of Reviews')
plt.ylabel('Product')
plt.tight_layout()
plt.show()




top_rated = df_clean.groupby('brand_name').filter(lambda x: len(x) > 10)
top_rated = top_rated.groupby('brand_name')['rating'].mean().nlargest(5).round(2)

plt.figure(figsize=(10, 6))
sns.barplot(x=top_rated.values, y=top_rated.index, palette='Blues_d')
plt.title('Top 5 Brands by Average Rating', fontsize=16)
plt.xlabel('Average Rating')
plt.ylabel('Brand')
plt.xlim(0, 5)
plt.tight_layout()
plt.show()



def categorize_concern(text):
    if not isinstance(text, str):
        return 'General'
    text = text.lower()
    if 'acne' in text or 'blemish' in text:
        return 'Acne'
    elif 'anti-aging' in text or 'wrinkle' in text:
        return 'Anti-Ageing'
    elif 'hydrat' in text or 'dry' in text:
        return 'Dryness/Hydration'
    elif 'brighten' in text or 'glow' in text:
        return 'Brightening'
    elif 'sensitive' in text:
        return 'Sensitive Skin'
    elif 'spf' in text or 'sun' in text:
        return 'Sun Protection'
    else:
        return 'General'

df_clean['skin_concern'] = df_clean['highlights'].apply(categorize_concern)
concern_counts = df_clean['skin_concern'].value_counts()

plt.figure(figsize=(10, 8))
plt.pie(concern_counts.values, labels=concern_counts.index, autopct='%1.1f%%', colors=sns.color_palette('pastel'))
plt.title('Products by Skin Concern', fontsize=16)
plt.tight_layout()
plt.show()


