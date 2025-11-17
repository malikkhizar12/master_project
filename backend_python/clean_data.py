"""
Script to clean and preprocess the datasets
"""
import pandas as pd
import numpy as np
import sys
import io

# Fix encoding for Windows console
if sys.platform == 'win32':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

def clean_courses(df):
    """Clean courses dataset"""
    # Remove duplicates
    df = df.drop_duplicates(subset=['id'])
    
    # Fill missing values
    df['description'] = df['description'].fillna('No description available')
    df['instructor'] = df['instructor'].fillna('Unknown Instructor')
    df['rating'] = df['rating'].fillna(0.0)
    df['enrolledCount'] = df['enrolledCount'].fillna(0)
    df['price'] = df['price'].fillna(0.0)
    
    # Ensure rating is between 0 and 5
    df['rating'] = df['rating'].clip(0, 5)
    
    # Ensure enrolledCount is non-negative
    df['enrolledCount'] = df['enrolledCount'].clip(lower=0)
    
    # Ensure price is non-negative
    df['price'] = df['price'].clip(lower=0)
    
    # Set isFree based on price
    df['isFree'] = df['price'] == 0
    
    # Clean duration format
    df['duration'] = df['duration'].astype(str)
    
    return df

def clean_books(df):
    """Clean books dataset"""
    # Remove duplicates
    df = df.drop_duplicates(subset=['id'])
    
    # Fill missing values
    df['description'] = df['description'].fillna('No description available')
    df['author'] = df['author'].fillna('Unknown Author')
    df['rating'] = df['rating'].fillna(0.0)
    df['pageCount'] = df['pageCount'].fillna(0)
    df['price'] = df['price'].fillna(0.0)
    df['language'] = df['language'].fillna('English')
    
    # Ensure rating is between 0 and 5
    df['rating'] = df['rating'].clip(0, 5)
    
    # Ensure pageCount is positive
    df['pageCount'] = df['pageCount'].clip(lower=1)
    
    # Ensure price is non-negative
    df['price'] = df['price'].clip(lower=0)
    
    # Set isFree based on price
    df['isFree'] = df['price'] == 0
    
    # Clean publishedYear
    if 'publishedYear' in df.columns:
        df['publishedYear'] = pd.to_numeric(df['publishedYear'], errors='coerce')
        current_year = pd.Timestamp.now().year
        df['publishedYear'] = df['publishedYear'].clip(lower=1900, upper=current_year)
    
    return df

def clean_interactions(df):
    """Clean user interactions dataset"""
    # Remove duplicates
    df = df.drop_duplicates(subset=['user_id', 'item_id', 'item_type'])
    
    # Fill missing values
    df['rating'] = df['rating'].fillna(3)
    df['completed'] = df['completed'].fillna(False)
    
    # Ensure rating is between 1 and 5
    df['rating'] = df['rating'].clip(1, 5)
    
    # Fill time_spent_minutes if missing
    if 'time_spent_minutes' in df.columns:
        df['time_spent_minutes'] = df['time_spent_minutes'].fillna(0)
        df['time_spent_minutes'] = df['time_spent_minutes'].clip(lower=0)
    
    # Fill pages_read if missing
    if 'pages_read' in df.columns:
        df['pages_read'] = df['pages_read'].fillna(0)
        df['pages_read'] = df['pages_read'].clip(lower=0)
    
    return df

if __name__ == '__main__':
    print("[*] Cleaning datasets...")
    
    # Load datasets
    courses_df = pd.read_csv('data/courses.csv')
    books_df = pd.read_csv('data/books.csv')
    interactions_df = pd.read_csv('data/user_interactions.csv')
    
    print(f"Original data:")
    print(f"   Courses: {len(courses_df)}")
    print(f"   Books: {len(books_df)}")
    print(f"   Interactions: {len(interactions_df)}")
    
    # Clean datasets
    courses_df = clean_courses(courses_df)
    books_df = clean_books(books_df)
    interactions_df = clean_interactions(interactions_df)
    
    print(f"\nCleaned data:")
    print(f"   Courses: {len(courses_df)}")
    print(f"   Books: {len(books_df)}")
    print(f"   Interactions: {len(interactions_df)}")
    
    # Save cleaned datasets
    courses_df.to_csv('data/courses_cleaned.csv', index=False)
    books_df.to_csv('data/books_cleaned.csv', index=False)
    interactions_df.to_csv('data/user_interactions_cleaned.csv', index=False)
    
    print("\n[OK] Cleaned datasets saved:")
    print("   - data/courses_cleaned.csv")
    print("   - data/books_cleaned.csv")
    print("   - data/user_interactions_cleaned.csv")

