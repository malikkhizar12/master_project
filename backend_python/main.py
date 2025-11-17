"""
FastAPI application for Focus Learning App
Provides courses, books, and recommendation endpoints
"""
from fastapi import FastAPI, Query, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import pandas as pd
from typing import Optional, List
import os
from recommendation_engine import RecommendationEngine

app = FastAPI(title="Focus Learning API", version="1.0.0")

# Enable CORS for Flutter web app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify your Flutter app URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize recommendation engine
try:
    engine = RecommendationEngine()
except Exception as e:
    print(f"Warning: Could not load recommendation engine: {e}")
    engine = None

# Load data
def load_courses():
    """Load courses data"""
    if os.path.exists('data/courses_cleaned.csv'):
        return pd.read_csv('data/courses_cleaned.csv')
    elif os.path.exists('data/courses.csv'):
        return pd.read_csv('data/courses.csv')
    else:
        return pd.DataFrame()

def load_books():
    """Load books data"""
    if os.path.exists('data/books_cleaned.csv'):
        return pd.read_csv('data/books_cleaned.csv')
    elif os.path.exists('data/books.csv'):
        return pd.read_csv('data/books.csv')
    else:
        return pd.DataFrame()

courses_df = load_courses()
books_df = load_books()

@app.get("/")
def root():
    """Root endpoint"""
    return {
        "message": "Focus Learning API",
        "version": "1.0.0",
        "endpoints": {
            "courses": "/courses",
            "books": "/books",
            "recommendations": "/recommendations"
        }
    }

@app.get("/courses")
def get_courses(
    category: Optional[str] = Query(None, description="Filter by category"),
    level: Optional[str] = Query(None, description="Filter by level"),
    search: Optional[str] = Query(None, description="Search in title and description"),
    limit: Optional[int] = Query(100, description="Limit results"),
    offset: Optional[int] = Query(0, description="Offset for pagination")
):
    """Get all courses with optional filtering"""
    try:
        filtered_df = courses_df.copy()
        
        # Apply filters
        if category and category != 'All':
            filtered_df = filtered_df[filtered_df['category'] == category]
        
        if level and level != 'All':
            filtered_df = filtered_df[filtered_df['level'] == level]
        
        if search:
            search_lower = search.lower()
            mask = (
                filtered_df['title'].str.lower().str.contains(search_lower, na=False) |
                filtered_df['description'].str.lower().str.contains(search_lower, na=False)
            )
            filtered_df = filtered_df[mask]
        
        # Pagination
        total = len(filtered_df)
        filtered_df = filtered_df.iloc[offset:offset+limit]
        
        # Convert to dict format expected by Flutter
        courses = filtered_df.to_dict('records')
        
        # Ensure all required fields are present
        for course in courses:
            course.setdefault('isFree', course.get('price', 0) == 0)
            course.setdefault('isEnrolled', False)
            course.setdefault('progress', 0.0)
        
        return {
            "data": courses,
            "total": total,
            "limit": limit,
            "offset": offset
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching courses: {str(e)}")

@app.get("/courses/{course_id}")
def get_course_by_id(course_id: str):
    """Get a specific course by ID"""
    try:
        course = courses_df[courses_df['id'] == course_id]
        
        if course.empty:
            raise HTTPException(status_code=404, detail="Course not found")
        
        course_dict = course.iloc[0].to_dict()
        course_dict.setdefault('isFree', course_dict.get('price', 0) == 0)
        course_dict.setdefault('isEnrolled', False)
        course_dict.setdefault('progress', 0.0)
        
        return {"data": course_dict}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching course: {str(e)}")

@app.get("/courses/enrolled")
def get_enrolled_courses():
    """Get enrolled courses (dummy implementation)"""
    # In a real app, this would filter by user_id from auth token
    # For now, return empty or sample data
    return {
        "data": [],
        "total": 0
    }

@app.post("/courses/{course_id}/enroll")
def enroll_in_course(course_id: str):
    """Enroll in a course"""
    try:
        course = courses_df[courses_df['id'] == course_id]
        
        if course.empty:
            raise HTTPException(status_code=404, detail="Course not found")
        
        # In a real app, save enrollment to database
        return {
            "message": "Successfully enrolled in course",
            "courseId": course_id
        }
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error enrolling in course: {str(e)}")

@app.get("/books")
def get_books(
    category: Optional[str] = Query(None, description="Filter by category"),
    search: Optional[str] = Query(None, description="Search in title and description"),
    limit: Optional[int] = Query(100, description="Limit results"),
    offset: Optional[int] = Query(0, description="Offset for pagination")
):
    """Get all books with optional filtering"""
    try:
        filtered_df = books_df.copy()
        
        # Apply filters
        if category and category != 'All':
            filtered_df = filtered_df[filtered_df['category'] == category]
        
        if search:
            search_lower = search.lower()
            mask = (
                filtered_df['title'].str.lower().str.contains(search_lower, na=False) |
                filtered_df['description'].str.lower().str.contains(search_lower, na=False) |
                filtered_df['author'].str.lower().str.contains(search_lower, na=False)
            )
            filtered_df = filtered_df[mask]
        
        # Pagination
        total = len(filtered_df)
        filtered_df = filtered_df.iloc[offset:offset+limit]
        
        # Convert to dict format
        books = filtered_df.to_dict('records')
        
        # Ensure all required fields are present
        for book in books:
            book.setdefault('isFree', book.get('price', 0) == 0)
            book.setdefault('isReading', False)
            book.setdefault('progress', 0.0)
        
        return {
            "data": books,
            "total": total,
            "limit": limit,
            "offset": offset
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching books: {str(e)}")

@app.get("/books/{book_id}")
def get_book_by_id(book_id: str):
    """Get a specific book by ID"""
    try:
        book = books_df[books_df['id'] == book_id]
        
        if book.empty:
            raise HTTPException(status_code=404, detail="Book not found")
        
        book_dict = book.iloc[0].to_dict()
        book_dict.setdefault('isFree', book_dict.get('price', 0) == 0)
        book_dict.setdefault('isReading', False)
        book_dict.setdefault('progress', 0.0)
        
        return {"data": book_dict}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching book: {str(e)}")

@app.get("/books/reading")
def get_reading_books():
    """Get books currently being read (dummy implementation)"""
    # In a real app, this would filter by user_id from auth token
    return {
        "data": [],
        "total": 0
    }

@app.post("/books/{book_id}/start-reading")
def start_reading(book_id: str):
    """Start reading a book"""
    try:
        book = books_df[books_df['id'] == book_id]
        
        if book.empty:
            raise HTTPException(status_code=404, detail="Book not found")
        
        # In a real app, save reading status to database
        return {
            "message": "Started reading book",
            "bookId": book_id
        }
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error starting to read: {str(e)}")

@app.get("/recommendations")
def get_recommendations(
    user_id: Optional[str] = Query(None, description="User ID for personalized recommendations"),
    limit: Optional[int] = Query(10, description="Number of recommendations")
):
    """Get general recommendations (courses)"""
    try:
        if engine:
            recommendations = engine.get_course_recommendations(
                user_id=user_id,
                limit=limit
            )
        else:
            # Fallback: top rated courses
            recommendations = courses_df.nlargest(limit, 'rating').to_dict('records')
        
        # Ensure required fields
        for rec in recommendations:
            rec.setdefault('isFree', rec.get('price', 0) == 0)
            rec.setdefault('isEnrolled', False)
            rec.setdefault('progress', 0.0)
        
        return {"data": recommendations}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error getting recommendations: {str(e)}")

@app.get("/recommendations/courses")
def get_recommended_courses(
    user_id: Optional[str] = Query(None, description="User ID for personalized recommendations"),
    category: Optional[str] = Query(None, description="Filter by category"),
    level: Optional[str] = Query(None, description="Filter by level"),
    limit: Optional[int] = Query(10, description="Number of recommendations")
):
    """Get recommended courses"""
    try:
        if engine:
            recommendations = engine.get_course_recommendations(
                user_id=user_id,
                category=category,
                level=level,
                limit=limit
            )
        else:
            # Fallback: top rated courses
            filtered_df = courses_df.copy()
            if category and category != 'All':
                filtered_df = filtered_df[filtered_df['category'] == category]
            if level and level != 'All':
                filtered_df = filtered_df[filtered_df['level'] == level]
            recommendations = filtered_df.nlargest(limit, 'rating').to_dict('records')
        
        # Ensure required fields
        for rec in recommendations:
            rec.setdefault('isFree', rec.get('price', 0) == 0)
            rec.setdefault('isEnrolled', False)
            rec.setdefault('progress', 0.0)
        
        return {"data": recommendations}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error getting course recommendations: {str(e)}")

@app.get("/recommendations/books")
def get_recommended_books(
    user_id: Optional[str] = Query(None, description="User ID for personalized recommendations"),
    category: Optional[str] = Query(None, description="Filter by category"),
    limit: Optional[int] = Query(10, description="Number of recommendations")
):
    """Get recommended books"""
    try:
        if engine:
            recommendations = engine.get_book_recommendations(
                user_id=user_id,
                category=category,
                limit=limit
            )
        else:
            # Fallback: top rated books
            filtered_df = books_df.copy()
            if category and category != 'All':
                filtered_df = filtered_df[filtered_df['category'] == category]
            recommendations = filtered_df.nlargest(limit, 'rating').to_dict('records')
        
        # Ensure required fields
        for rec in recommendations:
            rec.setdefault('isFree', rec.get('price', 0) == 0)
            rec.setdefault('isReading', False)
            rec.setdefault('progress', 0.0)
        
        return {"data": recommendations}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error getting book recommendations: {str(e)}")

@app.get("/progress")
def get_progress():
    """Get user progress (dummy implementation)"""
    return {
        "overallProgress": 0.0,
        "coursesCompleted": 0,
        "booksCompleted": 0,
        "totalTimeSpent": 0
    }

@app.get("/progress/statistics")
def get_statistics():
    """Get user statistics (dummy implementation)"""
    return {
        "completed": 0,
        "inProgress": 0,
        "certificates": 0,
        "streak": 0
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
