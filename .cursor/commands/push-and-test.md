---
description: Commit and push to GitHub to trigger the workflow
---

#!/bin/bash
set -e

echo "📝 Preparing to push and test GitHub Action..."
echo ""

# Check if there are changes to commit
if [[ -z $(git status -s) ]]; then
    echo "ℹ️  No changes to commit"
    echo ""
    echo "🚀 Pushing to trigger workflow..."
    git push origin main || git push origin master
else
    echo "📋 Changes detected:"
    git status -s
    echo ""
    
    read -p "📝 Commit message (or press Enter for default): " commit_msg
    
    if [ -z "$commit_msg" ]; then
        commit_msg="Update GitHub Actions workflow"
    fi
    
    echo ""
    echo "📦 Committing changes..."
    git add .github/workflows/
    git commit -m "$commit_msg"
    
    echo ""
    echo "🚀 Pushing to GitHub..."
    git push origin main || git push origin master
fi

echo ""
echo "✅ Pushed successfully!"
echo ""
echo "🔍 View the workflow run:"
echo "   Go to: https://github.com/YOUR_USERNAME/YOUR_REPO/actions"
echo ""
echo "💡 The workflow will run automatically on push to main/master"
