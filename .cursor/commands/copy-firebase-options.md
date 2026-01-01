---
description: Copy firebase_options.dart content to clipboard for GitHub Secrets
---

#!/bin/bash
set -e

FILE_PATH="project_code/lib/firebase_options.dart"

if [ ! -f "$FILE_PATH" ]; then
    echo "❌ File not found: $FILE_PATH"
    exit 1
fi

echo "📋 Copying firebase_options.dart content to clipboard..."
echo ""

# Copy to clipboard based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    cat "$FILE_PATH" | pbcopy
    echo "✅ Content copied to clipboard!"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command -v xclip &> /dev/null; then
        cat "$FILE_PATH" | xclip -selection clipboard
        echo "✅ Content copied to clipboard!"
    elif command -v xsel &> /dev/null; then
        cat "$FILE_PATH" | xsel --clipboard --input
        echo "✅ Content copied to clipboard!"
    else
        echo "⚠️  No clipboard utility found. Install xclip or xsel."
        echo ""
        echo "📄 File content:"
        cat "$FILE_PATH"
    fi
else
    echo "⚠️  Unsupported OS. Displaying file content:"
    echo ""
    cat "$FILE_PATH"
fi

echo ""
echo "📝 Next steps:"
echo "   1. Go to GitHub → Settings → Secrets and variables → Actions"
echo "   2. Click 'New repository secret'"
echo "   3. Name: FIREBASE_OPTIONS_DART"
echo "   4. Value: Paste the content (already in clipboard if on macOS)"
echo "   5. Click 'Add secret'"
echo ""
echo "📖 See: .github/workflows/SETUP_SECRETS.md for detailed instructions"
