# Quick Start Guide

## One-Command Setup

Run this single command to set up everything:

```bash
python setup_and_run.py
```

This will:
1. ✅ Create dummy datasets (courses, books, user interactions)
2. ✅ Clean the data
3. ✅ Train recommendation models

## Start the API Server

After setup, start the server:

```bash
python main.py
```

Or with auto-reload:

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

## Test the API

Visit: http://localhost:8000/docs to see the interactive API documentation.

Test endpoints:
- http://localhost:8000/courses
- http://localhost:8000/books
- http://localhost:8000/recommendations/courses

## Run Flutter App

The Flutter app is already configured to use `http://127.0.0.1:8000`.

Just run:
```bash
flutter run -d chrome
```

## Troubleshooting

### Port Already in Use
If port 8000 is busy, change it in `main.py`:
```python
uvicorn.run(app, host="0.0.0.0", port=8001)
```

And update Flutter `api_constants.dart`:
```dart
static const String baseUrl = 'http://127.0.0.1:8001';
```

### CORS Issues
CORS is already enabled for all origins. If you have issues, check the CORS middleware in `main.py`.

### Models Not Found
Make sure you ran `python setup_and_run.py` or `python train_model.py` to generate the models.


