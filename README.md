# NewsTask

A small iOS app that shows the latest news from [NewsAPI](https://newsapi.org/).

## Features

- **Three tabs:** Home, Categories and Saved.
- **Home** shows top headlines and has a search bar. Search starts 0.5s after you stop typing.
- **Categories** lets you browse news by category (business, sports, technology, etc.).
- **Saved** keeps your bookmarked articles in a local database (SwiftData).
- You can add and remove saved articles with the bookmark button or by double-tapping the image.
- Pull to refresh and infinite scroll (pagination).
- Error banner that hides itself after a few seconds.
- Simple in-memory cache for network responses. Pull to refresh clears it.

## Requirements

- Xcode 26.2 or newer
- iOS 26.2 or newer
- A free API key from [newsapi.org](https://newsapi.org/register)

## Setup

1. Clone the repository.
2. Copy the example config file:
   ```bash
   cp Secrets.xcconfig.example Secrets.xcconfig
   ```
3. Open `Secrets.xcconfig` and add your API key:
   ```
   NEWS_API_KEY = your_api_key_here
   ```
4. Open `NewsTask.xcodeproj` and run the app.

`Secrets.xcconfig` is in `.gitignore`, so your key will not be committed.

## Architecture

The app uses **MVVM** with a simple factory for dependency injection.

```
NewsTask/
├── Domain/      Models, endpoints and the NewsProvider protocol (+ mock)
├── Network/     NetworkService (actor) and errors
├── Saved/       SwiftData model, ArticlesStore and the Saved screen
├── Shared/      Article list, view model and reusable views
└── AppFactory   Creates view models and views with their dependencies
```

- **NetworkService** is an `actor`. It builds requests, checks the response and decodes JSON.
- **NewsProvider** is a protocol, so the view model does not depend on the real API. `MockNewsProvider` is used in SwiftUI previews.
- **ArticlesListViewModel** handles loading, pagination, search and errors. The same view model is used on Home and in Categories.
- **ArticlesStore** wraps SwiftData and is shared between all screens, so the bookmark state is always in sync.
- **AppFactory** is passed through the SwiftUI environment and creates screens with the right dependencies.

## Tech Stack

- SwiftUI
- Swift Concurrency (async/await, actors)
- Observation (`@Observable`)
- SwiftData
- [Kingfisher](https://github.com/onevcat/Kingfisher) for image loading and caching (Swift Package Manager)

## Notes

- Top headlines are loaded for the US (`country=us`).
- The free NewsAPI plan has limits: 100 requests per day and up to 100 results per query.
