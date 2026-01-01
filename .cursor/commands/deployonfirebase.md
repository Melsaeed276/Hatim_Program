---
description: Build Flutter web project and deploy to Firebase Hosting
---

#!/bin/bash
set -e

echo "🔨 Building Flutter web project..."
cd project_code
flutter clean
flutter pub get
flutter build web --release

echo ""
echo "📤 Deploying to Firebase Hosting..."
firebase deploy --only hosting

echo ""
echo "✅ Build and deployment complete!"
echo "🌐 Your app is now live on Firebase Hosting."
