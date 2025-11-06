# GitHub Pages Deployment Guide for Angular Applications

This guide documents the steps and fixes needed to deploy an Angular application to GitHub Pages with a custom domain.

## Overview

This deployment setup uses:
- **GitHub Actions** for automated CI/CD
- **Hash-based routing** for compatibility with GitHub Pages
- **Custom domain** support with CNAME configuration
- **Relative asset paths** for proper resource loading

---

## 1. GitHub Actions Workflow Setup

Create `.github/workflows/deploy.yml` with the following configuration:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches:
      - main
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Build Angular app
        run: npm run build -- --configuration production --base-href=/

      - name: Create CNAME file
        run: |
          mkdir -p ./dist/[PROJECT-NAME]/browser
          echo "your-custom-domain.com" > ./dist/[PROJECT-NAME]/browser/CNAME

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./dist/[PROJECT-NAME]/browser

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### Important Notes:
- Replace `[PROJECT-NAME]` with your Angular project name from `angular.json`
- Replace `your-custom-domain.com` with your actual custom domain
- The `--base-href=/` works for custom domains
- For GitHub Pages default URL (`username.github.io/repo-name/`), use `--base-href=/repo-name/`

---

## 2. Enable Hash-Based Routing

Update `src/app/app.config.ts` to use hash location strategy:

```typescript
import { ApplicationConfig } from '@angular/core';
import { provideRouter, withHashLocation } from '@angular/router';
import { provideHttpClient } from '@angular/common/http';

import { routes } from './app.routes';

export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes, withHashLocation()),
    provideHttpClient()
  ]
};
```

**Why?** Hash-based routing (`#/`) ensures all routes work on GitHub Pages without server-side configuration. URLs will look like: `example.com/#/about`

---

## 3. Fix Asset Loading Paths

If your app loads assets (e.g., translations, images) dynamically via HTTP, use **relative paths** instead of absolute paths.

### Before (Absolute Path - Won't Work):
```typescript
this.http.get<Translations>(`/assets/i18n/${lang}.json`)
```

### After (Relative Path - Works):
```typescript
this.http.get<Translations>(`assets/i18n/${lang}.json`)
```

**Why?** Relative paths automatically work with any `base-href` configuration, whether using custom domains or GitHub Pages default URLs.

---

## 4. GitHub Repository Settings

### Enable GitHub Pages:
1. Go to your repository on GitHub
2. Navigate to **Settings** → **Pages**
3. Under "Build and deployment" → **Source**, select **GitHub Actions**

### Configure Custom Domain (Optional):
1. In the same **Pages** settings
2. Under "Custom domain", enter your domain: `your-custom-domain.com`
3. Check **Enforce HTTPS** once DNS propagates

---

## 5. DNS Configuration for Custom Domain

Configure your DNS records at your domain provider:

### For Root Domain (example.com):
```
Type: A
Name: @
Value: 185.199.108.153
       185.199.109.153
       185.199.110.153
       185.199.111.153
```

### For Subdomain (subdomain.example.com):
```
Type: CNAME
Name: subdomain
Value: yourusername.github.io
```

**DNS Propagation:** May take 24-48 hours to fully propagate.

---

## 6. Common Issues and Fixes

### Issue: 404 Error or "File not found"
**Cause:** Incorrect output path in workflow
**Fix:** Verify the output path matches your `angular.json` configuration
- Check `outputPath` in `angular.json`
- Update workflow's `path: ./dist/[PROJECT-NAME]/browser` accordingly

### Issue: White Page with No Errors
**Possible Causes:**
1. **Wrong base-href**
   - Custom domain: Use `--base-href=/`
   - GitHub Pages URL: Use `--base-href=/repo-name/`
   
2. **Browser/CDN Cache**
   - Hard refresh: `Ctrl + Shift + R` (Windows/Linux) or `Cmd + Shift + R` (Mac)
   - Try incognito/private mode
   - Wait 5-10 minutes for GitHub Pages CDN to update

3. **Missing Hash Router**
   - Ensure `withHashLocation()` is added to router configuration

### Issue: Assets Not Loading (404 for JSON, images, etc.)
**Cause:** Using absolute paths for assets
**Fix:** Change all asset paths from `/assets/...` to `assets/...` (relative paths)

### Issue: Translation Files Not Found
**Cause:** HTTP service using absolute path with wrong base-href
**Fix:** Update to relative paths (see section 3 above)

### Issue: Directory Not Found During CNAME Creation
**Cause:** Build output directory doesn't exist or wrong path
**Fix:** Add `mkdir -p` before creating CNAME file in workflow:
```yaml
- name: Create CNAME file
  run: |
    mkdir -p ./dist/[PROJECT-NAME]/browser
    echo "your-domain.com" > ./dist/[PROJECT-NAME]/browser/CNAME
```

---

## 7. Testing Locally

Before deploying, test your build locally:

```bash
# Build with production configuration
npm run build -- --configuration production --base-href=/

# Serve the build (using npx http-server)
npx http-server dist/[PROJECT-NAME]/browser -p 8080

# Or using Python
cd dist/[PROJECT-NAME]/browser
python -m http.server 8080
```

Then visit: `http://localhost:8080/#/`

---

## 8. Deployment Checklist

- [ ] Create `.github/workflows/deploy.yml`
- [ ] Update project name in workflow paths
- [ ] Set correct `base-href` for your deployment type
- [ ] Add custom domain to CNAME file (if applicable)
- [ ] Enable hash-based routing in `app.config.ts`
- [ ] Convert all asset paths to relative paths
- [ ] Enable GitHub Pages in repository settings
- [ ] Configure DNS records (if using custom domain)
- [ ] Test build locally before pushing
- [ ] Commit and push to trigger deployment
- [ ] Clear browser cache after first deployment

---

## 9. Maintenance and Updates

### Triggering a New Deployment
- Any push to the `main` branch automatically triggers deployment
- Manual trigger: Go to **Actions** → Select workflow → **Run workflow**

### Checking Deployment Status
- Go to **Actions** tab in your repository
- View the latest workflow run
- Check build and deploy steps for errors

### Updating Dependencies
```bash
npm update
npm audit fix
```

### Monitoring
- Check GitHub Actions for build failures
- Monitor domain SSL certificate status
- Verify DNS propagation periodically

---

## 10. Additional Resources

- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [Angular Deployment Guide](https://angular.io/guide/deployment)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Custom Domain Configuration](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site)

---

## Summary

This deployment setup provides:
- ✅ Automated CI/CD with GitHub Actions
- ✅ Custom domain support
- ✅ Hash-based routing for SPA compatibility
- ✅ Proper asset loading with relative paths
- ✅ Production-optimized builds
- ✅ HTTPS support

The key differences when applying to other repositories:
1. Update project name in all paths
2. Adjust custom domain in CNAME file
3. Verify `angular.json` output path matches workflow
4. Ensure all asset paths are relative, not absolute
