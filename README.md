# no_tapjack

[![CI](https://github.com/FlutterPlaza/no_tapjack/actions/workflows/ci.yml/badge.svg)](https://github.com/FlutterPlaza/no_tapjack/actions/workflows/ci.yml)

Flutter plugin to detect **tapjacking** and **overlay attacks**. Part of the [FlutterPlaza Security Suite](https://flutterplaza.com).

Tapjacking occurs when a malicious app draws a transparent or partially transparent overlay on top of your app, tricking users into tapping on unintended targets. This plugin detects such attacks and optionally blocks touch events when the app is obscured.

## Features

| Feature | Android | iOS | Web | macOS | Windows | Linux |
|---|---|---|---|---|---|---|
| Detect full overlay attacks | API 9+ | No-op | No-op | No-op | No-op | No-op |
| Detect partial overlay attacks | API 29+ | No-op | No-op | No-op | No-op | No-op |
| Filter touches when obscured | All versions | No-op | No-op | No-op | No-op | No-op |
| Real-time event stream | Yes | Safe | Safe | Safe | Safe | Safe |

> Non-Android platforms provide a safe no-op implementation that always reports no overlay detected. See [Platform Support](#platform-support) for details.

## Installation

```yaml
dependencies:
  no_tapjack: ^0.1.0
```

## Usage

### Start listening for overlay attacks

```dart
import 'package:no_tapjack/no_tapjack.dart';
import 'package:no_tapjack/tapjack_snapshot.dart';

final plugin = NoTapjack.instance;

// Start listening
await plugin.startListening();

// Listen for overlay state changes
plugin.tapjackStream.listen((TapjackSnapshot snapshot) {
  if (snapshot.isOverlayDetected) {
    // Overlay detected — show warning or block interaction
    print('WARNING: Overlay attack detected!');
  }
});
```

### Enable touch filtering

```dart
// Block all touch events when the app window is obscured by an overlay
await plugin.enableFilterTouches();

// Re-enable touches (disable filtering)
await plugin.disableFilterTouches();
```

### Stop listening

```dart
await plugin.stopListening();
```

## API Reference

| Method | Description |
|---|---|
| `startListening()` | Start monitoring for overlay attacks |
| `stopListening()` | Stop monitoring |
| `tapjackStream` | `Stream<TapjackSnapshot>` — real-time overlay state |
| `enableFilterTouches()` | Enable `filterTouchesWhenObscured` (Android) |
| `disableFilterTouches()` | Disable touch filtering |

### TapjackSnapshot

| Field | Type | Description |
|---|---|---|
| `isOverlayDetected` | `bool` | `true` when any overlay is detected |
| `isPartialOverlay` | `bool` | `true` when a partial overlay is detected (Android 29+) |
| `isTouchFilterEnabled` | `bool` | `true` when `filterTouchesWhenObscured` is active |

## How it works

### Android

The plugin installs a custom `Window.Callback` that intercepts all touch events before they reach the Flutter view. Each `MotionEvent` is inspected for:

- **`FLAG_WINDOW_IS_OBSCURED`** (API 9+): Set when another visible window is covering the app
- **`FLAG_WINDOW_IS_PARTIALLY_OBSCURED`** (API 29+): Set when the app is partially covered

When either flag is detected, the plugin emits a `TapjackSnapshot` through the event stream. The overlay detection auto-resets after 2 seconds of clean (non-obscured) touch events.

The `enableFilterTouches()` method sets `filterTouchesWhenObscured = true` on the root `decorView`, which causes Android to automatically discard any touch events that arrive while the window is obscured.

### iOS

iOS enforces strict app sandboxing — third-party apps cannot draw overlays on top of other apps. The plugin provides a safe no-op implementation that always reports `isOverlayDetected: false`.

## Platform Support

Tapjacking is fundamentally an **Android-specific threat**. On all other platforms, the plugin provides a safe no-op implementation so your code works everywhere without `MissingPluginException`.

- **Android** — Full detection. The only platform where tapjacking is a real threat. See [How it works — Android](#android) for details.
- **iOS** — Safe no-op. iOS enforces strict app sandboxing — third-party apps cannot draw overlays on top of other apps.
- **Web** — Safe no-op. Browsers enforce the same-origin policy. Clickjacking is a server-side concern mitigated with HTTP headers (`X-Frame-Options`, `Content-Security-Policy`), not a client-side overlay issue.
- **macOS / Windows / Linux** — Safe no-op. Desktop operating systems allow overlapping windows by design, and there is no OS-level "obscured touch" flag. Overlay-based attacks are not a meaningful threat on desktop.

## Related packages

- [no_screenshot](https://pub.dev/packages/no_screenshot) — Screenshot & recording prevention
- [no_screen_mirror](https://pub.dev/packages/no_screen_mirror) — Display mirroring & casting detection
