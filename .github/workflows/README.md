# GitHub Actions Setup for Firebase Deployment

This workflow automatically builds and deploys your Flutter web app to Firebase Hosting when you push to the `main` or `master` branch.

## 🔧 Setup Instructions

### Step 1: Create Firebase Service Account

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **hatim-program**
3. Click the gear icon ⚙️ → **Project settings**
4. Go to the **Service accounts** tab
5. Click **Generate new private key**
6. Save the downloaded JSON file (keep it secure!)

### Step 2: Add Firebase Service Account to GitHub Secrets

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `FIREBASE_SERVICE_ACCOUNT`
5. Value: Copy and paste the **entire contents** of the JSON file you downloaded
6. Click **Add secret**

### Step 3: Push to GitHub

Once the secret is added, the workflow will automatically run when you:
- Push to the `main` or `master` branch
- Manually trigger it from the **Actions** tab

## 🎯 How It Works

1. **Trigger**: Automatically runs on push to main/master branch
2. **Build**: Sets up Flutter and builds the web app
3. **Deploy**: Deploys to Firebase Hosting using the service account
4. **Live**: Your app is automatically updated at https://hatim-program.web.app

## 🚀 Manual Trigger

You can also manually trigger the deployment:
1. Go to your repository on GitHub
2. Click **Actions** tab
3. Select **Build and Deploy to Firebase Hosting**
4. Click **Run workflow**

## 📝 Configuration

The workflow is configured in `.github/workflows/deploy-firebase.yml`

Key settings:
- **Flutter Version**: 3.24.0 (update if needed)
- **Project ID**: hatim-program
- **Working Directory**: ./project_code
- **Branches**: main, master

## 🔍 Monitoring

View deployment status:
- GitHub: Repository → **Actions** tab
- Firebase: [Console](https://console.firebase.google.com/project/hatim-program/hosting)

## ⚠️ Important Notes

- The `FIREBASE_SERVICE_ACCOUNT` secret must be kept secure
- Never commit the service account JSON file to your repository
- The workflow requires the `GITHUB_TOKEN` (automatically provided by GitHub)
