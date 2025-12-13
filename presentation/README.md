# Presentation

3D Modeling with AI - Hackathon Review 2025

## Local Development

### Run presentation locally

```bash
# Development server
cd presentation
npx revealjs-cli --open ./presentation.md

# Build static site
npx revealjs-cli --build --location ./_site --open ./presentation.md
```

The presentation will be available at the local server URL displayed in the terminal.

## GitHub Pages Deployment

This presentation is automatically deployed to GitHub Pages when changes are pushed to the `main` branch.

### Setup Instructions

1. **Enable GitHub Pages in your repository settings:**
   - Go to: Settings → Pages
   - Under "Build and deployment":
     - Source: Select **"GitHub Actions"**

2. **Push changes to trigger deployment:**

   ```bash
   git add .
   git commit -m "Add presentation"
   git push origin main
   ```

3. **Access your presentation:**
   - After the workflow completes, your presentation will be available at:
   - `https://<username>.github.io/<repository-name>/`
   - Example: `https://budavariam.github.io/hackathon-3dmodels/`

### Manual Deployment

You can also trigger the deployment manually:

- Go to: Actions → Deploy Presentation to GitHub Pages → Run workflow

### Workflow Details

The GitHub Action (`.github/workflows/deploy-presentation.yml`) automatically:

- Installs revealjs-cli
- Generates static HTML from `presentation.md`
- Copies all assets (images, CSS, JavaScript)
- Deploys to GitHub Pages

**Triggers:**

- Push to `main` branch affecting `presentation/**` files
- Manual workflow dispatch

## Files

- `presentation.md` - Main presentation content (Markdown)
- `overrides.css` - Custom styling
- `presentation.js` - Custom JavaScript
- `asciinema-player.css` - Terminal recording player styles
- `asciinema-player.min.js` - Terminal recording player script
- `images/` - Presentation images

## Customization

Edit the frontmatter in `presentation.md` to customize:

- Theme
- Transition effects
- Highlighting
- Logo
- Slide numbers

```yaml
---
theme: "white"
transition: "none"
highlightTheme: "monokai"
customTheme: "overrides"
logoImg: "./images/logo.png"
slideNumber: false
center: false
title: "Your Presentation Title"
---
```
