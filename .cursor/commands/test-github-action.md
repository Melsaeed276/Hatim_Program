---
description: Test GitHub Action workflow locally using act
---

#!/bin/bash
set -e

echo "🧪 Testing GitHub Action locally..."
echo ""
echo "Checking if 'act' is installed..."

if ! command -v act &> /dev/null; then
    echo "❌ 'act' is not installed."
    echo ""
    echo "📦 Install it with:"
    echo "  macOS: brew install act"
    echo "  Linux: curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash"
    echo ""
    echo "Visit: https://github.com/nektos/act"
    exit 1
fi

echo "✅ 'act' is installed"
echo ""
echo "🚀 Running GitHub Action workflow locally..."
echo "   (This will simulate the GitHub Actions environment)"
echo ""

# Run the workflow with act
act push -W .github/workflows/deploy-firebase.yml --verbose

echo ""
echo "✅ Test complete!"
