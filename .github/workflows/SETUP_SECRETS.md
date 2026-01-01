# Setting Up GitHub Secrets for Firebase

## 🔐 Required Secrets

You need to add the following secrets to your GitHub repository:

### 1. `FIREBASE_SERVICE_ACCOUNT` (Already set up)
   - Used for Firebase deployment authentication
   - Contains the Firebase service account JSON

### 2. `FIREBASE_OPTIONS_DART` (New - Required)
   - Contains the entire content of `lib/firebase_options.dart`
   - This file will be generated during the build process

## 📝 How to Add `FIREBASE_OPTIONS_DART` Secret

### Step 1: Copy the file content

Copy the **entire content** of `project_code/lib/firebase_options.dart` file.

### Step 2: Add to GitHub Secrets

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `FIREBASE_OPTIONS_DART`
5. Value: Paste the **entire content** of `firebase_options.dart` file
6. Click **Add secret**

### Step 3: Verify

After adding the secret, the workflow will automatically:
- ✅ Create `lib/firebase_options.dart` during the build
- ✅ Use it to build your Flutter app
- ✅ Keep it secure (never exposed in the repository)

## 🔒 Security Notes

- ✅ The file is in `.gitignore` - it won't be committed
- ✅ Only accessible during GitHub Actions runs
- ✅ Not visible in repository history or logs
- ✅ Only repository admins can view/edit secrets

## 🚀 Quick Setup Script

You can also use this command to copy the file content:

```bash
# macOS/Linux
cat project_code/lib/firebase_options.dart | pbcopy

# Then paste it into GitHub Secrets
```

## ✅ Verification

After adding the secret, push to GitHub and check the Actions tab:
- The workflow should successfully create the file
- Build should complete without errors
- No `firebase_options.dart` file will appear in your repository
