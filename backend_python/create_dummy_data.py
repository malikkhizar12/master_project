"""
Script to create dummy datasets for courses, books, and user interactions
"""
import pandas as pd
import random
import sys
import io
from datetime import datetime, timedelta

# Fix encoding for Windows console
if sys.platform == 'win32':
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')

# Set random seed for reproducibility
random.seed(42)

# Categories
course_categories = [
    "Programming", "Design", "Business", "Marketing", "Data Science",
    "Photography", "Music", "Writing", "Health", "Language"
]

book_categories = [
    "Programming", "Design", "Business", "Fiction", "Non-Fiction",
    "Science", "History", "Biography", "Self-Help", "Technology"
]

levels = ["Beginner", "Intermediate", "Advanced"]
languages = ["English", "Spanish", "French", "German", "Chinese"]

# Instructor names
instructors = [
    "Dr. Sarah Johnson", "Prof. Michael Chen", "Dr. Emily Rodriguez",
    "Prof. David Kim", "Dr. Lisa Anderson", "Prof. James Wilson",
    "Dr. Maria Garcia", "Prof. Robert Taylor", "Dr. Jennifer Brown",
    "Prof. Christopher Lee"
]

# Author names
authors = [
    "Robert C. Martin", "Martin Fowler", "Eric Evans", "Kent Beck",
    "Donald Knuth", "Steve McConnell", "Andy Hunt", "Dave Thomas",
    "Joshua Bloch", "Michael Feathers", "J.K. Rowling", "George Orwell",
    "Stephen King", "Jane Austen", "Mark Twain"
]

# Generate Courses
courses_data = []
for i in range(1, 51):  # 50 courses
    category = random.choice(course_categories)
    level = random.choice(levels)
    rating = round(random.uniform(3.5, 5.0), 1)
    enrolled = random.randint(50, 5000)
    duration_hours = random.choice([2, 4, 6, 8, 10, 12, 16, 20])
    
    courses_data.append({
        'id': f'course_{i}',
        'title': f'{category} Course {i}: {random.choice(["Master", "Complete", "Advanced", "Essential"])} Guide',
        'description': f'Learn {category.lower()} from scratch. This comprehensive course covers all essential topics and provides hands-on experience.',
        'instructor': random.choice(instructors),
        'duration': f'{duration_hours} hours',
        'rating': rating,
        'enrolledCount': enrolled,
        'imageUrl': f'https://picsum.photos/400/300?random={i}',
        'category': category,
        'level': level,
        'price': round(random.uniform(0, 199.99), 2) if random.random() > 0.3 else 0,
        'isFree': random.random() > 0.7,
    })

courses_df = pd.DataFrame(courses_data)
courses_df['isFree'] = courses_df['price'] == 0

# Generate Books
books_data = []
for i in range(1, 51):  # 50 books
    category = random.choice(book_categories)
    rating = round(random.uniform(3.5, 5.0), 1)
    pages = random.randint(150, 800)
    year = random.randint(1990, 2024)
    
    books_data.append({
        'id': f'book_{i}',
        'title': f'{category} Book {i}: {random.choice(["Complete", "Master", "Essential", "Advanced"])} Guide',
        'author': random.choice(authors),
        'description': f'An in-depth exploration of {category.lower()} concepts and practices. Perfect for both beginners and experienced professionals.',
        'rating': rating,
        'pageCount': pages,
        'imageUrl': f'https://picsum.photos/400/600?random={i+100}',
        'category': category,
        'language': random.choice(languages),
        'price': round(random.uniform(0, 49.99), 2) if random.random() > 0.2 else 0,
        'isFree': random.random() > 0.8,
        'publishedYear': year,
    })

books_df = pd.DataFrame(books_data)
books_df['isFree'] = books_df['price'] == 0

# Generate User Interactions
user_interactions = []
user_ids = [f'user_{i}' for i in range(1, 21)]  # 20 users

for user_id in user_ids:
    # Each user interacts with 5-15 courses
    num_courses = random.randint(5, 15)
    selected_courses = random.sample(courses_data, num_courses)
    
    for course in selected_courses:
        completed = random.random() > 0.4
        rating = random.randint(3, 5) if completed else random.randint(1, 4)
        time_spent = random.randint(30, duration_hours * 60) if completed else random.randint(10, duration_hours * 30)
        
        user_interactions.append({
            'user_id': user_id,
            'item_id': course['id'],
            'item_type': 'course',
            'rating': rating,
            'completed': completed,
            'time_spent_minutes': time_spent,
            'timestamp': (datetime.now() - timedelta(days=random.randint(0, 180))).isoformat(),
        })
    
    # Each user interacts with 3-10 books
    num_books = random.randint(3, 10)
    selected_books = random.sample(books_data, num_books)
    
    for book in selected_books:
        completed = random.random() > 0.5
        rating = random.randint(3, 5) if completed else random.randint(1, 4)
        pages_read = book['pageCount'] if completed else random.randint(10, book['pageCount'] // 2)
        
        user_interactions.append({
            'user_id': user_id,
            'item_id': book['id'],
            'item_type': 'book',
            'rating': rating,
            'completed': completed,
            'pages_read': pages_read,
            'timestamp': (datetime.now() - timedelta(days=random.randint(0, 180))).isoformat(),
        })

interactions_df = pd.DataFrame(user_interactions)

# Save to CSV
courses_df.to_csv('data/courses.csv', index=False)
books_df.to_csv('data/books.csv', index=False)
interactions_df.to_csv('data/user_interactions.csv', index=False)

print(f"[OK] Created {len(courses_df)} courses")
print(f"[OK] Created {len(books_df)} books")
print(f"[OK] Created {len(interactions_df)} user interactions")
print("\nFiles saved to data/ directory:")
print("   - data/courses.csv")
print("   - data/books.csv")
print("   - data/user_interactions.csv")

