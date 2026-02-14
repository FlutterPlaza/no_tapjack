## 0.1.0

- feat: initial release
- feat(android): detect overlay attacks via `MotionEvent.FLAG_WINDOW_IS_OBSCURED` (API 9+)
- feat(android): detect partial overlays via `FLAG_WINDOW_IS_PARTIALLY_OBSCURED` (API 29+)
- feat(android): `enableFilterTouches()` / `disableFilterTouches()` to toggle `filterTouchesWhenObscured`
- feat(android): `Window.Callback` interception for real-time overlay detection
- feat(ios): safe no-op implementation (iOS does not allow third-party overlays)
- feat: `TapjackSnapshot` data class with `isOverlayDetected`, `isPartialOverlay`, `isTouchFilterEnabled`
- feat: `tapjackStream` for real-time overlay state changes
- feat: `startListening()` / `stopListening()` API
- test: unit tests for Dart layer (snapshot, platform interface, method channel)
