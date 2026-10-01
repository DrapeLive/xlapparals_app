# AGENTS.md

## What this is

Single-package Flutter app (Android/iOS), `name: xlapparals_app`, Dart SDK `^3.12.0`. Field-agent app for an apparel business (orders, stock, QR scanning, PDF invoices) against a Django-style backend.

No monorepo, no CI, no Makefile, no codegen (no build_runner), no existing tests.

## Commands

```sh
flutter pub get          # after any pubspec change
flutter analyze          # the only automated check (lint == typecheck here)
flutter run              # dev; needs a device/emulator
flutter test             # nothing to run yet — test/ does not exist
```

There is no lint/typecheck/test pipeline beyond `flutter analyze`. Run it before considering a change done.

After changing pubspec (new firebase packages are already wired), remember: the google-services Gradle plugin in `android/app/build.gradle.kts` applies **conditionally** — it only activates when `android/app/google-services.json` exists. Fresh clones build fine without it, but push notifications stay dead until the Firebase config file is dropped in. Do not remove the conditional.

After changing `assets/icon/icon.jpg` or splash config in `pubspec.yaml`:

```sh
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## Architecture

- Feature-first clean-ish architecture: `lib/features/{auth,agent/<area>}/` each split into `data/` (datasources, models, repositories), `domain/` (entities, repositories, usecases), `presentation/` (pages, widgets, blocs).
- Two feature roots: `auth` and `agent` (`agent` has `home`, `profile`, `orders/*` including `scanner`, `orderform`, `order_details`, `order_items`, `edit_order`, `customers`).
- Entry: `lib/main.dart` → `di.init()` → `lib/app.dart` (theme + `MultiBlocProvider` + `MaterialApp.router`).
- State: flutter_bloc. DI: get_it, all registrations in `lib/injection_container.dart`.

**Wiring rule (easy to get wrong):** a new bloc usually needs THREE touches:
1. register in `injection_container.dart` (`sl.registerFactory`/`registerLazySingleton`),
2. provide it in `lib/app.dart`'s `MultiBlocProvider` if it is app-scoped (most are), or in the page via `BlocProvider(create: ...)` if page-scoped (e.g. `ItemFilterBloc` in `items_page.dart`, `OrderInvoiceBloc` in `order_form_page.dart`),
3. then `context.read<YourBloc>()` in widgets.

- Routing: go_router. Paths as constants in `lib/core/routes/route_name.dart`; route table + auth redirect in `lib/core/routes/app_router.dart`. Many routes read `state.extra` and cast it (`int` orderId, or `Map<String, dynamic>`) — navigation must pass `extra` of the matching type or the page throws at build time.
- Auth redirect runs on every navigation and reads the access token from secure storage; there is no splash gate despite `RouteNames.splash = "/"` existing unused.

## Push notifications (Firebase)

- Client wiring: `lib/shared/services/notification_service.dart` (initialized in `lib/main.dart`, token registration on login in `auth_bloc.dart`). Foreground messages are shown via `flutter_local_notifications`; background/terminated display is handled by FCM itself plus the top-level `firebaseMessagingBackgroundHandler`.
- Needs `android/app/google-services.json` (see "Commands" above). Without it the app still builds/runs but push is silent.
- The client posts the FCM token to `POST {base}/agents/device-token/` with body `{agent, token, platform}`. **The backend endpoint does NOT exist yet in `backend.xlapparals.in`** — the call is non-fatal until it lands. Backend must: (1) accept that POST (auth as agent) and store/upsert the token, (2) send FCM notification + data payloads (`type: new_assignment | out_of_stock`, `item_id`) to the agent's registered tokens when items are assigned or go out of stock. No such worker/trigger exists anywhere yet.

## Networking & storage

- Base URL and endpoints are hardcoded in `lib/core/constants/api_constants.dart` (prod: `https://backend.xlapparals.in/api`; an onrender URL sits commented out). No `.env` loading exists.
- One Dio instance (`lib/core/network/dio_client.dart`) with `AuthInterceptor` that injects `Authorization: Bearer <access_token>`. No 401/refresh handling in the interceptor — do not assume token refresh happens automatically.
- Tokens: `flutter_secure_storage` via `shared/services/secure_storage_service.dart`. Profile/role fields: `shared_preferences` via `shared/services/user_storage_service.dart`.

## Business rules live in core

Size/piece-count mappings and order-size vocabularies are constants in `lib/core/constants/app_constants.dart` (gents/kids size strings like `"M,L,XL,XXL"`). Read/extend that file before encoding size logic anywhere else. Validators: `core/utils/validators.dart`, stock-specific ones in `stock_validators.dart`.

## Platform notes (Android)

- `android/app/build.gradle.kts` loads `android/key.properties` for release signing. That file is gitignored and absent from fresh clones; the `signingConfigs` block casts its values non-null — restore the keystore + `key.properties` before release builds (and expect failures if it is missing).
- Release builds use ProGuard (`android/app/proguard-rules.pro` keeps ML Kit classes — keep those rules if touching minification).
- QR scanning: `camera` + `google_mlkit_barcode_scanning` in `features/agent/orders/scanner`; ML Kit barcode dependency is declared in `AndroidManifest.xml` meta-data. Be careful editing `scan_page.dart` (600+ lines, camera lifecycle + `ValueNotifier` UI state).
- Invoice PDFs are generated client-side (`pdf`/`printing`/`file_saver`/`share_plus` in `order_form_bloc.dart`) and also downloadable from `/orders/{id}/pdf/`.
- A stray build artifact (`android/build/reports/...`) is committed; ignore it, don't add more `android/build` or `.gradle` output.

## Conventions observed

- Commit messages: conventional-prefix style, past history uses `feat:`, `fix:`, `chore:`, `update:`, `deploy:` (lowercase, short summary). Single branch `main`.
- App version lives only in `pubspec.yaml` (`version: 1.0.1+4`); Android versionCode/Name derive from it via `flutter.versionCode`/`flutter.versionName` — bump there, not in Gradle.
- Theme: M3 light-only (`core/theme/app_theme.dart`); font family is the bundled `PlusJakartaSans` (pubspec `fonts:`). `google_fonts` is a dependency but currently unused in code — don't assume `GoogleFonts` is applied.
- Fonts are declared both under `assets:` (NotoSans) and `fonts:` (PlusJakartaSans) in `pubspec.yaml`; both blocks matter — don't prune either casually.
