"""
Recommendation engine for courses and books
"""
import pandas as pd
import numpy as np
import joblib
from typing import List, Dict

class RecommendationEngine:
    def __init__(self):
        """Initialize recommendation engine with trained models"""
        try:
            # Load course models
            self.course_vectorizer = joblib.load('models/course_vectorizer.pkl')
            self.course_similarity = joblib.load('models/course_similarity.pkl')
            self.courses_df = joblib.load('models/courses_df.pkl')
            self.user_item_matrix = joblib.load('models/user_item_matrix.pkl')
            
            # Load book models
            self.book_vectorizer = joblib.load('models/book_vectorizer.pkl')
            self.book_similarity = joblib.load('models/book_similarity.pkl')
            self.books_df = joblib.load('models/books_df.pkl')
            self.book_user_item_matrix = joblib.load('models/book_user_item_matrix.pkl')
            
            print("[OK] Recommendation models loaded successfully")
        except FileNotFoundError as e:
            print(f"[ERROR] Error loading models: {e}")
            print("Please run train_model.py first")
            raise
    
    def get_course_recommendations(
        self,
        user_id: str = None,
        course_id: str = None,
        category: str = None,
        level: str = None,
        limit: int = 10
    ) -> List[Dict]:
        """Get course recommendations"""
        # Filter by category and level if provided
        filtered_df = self.courses_df.copy()
        if category:
            filtered_df = filtered_df[filtered_df['category'] == category]
        if level:
            filtered_df = filtered_df[filtered_df['level'] == level]
        
        if len(filtered_df) == 0:
            filtered_df = self.courses_df.copy()
        
        # If user_id provided, use collaborative filtering
        if user_id and user_id in self.user_item_matrix.index:
            user_ratings = self.user_item_matrix.loc[user_id]
            rated_items = user_ratings[user_ratings > 0].index.tolist()
            
            # Get unrated items
            unrated_items = filtered_df[~filtered_df['id'].isin(rated_items)]
            
            if len(unrated_items) > 0:
                # Predict ratings using similarity
                recommendations = []
                for item_id in unrated_items['id']:
                    if item_id in self.courses_df['id'].values:
                        item_idx = self.courses_df[self.courses_df['id'] == item_id].index[0]
                        similar_items = self.course_similarity[item_idx]
                        
                        # Weight by user's ratings
                        predicted_rating = 0
                        total_similarity = 0
                        
                        for rated_item in rated_items:
                            if rated_item in self.courses_df['id'].values:
                                rated_idx = self.courses_df[self.courses_df['id'] == rated_item].index[0]
                                similarity = similar_items[rated_idx]
                                if similarity > 0:
                                    predicted_rating += similarity * user_ratings[rated_item]
                                    total_similarity += similarity
                        
                        if total_similarity > 0:
                            predicted_rating /= total_similarity
                        else:
                            predicted_rating = filtered_df[filtered_df['id'] == item_id]['rating'].values[0]
                        
                        recommendations.append({
                            'item_id': item_id,
                            'score': predicted_rating
                        })
                
                # Sort by score and get top recommendations
                recommendations.sort(key=lambda x: x['score'], reverse=True)
                top_items = [r['item_id'] for r in recommendations[:limit]]
                
                result_df = filtered_df[filtered_df['id'].isin(top_items)]
            else:
                # Fallback to content-based
                result_df = filtered_df.nlargest(limit, 'rating')
        elif course_id and course_id in self.courses_df['id'].values:
            # Content-based: similar courses
            item_idx = self.courses_df[self.courses_df['id'] == course_id].index[0]
            similar_indices = np.argsort(self.course_similarity[item_idx])[::-1][1:limit+1]
            result_df = self.courses_df.iloc[similar_indices]
        else:
            # Default: top rated courses
            result_df = filtered_df.nlargest(limit, 'rating')
        
        # Convert to list of dicts
        return result_df.to_dict('records')
    
    def get_book_recommendations(
        self,
        user_id: str = None,
        book_id: str = None,
        category: str = None,
        limit: int = 10
    ) -> List[Dict]:
        """Get book recommendations"""
        # Filter by category if provided
        filtered_df = self.books_df.copy()
        if category:
            filtered_df = filtered_df[filtered_df['category'] == category]
        
        if len(filtered_df) == 0:
            filtered_df = self.books_df.copy()
        
        # If user_id provided, use collaborative filtering
        if user_id and user_id in self.book_user_item_matrix.index:
            user_ratings = self.book_user_item_matrix.loc[user_id]
            rated_items = user_ratings[user_ratings > 0].index.tolist()
            
            # Get unrated items
            unrated_items = filtered_df[~filtered_df['id'].isin(rated_items)]
            
            if len(unrated_items) > 0:
                # Predict ratings using similarity
                recommendations = []
                for item_id in unrated_items['id']:
                    if item_id in self.books_df['id'].values:
                        item_idx = self.books_df[self.books_df['id'] == item_id].index[0]
                        similar_items = self.book_similarity[item_idx]
                        
                        # Weight by user's ratings
                        predicted_rating = 0
                        total_similarity = 0
                        
                        for rated_item in rated_items:
                            if rated_item in self.books_df['id'].values:
                                rated_idx = self.books_df[self.books_df['id'] == rated_item].index[0]
                                similarity = similar_items[rated_idx]
                                if similarity > 0:
                                    predicted_rating += similarity * user_ratings[rated_item]
                                    total_similarity += similarity
                        
                        if total_similarity > 0:
                            predicted_rating /= total_similarity
                        else:
                            predicted_rating = filtered_df[filtered_df['id'] == item_id]['rating'].values[0]
                        
                        recommendations.append({
                            'item_id': item_id,
                            'score': predicted_rating
                        })
                
                # Sort by score and get top recommendations
                recommendations.sort(key=lambda x: x['score'], reverse=True)
                top_items = [r['item_id'] for r in recommendations[:limit]]
                
                result_df = filtered_df[filtered_df['id'].isin(top_items)]
            else:
                # Fallback to content-based
                result_df = filtered_df.nlargest(limit, 'rating')
        elif book_id and book_id in self.books_df['id'].values:
            # Content-based: similar books
            item_idx = self.books_df[self.books_df['id'] == book_id].index[0]
            similar_indices = np.argsort(self.book_similarity[item_idx])[::-1][1:limit+1]
            result_df = self.books_df.iloc[similar_indices]
        else:
            # Default: top rated books
            result_df = filtered_df.nlargest(limit, 'rating')
        
        # Convert to list of dicts
        return result_df.to_dict('records')

