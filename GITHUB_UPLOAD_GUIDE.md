# 📤 Guide to Upload Focus App to GitHub

This guide will walk you through uploading your Focus app to GitHub step by step.

## Prerequisites

1. **Git installed** on your computer
   - Check if installed: Open terminal/command prompt and type `git --version`
   - If not installed, download from: https://git-scm.com/downloads

2. **GitHub account**
   - Create one at: https://github.com/signup

## Step-by-Step Instructions

### Step 1: Create a New Repository on GitHub

1. Go to https://github.com and sign in
2. Click the **"+"** icon in the top right corner
3. Select **"New repository"**
4. Fill in the details:
   - **Repository name**: `focus-app` (or any name you prefer)
   - **Description**: "Learning companion app for courses and books with progress tracking"
   - **Visibility**: Choose **Private** (recommended) or **Public**
   - **DO NOT** check "Initialize this repository with a README" (we already have one)
   - **DO NOT** add .gitignore or license (we already have them)
5. Click **"Create repository"**

### Step 2: Initialize Git in Your Project

Open your terminal/command prompt and navigate to your project folder:

```bash
cd "C:\Users\malik\Desktop\Master project\focus"
```

Initialize git repository:

```bash
git init
```

### Step 3: Add All Files to Git

Add all project files:

```bash
git add .
```

**Note**: The `.gitignore` file will automatically exclude sensitive files like `google-services.json` and `firebase_options.dart` from being uploaded.

### Step 4: Create Your First Commit

Commit all files with a message:

```bash
git commit -m "Initial commit: Focus learning companion app with authentication, profile management, and progress tracking"
```

### Step 5: Add GitHub Remote Repository

Copy the repository URL from GitHub (it will look like: `https://github.com/yourusername/focus-app.git`)

Then add it as remote:

```bash
git remote add origin https://github.com/yourusername/focus-app.git
```

**Replace `yourusername` and `focus-app` with your actual GitHub username and repository name.**

### Step 6: Push to GitHub

Push your code to GitHub:

```bash
git branch -M main
git push -u origin main
```

You'll be prompted to enter your GitHub username and password (or personal access token).

### Step 7: Verify Upload

1. Go to your GitHub repository page
2. Refresh the page
3. You should see all your files uploaded!

## 🔐 Important Security Notes

### Before Uploading:

1. **Sensitive Files Already Excluded**: 
   - `google-services.json` - Contains Firebase config
   - `firebase_options.dart` - Contains Firebase API keys
   - These are in `.gitignore` and won't be uploaded

2. **If You Need to Share Firebase Config**:
   - Create a `firebase_options.example.dart` file with placeholder values
   - Document in README how to set up Firebase

### Creating a Template File for Firebase Config

If you want to help others set up the project, you can create example files:

1. Create `firebase_options.example.dart`:
   ```dart
   // Copy this file to firebase_options.dart and fill in your Firebase credentials
   // Get them from Firebase Console > Project Settings
   ```

2. Update README with Firebase setup instructions (already included)

## 🔄 Future Updates

When you make changes to your code:

```bash
# Add changed files
git add .

# Commit with a descriptive message
git commit -m "Description of your changes"

# Push to GitHub
git push
```

## 📝 Common Git Commands

- `git status` - Check which files have changed
- `git log` - View commit history
- `git pull` - Download latest changes from GitHub
- `git branch` - List all branches
- `git checkout -b feature-name` - Create a new branch

## 🆘 Troubleshooting

### If you get authentication errors:

1. **Use Personal Access Token** instead of password:
   - Go to GitHub Settings > Developer settings > Personal access tokens
   - Generate new token with `repo` permissions
   - Use token as password when pushing

2. **Or use SSH**:
   ```bash
   # Generate SSH key (if you don't have one)
   ssh-keygen -t ed25519 -C "your_email@example.com"
   
   # Add SSH key to GitHub (Settings > SSH and GPG keys)
   # Then use SSH URL instead:
   git remote set-url origin git@github.com:yourusername/focus-app.git
   ```

### If you need to update .gitignore:

```bash
# Remove files from git cache that should be ignored
git rm -r --cached .
git add .
git commit -m "Update .gitignore"
git push
```

## ✅ Checklist Before Uploading

- [ ] Git is installed
- [ ] GitHub account created
- [ ] Repository created on GitHub
- [ ] `.gitignore` file is present (already done)
- [ ] Sensitive files are excluded (google-services.json, firebase_options.dart)
- [ ] README.md is complete (already done)
- [ ] All code is working (no errors)

## 🎉 You're Done!

Once uploaded, you can:
- Share the repository with collaborators
- Track issues and feature requests
- Use GitHub Actions for CI/CD
- Create releases and tags
- Collaborate with others

---

**Need Help?** Check GitHub documentation: https://docs.github.com/en/get-started

