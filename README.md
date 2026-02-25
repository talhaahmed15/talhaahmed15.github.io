# My Portfolio (Flutter)

This is a Flutter portfolio app with data-driven content loaded from `assets/data/site.json`.

## Architecture

- `lib/app/`: app bootstrap (`MaterialApp`)
- `lib/core/`: theme, shared widgets, shared utilities
- `lib/data/`: models and repository for loading portfolio JSON
- `lib/features/home/`: homepage and project grid
- `lib/features/projects/`: project detail page with image gallery

## Run locally

```powershell
flutter run -d chrome
```

## Where to edit content

Update [`assets/data/site.json`](assets/data/site.json):

- `owner`: name, role, bio, email, resume
- `startup`: startup name, tagline, image, and URL (shown in hero section)
- `socials`: links (GitHub, LinkedIn, etc.)
- `about.skills`: skill chips
- `projects`: project cards rendered dynamically
- `projects[n].galleryImages`: all screenshots shown on the project detail page
- `projects[n].videos`: optional asset videos shown on the project detail page

## How to add images

1. Add files in `assets/images/` (for startup/branding image) and `assets/images/projects/` (for project thumbnails/screenshots).
2. Set paths in `assets/data/site.json`, for example:
   - `"startup": { "image": "assets/images/startup.jpg" }`
   - `"image": "assets/images/projects/my-project.jpg"`
   - `"galleryImages": ["assets/images/projects/my-project.jpg", "assets/images/projects/my-project-2.jpg"]`
   - `"videos": ["assets/images/projects/my-project-demo.mp4"]`

If an image path is missing, the app shows a fallback placeholder card.

## Add a new project in the future

1. Put images in `assets/images/projects/`.
2. Add one object in the `projects` array in `assets/data/site.json`.
3. Include `galleryImages` for that project.
4. Rebuild and deploy.

No Dart code changes required.

## Deploy to GitHub Pages

Flutter web output must be built and published:

```powershell
flutter build web --release --base-href /<repo-name>/
```

Then publish `build/web` to GitHub Pages (for example by pushing `build/web` contents to a `gh-pages` branch, or via GitHub Actions).
