## 0.1.2

- docs: add screenshot to README

## 0.1.1

- feat: add Swift Package Manager support for iOS
- feat: add GitHub Actions workflows for CI and pub.dev publishing
- docs: add dartdoc comments to public API

## 0.1.0

- feat: initial release
- feat(android): detect overlay attacks via `MotionEvent.FLAG_WINDOW_IS_OBSCURED` (API 9+)
- feat(android): detect partial overlays via `FLAG_WINDOW_IS_PARTIALLY_OBSCURED` (API 29+)
- feat(android): `enableFilterTouches()` / `disableFilterTouches()` to toggle `filterTouchesWhenObscured`
- feat(android): `Window.Callback` interception for real-time overlay detection
- feat(ios): safe no-op implementation (iOS does not allow third-party overlays)
- feat(web): safe no-op implementation (browsers enforce same-origin policy)
- feat(macos): safe no-op implementation (desktop overlapping windows are by design)
- feat(windows): safe no-op implementation (desktop overlapping windows are by design)
- feat(linux): safe no-op implementation (desktop overlapping windows are by design)
- feat: `TapjackSnapshot` data class with `isOverlayDetected`, `isPartialOverlay`, `isTouchFilterEnabled`
- feat: `tapjackStream` for real-time overlay state changes
- feat: `startListening()` / `stopListening()` API
- test: unit tests for Dart layer (snapshot, platform interface, method channel)
