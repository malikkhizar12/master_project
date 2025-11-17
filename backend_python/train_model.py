"""
Train recommendation model using content-based filtering
"""
import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import joblib
import os
import sys
import io

# Fix encoding for Windows console
if sys.platform == 'win32':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

def train_course_recommendation_model():
    """Train recommendation model for courses"""
    print("[*] Loading data...")
    
    # Load cleaned data
    courses_df = pd.read_csv('data/courses_cleaned.csv')
    interactions_df = pd.read_csv('data/user_interactions_cleaned.csv')
    
    print(f"   Courses: {len(courses_df)}")
    print(f"   Interactions: {len(interactions_df)}")
    
    # Create feature text for each course
    courses_df['feature_text'] = (
        courses_df['title'] + ' ' +
        courses_df['description'] + ' ' +
        courses_df['category'] + ' ' +
        courses_df['level'] + ' ' +
        courses_df['instructor']
    )
    
    print("\n[*] Training TF-IDF vectorizer...")
    # Create TF-IDF vectorizer
    vectorizer = TfidfVectorizer(
        max_features=1000,
        stop_words='english',
        ngram_range=(1, 2)
    )
    
    # Fit and transform
    tfidf_matrix = vectorizer.fit_transform(courses_df['feature_text'])
    
    print("[*] Computing similarity matrix...")
    # Compute cosine similarity
    similarity_matrix = cosine_similarity(tfidf_matrix, tfidf_matrix)
    
    # Create user-item matrix for collaborative filtering
    print("[*] Building user-item matrix...")
    user_item_matrix = interactions_df.pivot_table(
        index='user_id',
        columns='item_id',
        values='rating',
        aggfunc='mean'
    ).fillna(0)
    
    # Save models
    os.makedirs('models', exist_ok=True)
    
    joblib.dump(vectorizer, 'models/course_vectorizer.pkl')
    joblib.dump(similarity_matrix, 'models/course_similarity.pkl')
    joblib.dump(courses_df, 'models/courses_df.pkl')
    joblib.dump(user_item_matrix, 'models/user_item_matrix.pkl')
    
    print("\n[OK] Models saved:")
    print("   - models/course_vectorizer.pkl")
    print("   - models/course_similarity.pkl")
    print("   - models/courses_df.pkl")
    print("   - models/user_item_matrix.pkl")
    
    return vectorizer, similarity_matrix, courses_df, user_item_matrix

def train_book_recommendation_model():
    """Train recommendation model for books"""
    print("\n[*] Training book recommendation model...")
    
    # Load cleaned data
    books_df = pd.read_csv('data/books_cleaned.csv')
    interactions_df = pd.read_csv('data/user_interactions_cleaned.csv')
    
    # Filter book interactions
    book_interactions = interactions_df[interactions_df['item_type'] == 'book']
    
    print(f"   Books: {len(books_df)}")
    print(f"   Book interactions: {len(book_interactions)}")
    
    # Create feature text for each book
    books_df['feature_text'] = (
        books_df['title'] + ' ' +
        books_df['description'] + ' ' +
        books_df['category'] + ' ' +
        books_df['author']
    )
    
    print("[*] Training TF-IDF vectorizer for books...")
    # Create TF-IDF vectorizer
    vectorizer = TfidfVectorizer(
        max_features=1000,
        stop_words='english',
        ngram_range=(1, 2)
    )
    
    # Fit and transform
    tfidf_matrix = vectorizer.fit_transform(books_df['feature_text'])
    
    print("[*] Computing similarity matrix for books...")
    # Compute cosine similarity
    similarity_matrix = cosine_similarity(tfidf_matrix, tfidf_matrix)
    
    # Create user-item matrix for books
    print("[*] Building user-item matrix for books...")
    user_item_matrix = book_interactions.pivot_table(
        index='user_id',
        columns='item_id',
        values='rating',
        aggfunc='mean'
    ).fillna(0)
    
    # Save models
    joblib.dump(vectorizer, 'models/book_vectorizer.pkl')
    joblib.dump(similarity_matrix, 'models/book_similarity.pkl')
    joblib.dump(books_df, 'models/books_df.pkl')
    joblib.dump(user_item_matrix, 'models/book_user_item_matrix.pkl')
    
    print("\n[OK] Book models saved:")
    print("   - models/book_vectorizer.pkl")
    print("   - models/book_similarity.pkl")
    print("   - models/books_df.pkl")
    print("   - models/book_user_item_matrix.pkl")
    
    return vectorizer, similarity_matrix, books_df, user_item_matrix

if __name__ == '__main__':
    print("[*] Starting model training...\n")
    
    # Train course model
    train_course_recommendation_model()
    
    # Train book model
    train_book_recommendation_model()
    
    print("\n[OK] All models trained successfully!")

