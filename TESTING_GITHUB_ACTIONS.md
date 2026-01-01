# Testing GitHub Actions Locally

## ✅ Quick Syntax Check (No Installation Required)

Your workflow syntax is **valid**! The YAML structure is correct.

## 🧪 Option 1: Test with `act` (Recommended)

`act` runs GitHub Actions locally in Docker containers.

### Install:
```bash
# macOS
brew install act

# Linux
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
```

### Run the test:
```bash
# From project root
act push -W .github/workflows/deploy-firebase.yml --dry-run

# Or use the Cursor command:
# /test-github-action
```

### Note:
- Requires Docker to be running
- Won't actually deploy (use `--dry-run` for safety)
- Simulates the GitHub Actions environment

## 🔍 Option 2: Validate with `actionlint`

Checks for common workflow errors without running it.

### Install:
```bash
brew install actionlint
```

### Run:
```bash
actionlint .github/workflows/deploy-firebase.yml

# Or use the Cursor command:
# /validate-workflow
```

## 🚀 Option 3: Test on GitHub (Easiest)

The safest way is to test directly on GitHub:

1. **Commit and push** your workflow:
   ```bash
   git add .github/workflows/deploy-firebase.yml
   git commit -m "Add GitHub Actions workflow"
   git push origin main
   ```

2. **Monitor the run**:
   - Go to your GitHub repo
   - Click **Actions** tab
   - Watch the workflow run in real-time

3. **Manual trigger** (if you don't want to push):
   - Actions tab → Select workflow
   - Click **Run workflow** button

## 📋 Current Workflow Status

✅ **YAML Syntax**: Valid  
✅ **Structure**: Correct  
✅ **Actions Used**: 
   - `actions/checkout@v4` ✓
   - `subosito/flutter-action@v2` ✓
   - `FirebaseExtended/action-hosting-deploy@v0` ✓

⚠️ **Required Setup**:
- [ ] Add `FIREBASE_SERVICE_ACCOUNT` secret to GitHub
- [ ] Ensure you're pushing to `main` or `master` branch

## 🎯 Cursor Commands Available

1. `/test-github-action` - Test workflow locally with act
2. `/validate-workflow` - Validate workflow syntax
3. `/deployonfirebase` - Deploy manually from local machine

## 💡 Pro Tips

- **First time?** Test on GitHub directly - it's the most reliable
- **Debugging?** Check the Actions tab for detailed logs
- **Quick validation?** Use `actionlint` before pushing
- **Full simulation?** Use `act` with Docker

## 🔗 Useful Links

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [act - Local GitHub Actions](https://github.com/nektos/act)
- [Firebase Hosting GitHub Action](https://github.com/FirebaseExtended/action-hosting-deploy)
