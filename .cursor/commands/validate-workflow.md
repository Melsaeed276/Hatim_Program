---
description: Validate GitHub Actions workflow syntax
---

#!/bin/bash
set -e

echo "🔍 Validating GitHub Actions workflow..."
echo ""

# Check if actionlint is installed
if ! command -v actionlint &> /dev/null; then
    echo "⚠️  'actionlint' is not installed (optional but recommended)"
    echo "   Install with: brew install actionlint"
    echo ""
fi

# Check YAML syntax
echo "📋 Checking YAML syntax..."
if command -v yamllint &> /dev/null; then
    yamllint .github/workflows/deploy-firebase.yml
    echo "✅ YAML syntax is valid"
else
    echo "⚠️  'yamllint' not installed, skipping YAML validation"
    echo "   Install with: brew install yamllint"
fi

echo ""

# Validate with actionlint if available
if command -v actionlint &> /dev/null; then
    echo "🔍 Running actionlint..."
    actionlint .github/workflows/deploy-firebase.yml
    echo "✅ Workflow validation passed!"
else
    echo "✅ Basic validation complete!"
    echo ""
    echo "💡 For deeper validation, install actionlint:"
    echo "   brew install actionlint"
fi

echo ""
echo "📄 Workflow file: .github/workflows/deploy-firebase.yml"
