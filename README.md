# Focus - Learning Companion App

A comprehensive Flutter application for course and book recommendations with user preferences and progress tracking. Built with Clean Architecture, Firebase Authentication, and Firestore for data persistence.

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

### Firebase Setup
- Firebase Authentication enabled
- Firestore database configured
- Firebase Storage configured
- Platform support: Android, iOS, Web

## 📁 Project Structure

```
lib/
├── core/
│   ├── di/
│   │   └── service_locator.dart          # Dependency injection setup
│   ├── error/
│   │   └── failure.dart                  # Error handling
│   └── router/
│       └── app_router.dart               # Navigation routing
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── firebase_auth_datasource.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── auth_user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_current_user.dart
│   │   │       ├── send_password_reset_email.dart
│   │   │       ├── sign_in_with_email.dart
│   │   │       ├── sign_out.dart
│   │   │       ├── sign_up_with_email.dart
│   │   │       └── watch_auth_state.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── auth_cubit.dart
│   │       │   ├── login_cubit.dart
│   │       │   ├── signup_cubit.dart
│   │       │   └── reset_password_cubit.dart
│   │       └── pages/
│   │           ├── login_page.dart
│   │           ├── sign_up_page.dart
│   │           └── forgot_password_page.dart
│   ├── profile/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── profile_remote_datasource.dart
│   │   │   └── repositories/
│   │   │       └── profile_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_profile.dart
│   │   │   └── repositories/
│   │   │       └── profile_repository.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── profile_cubit.dart
│   │       │   └── profile_state.dart
│   │       └── pages/
│   │           └── edit_profile_page.dart
│   └── content/
│       ├── domain/
│       │   └── entities/
│       │       ├── course.dart
│       │       └── book.dart
│       └── presentation/
│           ├── pages/
│           │   ├── main_navigation_page.dart
│           │   ├── home_page.dart
│           │   ├── courses_page.dart
│           │   ├── books_page.dart
│           │   ├── progress_page.dart
│           │   ├── profile_page.dart
│           │   ├── course_detail_page.dart
│           │   └── book_detail_page.dart
│           └── widgets/
│               ├── animated_progress_indicator.dart
│               └── animated_circular_progress.dart
├── app.dart                                 # Root app widget
└── main.dart                                # App entry point
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Firebase account
- Android Studio / VS Code with Flutter extensions

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd focus
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password)
   - Create Firestore database
   - Enable Storage
   - Run `flutterfire configure` to set up Firebase
   - Ensure `firebase_options.dart` is properly configured

4. **Run the app**
   ```bash
   flutter run
   ```

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
- Personalized course recommendations
- Book recommendations based on interests
- Continue learning section
- Quick stats overview

## 🎯 Future Enhancements

- [ ] Real-time course/book data from Firestore
- [ ] Push notifications
- [ ] Social features (sharing, reviews)
- [ ] Offline support
- [ ] Dark mode
- [ ] Multiple language support
- [ ] Advanced filtering and sorting
- [ ] Course/book favorites
- [ ] Learning paths
- [ ] Certificates generation

## 📄 License

This project is private and not licensed for public use.

## 👥 Contributors

- Development Team

## 📞 Support

For support, email support@focus.app or create an issue in the repository.

---

**Built with ❤️ using Flutter and Firebase**
