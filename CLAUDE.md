# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Flutter **web-only** portfolio/marketing site for "Taxverse" (tax/financial services company). This is a responsive web app — there is no mobile/native app target. Android/iOS folders exist only as Flutter scaffolding and are not used. Uses `usePathUrlStrategy()` for clean URL routing.

## Common Commands

- Run the app: `flutter run -d chrome`
- Build for production: `flutter build web`
- Static analysis / lint: `flutter analyze`
- Run tests: `flutter test`
- Run a single test file: `flutter test test/widget_test.dart`
- Fetch dependencies after editing `pubspec.yaml`: `flutter pub get`

## Architecture

The codebase follows a layered (clean architecture-inspired) structure under `lib/`:

- `lib/domain/` — abstract definitions, framework-agnostic
  - `entities/` — plain data classes (e.g. `ServiceEntity`, `TestimonialEntity`, `StatEntity`)
  - `repositories/` — abstract repository interfaces (`ContentRepository`, `ThemeRepository`)
- `lib/data/` — implementations of the domain layer
  - `datasources/static_content_data_source.dart` — hardcoded/static content for the site (no backend/API)
  - `models/` — data models corresponding to domain entities
  - `repositories/` — concrete repository implementations (`ContentRepositoryImpl`, `ThemeRepositoryImpl`) that wrap the data source
- `lib/presentation/` — UI layer
  - `providers/` — `ChangeNotifier`-based state (`ContentProvider`, `ThemeProvider`), wired up via `provider` package `MultiProvider` in `main.dart`
  - `pages/` — top-level routed pages (`home_page.dart`, `about_us_page.dart`, `services_page.dart`, `contact_page.dart`, `careers_page.dart`)
  - `pages/sections/` — large composable sections rendered within pages (hero, services, about, approach, industries, testimonials, footer)
  - `widgets/` — shared widgets used across pages (`header_nav.dart`, `consultation_dialog.dart`)
- `lib/core/`
  - `theme.dart` — `AppTheme` defining colors, text theme, button themes (Material 3, font family "Metropolis")
  - `constants.dart` — `AppConstants` (app name, contact info, layout breakpoints)

### Routing

Routes are defined declaratively in `main.dart` via `MaterialApp.routes` (`/`, `/about`, `/services`, `/contact`; `/careers` currently commented out). `HomePage` is a single scrolling page that uses `GlobalKey`s per section + `ScrollController.ensureVisible` for in-page navigation (smooth-scroll to section) rather than route changes.

### Responsive Design

This is a responsive **web** site (browser viewport widths), not a mobile app — there are no native mobile/tablet device targets. Uses `responsive_builder` with custom breakpoints set in `main.dart` (`desktop: 1024, tablet: 768, watch: 200`). Sections/pages should branch layout on these breakpoints to adapt between wide desktop browser layouts and narrow browser/mobile-web layouts. When testing responsiveness, resize the Chrome window/viewport rather than targeting a device.

### Fonts and Assets

- Custom font family "Metropolis" is registered in `pubspec.yaml` with multiple weights (300–900), loaded from `assets/fonts/metropolis/`.
- Images live in `assets/images/` and are declared in `pubspec.yaml`.
- `flutter_svg` is used for SVG assets (e.g. logo).

### Animations

`flutter_animate` is used for entrance/scroll animations; `visibility_detector` is used to trigger animations when sections scroll into view.
