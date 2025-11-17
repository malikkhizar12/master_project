# Focus Learning Backend API

Python FastAPI backend for the Focus Learning mobile app, providing courses, books, and ML-powered recommendations.

## Setup Instructions

### 1. Create Virtual Environment (if not already done)

```bash
cd backend_python
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# Mac/Linux:
source venv/bin/activate
```

### 2. Install Dependencies

```bash
pip install -r ../requirements.txt
```

### 3. Create Data Directory

```bash
mkdir data
mkdir models
```

### 4. Generate Dummy Data

```bash
python create_dummy_data.py
```

This will create:
- `data/courses.csv` - 50 dummy courses
- `data/books.csv` - 50 dummy books
- `data/user_interactions.csv` - User interaction data

### 5. Clean the Data

```bash
python clean_data.py
```

This will create cleaned versions:
- `data/courses_cleaned.csv`
- `data/books_cleaned.csv`
- `data/user_interactions_cleaned.csv`

### 6. Train Recommendation Models

```bash
python train_model.py
```

This will create trained models in the `models/` directory:
- `models/course_vectorizer.pkl`
- `models/course_similarity.pkl`
- `models/courses_df.pkl`
- `models/user_item_matrix.pkl`
- `models/book_vectorizer.pkl`
- `models/book_similarity.pkl`
- `models/books_df.pkl`
- `models/book_user_item_matrix.pkl`

### 7. Run the API Server

```bash
python main.py
```

Or using uvicorn directly:

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

The API will be available at: `http://localhost:8000`

## API Endpoints

### Courses
- `GET /courses` - Get all courses (supports category, level, search filters)
- `GET /courses/{course_id}` - Get course by ID
- `GET /courses/enrolled` - Get enrolled courses
- `POST /courses/{course_id}/enroll` - Enroll in a course

### Books
- `GET /books` - Get all books (supports category, search filters)
- `GET /books/{book_id}` - Get book by ID
- `GET /books/reading` - Get books currently being read
- `POST /books/{book_id}/start-reading` - Start reading a book

### Recommendations
- `GET /recommendations` - Get general recommendations (courses)
- `GET /recommendations/courses` - Get recommended courses
- `GET /recommendations/books` - Get recommended books

### Progress
- `GET /progress` - Get user progress
- `GET /progress/statistics` - Get user statistics

## API Documentation

Once the server is running, visit:
- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

## Integration with Flutter App

Update `lib/core/network/api_constants.dart` in your Flutter app:

```dart
static const String baseUrl = 'http://localhost:8000';
```

For web, you may need to use:
```dart
static const String baseUrl = 'http://127.0.0.1:8000';
```

## File Structure

```
backend_python/
├── main.py                    # FastAPI application
├── create_dummy_data.py       # Generate dummy datasets
├── clean_data.py              # Clean and preprocess data
├── train_model.py             # Train recommendation models
├── recommendation_engine.py   # Recommendation engine
├── data/                      # CSV datasets
│   ├── courses.csv
│   ├── books.csv
│   ├── user_interactions.csv
│   └── *_cleaned.csv
├── models/                    # Trained ML models
│   ├── course_*.pkl
│   └── book_*.pkl
└── README.md
```

## Notes

- The recommendation engine uses content-based filtering with TF-IDF and cosine similarity
- User-based collaborative filtering is also implemented for personalized recommendations
- All endpoints return data in the format expected by the Flutter app
- CORS is enabled for all origins (update in production)


