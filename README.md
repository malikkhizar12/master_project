# Focus - Learning Companion App

A comprehensive Flutter application for course and book recommendations with user preferences and progress tracking. Built with Clean Architecture, Firebase Authentication, Firestore for data persistence, and a Python FastAPI backend with ML-powered recommendation engine.

## 📱 Features

### Authentication
- **Email Authentication**: Complete email-based authentication system
  - User registration with email and password
  - User login
  - Password reset functionality
  - Secure session management
  - Firebase Authentication integration

### User Profile Management
- **Complete Profile System**:
  - Full name
  - University/Educational institution
  - Educational details (degree, major, year, etc.)
  - Profile picture upload (from gallery or camera)
  - Multiple interests selection
  - Profile data saved to Firestore
  - Profile picture stored in Firebase Storage

### Content Management
- **Courses**:
  - Browse available courses
  - Course details page with full information
  - Course recommendations based on preferences
  - Search and filter functionality
  - Progress tracking for enrolled courses
  - Course categories and difficulty levels

- **Books**:
  - Browse available books
  - Book details page
  - Book recommendations
  - Search functionality
  - Reading progress tracking
  - Book categories and metadata

### Progress Tracking
- **Comprehensive Progress Dashboard**:
  - Overall progress visualization with animated circular progress indicator
  - Statistics cards (Completed, In Progress, Certificates, Streak)
  - Courses in progress with animated progress bars
  - Books in progress tracking
  - Achievements system
  - Beautiful animations for all progress indicators

### Navigation
- **Bottom Navigation Bar** with 5 main sections:
  - Home: Dashboard with recommendations
  - Courses: All available courses
  - Books: All available books
  - Progress: User progress and achievements
  - Profile: User profile and settings

## 🏗️ Architecture

The app follows **Clean Architecture** principles with clear separation of concerns:

### Domain Layer
- **Entities**: Core business objects
  - `AuthUser`: User authentication entity
  - `UserProfile`: User profile entity
  - `Course`: Course entity
  - `Book`: Book entity

- **Repositories**: Abstract interfaces for data operations
  - `AuthRepository`: Authentication operations
  - `ProfileRepository`: Profile management operations

- **Use Cases**: Business logic operations
  - `SignInWithEmail`
  - `SignUpWithEmail`
  - `SignOut`
  - `SendPasswordResetEmail`
  - `GetCurrentUser`
  - `WatchAuthState`

### Data Layer
- **Data Sources**: Firebase implementations
  - `FirebaseAuthRemoteDataSource`: Firebase Auth integration
  - `FirebaseProfileRemoteDataSource`: Firestore and Storage integration

- **Repository Implementations**: Concrete implementations
  - `AuthRepositoryImpl`
  - `ProfileRepositoryImpl`

### Presentation Layer
- **State Management**: BLoC/Cubit pattern
  - `AuthCubit`: Global authentication state
  - `LoginCubit`: Login page state
  - `SignUpCubit`: Signup page state
  - `ResetPasswordCubit`: Password reset state
  - `ProfileCubit`: Profile management state

- **Pages**:
  - Authentication pages (Login, Signup, Forgot Password)
  - Main navigation with bottom bar
  - Home page with recommendations
  - Courses listing and detail pages
  - Books listing and detail pages
  - Progress tracking page
  - Profile page with edit functionality

- **Widgets**:
  - `AnimatedProgressIndicator`: Animated linear progress bar
  - `AnimatedCircularProgress`: Animated circular progress indicator

## 🎨 UI/UX Features

### Design
- **Material Design 3**: Modern Material Design implementation
- **Attractive Color Scheme**:
  - Primary: Indigo (#6366F1)
  - Secondary: Purple (#8B5CF6)
  - Tertiary: Pink (#EC4899)
  - Custom color palette for consistent theming

### Animations
- **Page Transitions**: Smooth fade-upwards and Cupertino transitions
- **Progress Animations**: 
  - Animated circular progress indicators
  - Animated linear progress bars
  - Staggered animations for statistics cards
  - Slide-in animations for list items
  - Scale animations for achievement cards

### User Experience
- **Form Validation**: Complete form validation using Formz
- **Error Handling**: User-friendly error messages
- **Loading States**: Visual feedback during async operations
- **Empty States**: Helpful messages when no data is available
- **Search Functionality**: Real-time search for courses and books
- **Filter Options**: Category and level filters for courses

## 🔧 Technical Stack

### Dependencies
- **Flutter SDK**: ^3.9.2
- **Firebase**:
  - `firebase_core`: ^3.15.2
  - `firebase_auth`: ^5.3.1
  - `cloud_firestore`: ^5.5.0
  - `firebase_storage`: ^12.3.4

- **State Management**:
  - `bloc`: ^9.1.0
  - `flutter_bloc`: ^9.0.0

- **Dependency Injection**:
  - `get_it`: ^7.7.0

- **Form Validation**:
  - `formz`: ^0.7.0

- **Utilities**:
  - `equatable`: ^2.0.5
  - `image_picker`: ^1.1.2
  - `http`: ^1.2.2

### Backend (Python FastAPI)
- **FastAPI**: ^0.121.1 - Modern, fast web framework
- **Machine Learning Libraries**:
  - `scikit-learn`: ^1.7.2 - ML algorithms for recommendations
  - `pandas`: ^2.3.3 - Data manipulation
  - `numpy`: ^2.3.4 - Numerical computing
  - `joblib`: ^1.5.2 - Model serialization
- **API Server**: `uvicorn` - ASGI server
- **CORS**: Enabled for cross-origin requests

### Firebase Setup
- Firebase Authentication enabled
- Firestore database configured
- Firebase Storage configured
- Platform support: Android, iOS, Web

## 📁 Project Structure

```
focus/
├── lib/                                    # Flutter application code
│   ├── core/
│   │   ├── di/
│   │   │   └── service_locator.dart          # Dependency injection setup
│   │   ├── error/
│   │   │   └── failure.dart                  # Error handling
│   │   ├── network/
│   │   │   ├── api_client.dart                # HTTP client for API calls
│   │   │   └── api_constants.dart             # API endpoints and constants
│   │   └── router/
│   │       └── app_router.dart               # Navigation routing
│   ├── features/
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── firebase_auth_datasource.dart
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── auth_user.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_current_user.dart
│   │   │   │       ├── send_password_reset_email.dart
│   │   │   │       ├── sign_in_with_email.dart
│   │   │   │       ├── sign_out.dart
│   │   │   │       ├── sign_up_with_email.dart
│   │   │   │       └── watch_auth_state.dart
│   │   │   └── presentation/
│   │   │       ├── cubit/
│   │   │       │   ├── auth_cubit.dart
│   │   │       │   ├── login_cubit.dart
│   │   │       │   ├── signup_cubit.dart
│   │   │       │   └── reset_password_cubit.dart
│   │   │       └── pages/
│   │   │           ├── login_page.dart
│   │   │           ├── sign_up_page.dart
│   │   │           └── forgot_password_page.dart
│   │   ├── profile/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── profile_remote_datasource.dart
│   │   │   │   └── repositories/
│   │   │   │       └── profile_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── user_profile.dart
│   │   │   │   └── repositories/
│   │   │   │       └── profile_repository.dart
│   │   │   └── presentation/
│   │   │       ├── cubit/
│   │   │       │   ├── profile_cubit.dart
│   │   │       │   └── profile_state.dart
│   │   │       └── pages/
│   │   │           └── edit_profile_page.dart
│   │   └── content/
│   │       ├── data/
│   │       │   └── datasources/
│   │       │       ├── course_remote_datasource.dart
│   │       │       ├── book_remote_datasource.dart
│   │       │       └── progress_remote_datasource.dart
│   │       ├── domain/
│   │       │   └── entities/
│   │       │       ├── course.dart
│   │       │       └── book.dart
│   │       └── presentation/
│   │           ├── pages/
│   │           │   ├── main_navigation_page.dart
│   │           │   ├── home_page.dart
│   │           │   ├── courses_page.dart
│   │           │   ├── books_page.dart
│   │           │   ├── progress_page.dart
│   │           │   ├── profile_page.dart
│   │           │   ├── course_detail_page.dart
│   │           │   └── book_detail_page.dart
│   │           └── widgets/
│   │               ├── animated_progress_indicator.dart
│   │               └── animated_circular_progress.dart
│   ├── app.dart                                 # Root app widget
│   └── main.dart                                # App entry point
│
├── backend_python/                            # Python FastAPI backend
│   ├── main.py                                # FastAPI application entry point
│   ├── recommendation_engine.py              # ML recommendation engine
│   ├── train_model.py                         # Model training script
│   ├── create_dummy_data.py                   # Generate dummy datasets
│   ├── clean_data.py                          # Data cleaning and preprocessing
│   ├── setup_and_run.py                       # One-command setup script
│   ├── data/                                  # CSV datasets
│   │   ├── courses.csv
│   │   ├── books.csv
│   │   ├── user_interactions.csv
│   │   ├── courses_cleaned.csv
│   │   ├── books_cleaned.csv
│   │   └── user_interactions_cleaned.csv
│   ├── models/                                # Trained ML models (generated)
│   │   ├── course_vectorizer.pkl
│   │   ├── course_similarity.pkl
│   │   ├── courses_df.pkl
│   │   ├── user_item_matrix.pkl
│   │   ├── book_vectorizer.pkl
│   │   ├── book_similarity.pkl
│   │   ├── books_df.pkl
│   │   └── book_user_item_matrix.pkl
│   ├── README.md                              # Backend documentation
│   └── QUICK_START.md                         # Quick start guide
│
├── android/                                   # Android platform code
├── ios/                                      # iOS platform code
├── web/                                      # Web platform code
├── pubspec.yaml                              # Flutter dependencies
├── requirements.txt                          # Python dependencies
└── README.md                                 # This file
```

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK** (3.9.2 or higher)
- **Dart SDK**
- **Python 3.8+** (for backend)
- **Firebase account**
- **Android Studio / VS Code** with Flutter extensions

### Setup Instructions

#### 1. Clone the Repository
```bash
git clone <repository-url>
cd focus
```

#### 2. Backend Setup (Python FastAPI)

The backend provides the API endpoints and ML-powered recommendation engine.

**Option A: One-Command Setup (Recommended)**
```bash
cd backend_python
python setup_and_run.py
```

This will automatically:
- Create dummy datasets (courses, books, user interactions)
- Clean and preprocess the data
- Train recommendation models

**Option B: Manual Setup**
```bash
cd backend_python

# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate
# Mac/Linux:
source venv/bin/activate

# Install dependencies
pip install -r ../requirements.txt

# Create data and models directories
mkdir data models

# Generate dummy data
python create_dummy_data.py

# Clean data
python clean_data.py

# Train models
python train_model.py
```

**Start the Backend Server**
```bash
# From backend_python directory
python main.py
```

Or with auto-reload:
```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

The API will be available at:
- **API Base URL**: `http://localhost:8000`
- **Swagger UI**: `http://localhost:8000/docs`
- **ReDoc**: `http://localhost:8000/redoc`

#### 3. Flutter App Setup

**Install Flutter Dependencies**
```bash
# From project root
flutter pub get
```

**Configure API Connection**

The Flutter app is pre-configured to connect to `http://127.0.0.1:8000`. If you need to change the backend URL, update `lib/core/network/api_constants.dart`:

```dart
static const String baseUrl = 'http://127.0.0.1:8000';
```

**Firebase Configuration**
- Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
- Enable Authentication (Email/Password)
- Create Firestore database
- Enable Storage
- Run `flutterfire configure` to set up Firebase
- Ensure `firebase_options.dart` is properly configured

#### 4. Run the Application

**Start Backend First** (in one terminal):
```bash
cd backend_python
python main.py
```

**Run Flutter App** (in another terminal):
```bash
# From project root
flutter run
```

For web:
```bash
flutter run -d chrome
```

For Android emulator, update API URL to `http://10.0.2.2:8000` in `api_constants.dart`

### Firebase Setup Details

1. **Authentication**:
   - Go to Firebase Console > Authentication
   - Enable Email/Password sign-in method

2. **Firestore**:
   - Create a Firestore database
   - Set up security rules (for development, you can use test mode)
   - Collection: `user_profiles` will be created automatically

3. **Storage**:
   - Enable Firebase Storage
   - Set up storage rules for profile pictures
   - Path: `profile_pictures/{userId}.jpg`

## 📝 Key Features Implementation

### Profile Management
- Users can edit their profile from the Profile page
- Profile picture can be selected from gallery or camera
- All profile data is saved to Firestore
- Profile picture is uploaded to Firebase Storage
- Real-time profile updates

### Progress Tracking
- Visual progress indicators with animations
- Course progress tracking
- Book reading progress
- Achievement system
- Statistics dashboard

### Recommendations
- **ML-Powered Recommendations**: 
  - Content-based filtering using TF-IDF vectorization and cosine similarity
  - Collaborative filtering based on user-item interactions
  - Personalized course and book recommendations
  - Category and level-based filtering
- Continue learning section
- Quick stats overview

## 🤖 Machine Learning & Recommendation Engine

### Recommendation Algorithms

The backend uses advanced ML techniques to provide personalized recommendations:

1. **Content-Based Filtering**:
   - Uses TF-IDF (Term Frequency-Inverse Document Frequency) vectorization
   - Analyzes course/book features: title, description, category, instructor/author
   - Computes cosine similarity between items
   - Recommends items similar to user's preferences

2. **Collaborative Filtering**:
   - User-item matrix construction from interaction data
   - Predicts ratings based on similar users' preferences
   - Handles cold-start problem with content-based fallback

3. **Hybrid Approach**:
   - Combines both content-based and collaborative filtering
   - Provides more accurate and diverse recommendations
   - Falls back to top-rated items when user data is insufficient

### Model Training

The recommendation models are trained using:
- **TF-IDF Vectorizer**: Extracts features from text (max_features=1000, ngram_range=(1,2))
- **Cosine Similarity**: Measures similarity between items
- **User-Item Matrix**: Tracks user interactions and ratings
- **Scikit-learn**: Machine learning library for model training

Models are saved as `.pkl` files and loaded at runtime for fast recommendations.

## 🔌 Backend API

### API Endpoints

#### Courses
- `GET /courses` - Get all courses
  - Query params: `category`, `level`, `search`, `limit`, `offset`
- `GET /courses/{course_id}` - Get course by ID
- `GET /courses/enrolled` - Get enrolled courses
- `POST /courses/{course_id}/enroll` - Enroll in a course

#### Books
- `GET /books` - Get all books
  - Query params: `category`, `search`, `limit`, `offset`
- `GET /books/{book_id}` - Get book by ID
- `GET /books/reading` - Get books currently being read
- `POST /books/{book_id}/start-reading` - Start reading a book

#### Recommendations
- `GET /recommendations` - Get general recommendations (courses)
  - Query params: `user_id`, `limit`
- `GET /recommendations/courses` - Get recommended courses
  - Query params: `user_id`, `category`, `level`, `limit`
- `GET /recommendations/books` - Get recommended books
  - Query params: `user_id`, `category`, `limit`

#### Progress
- `GET /progress` - Get user progress
- `GET /progress/statistics` - Get user statistics

### API Features
- **CORS Enabled**: Cross-origin requests allowed for Flutter web
- **Pagination**: Support for limit/offset pagination
- **Filtering**: Category, level, and search filters
- **Error Handling**: Comprehensive error responses
- **Auto Documentation**: Swagger UI and ReDoc available

### Data Pipeline

1. **Data Generation** (`create_dummy_data.py`):
   - Generates 50 courses with metadata
   - Generates 50 books with metadata
   - Creates user interaction data (ratings, completions, time spent)

2. **Data Cleaning** (`clean_data.py`):
   - Removes duplicates
   - Handles missing values
   - Validates and normalizes data
   - Creates cleaned CSV files

3. **Model Training** (`train_model.py`):
   - Trains TF-IDF vectorizers for courses and books
   - Computes similarity matrices
   - Builds user-item matrices
   - Saves trained models as `.pkl` files

4. **API Serving** (`main.py`):
   - Loads trained models
   - Serves recommendations via REST API
   - Handles real-time queries

## 🔧 Troubleshooting

### Backend Issues

**Port Already in Use**
- Change port in `backend_python/main.py`:
  ```python
  uvicorn.run(app, host="0.0.0.0", port=8001)
  ```
- Update Flutter `api_constants.dart` accordingly

**Models Not Found**
- Run `python setup_and_run.py` or `python train_model.py`
- Ensure `models/` directory contains all `.pkl` files

**CORS Issues**
- CORS is enabled for all origins in development
- For production, update CORS settings in `main.py`

**Data Not Loading**
- Ensure `data/` directory contains CSV files
- Run `python create_dummy_data.py` if files are missing

### Flutter App Issues

**API Connection Failed**
- Ensure backend is running on `http://localhost:8000`
- Check `api_constants.dart` for correct base URL
- For Android emulator, use `http://10.0.2.2:8000`
- For iOS simulator, use `http://localhost:8000`

**Firebase Errors**
- Verify `firebase_options.dart` is configured
- Check Firebase project settings
- Ensure Authentication, Firestore, and Storage are enabled

## 🎯 Future Enhancements

- [ ] Real-time course/book data from Firestore
- [ ] User authentication in backend API
- [ ] Persistent user progress tracking
- [ ] Advanced ML models (deep learning, neural networks)
- [ ] Push notifications
- [ ] Social features (sharing, reviews)
- [ ] Offline support
- [ ] Dark mode
- [ ] Multiple language support
- [ ] Advanced filtering and sorting
- [ ] Course/book favorites
- [ ] Learning paths
- [ ] Certificates generation
- [ ] Real-time collaboration features

## 📄 License

This project is private and not licensed for public use.

## 👥 Contributors

- Development Team

## 📞 Support

For support, email support@focus.app or create an issue in the repository.

---

## 📚 Additional Documentation

- **Backend Documentation**: See `backend_python/README.md` for detailed backend setup
- **Quick Start Guide**: See `backend_python/QUICK_START.md` for one-command setup

## 🔗 Useful Links

- [Flutter Documentation](https://flutter.dev/docs)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Scikit-learn Documentation](https://scikit-learn.org/)

---

**Built with ❤️ using Flutter, Firebase, and Python FastAPI**
