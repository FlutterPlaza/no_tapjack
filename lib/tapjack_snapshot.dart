/// A snapshot of the current tapjacking/overlay state.
///
/// Emitted through [NoTapjack.tapjackStream] whenever the overlay state
/// changes.
class TapjackSnapshot {
  /// Whether any overlay is currently detected on top of the app.
  final bool isOverlayDetected;

  /// Whether a partial overlay is detected (Android 29+ only).
  final bool isPartialOverlay;

  /// Whether `filterTouchesWhenObscured` is currently active.
  final bool isTouchFilterEnabled;

  /// Creates a [TapjackSnapshot] with the given overlay state.
  TapjackSnapshot({
    required this.isOverlayDetected,
    this.isPartialOverlay = false,
    this.isTouchFilterEnabled = false,
  });

  /// Creates a [TapjackSnapshot] from a platform channel map.
  factory TapjackSnapshot.fromMap(Map<String, dynamic> map) {
    return TapjackSnapshot(
      isOverlayDetected: map['is_overlay_detected'] as bool? ?? false,
      isPartialOverlay: map['is_partial_overlay'] as bool? ?? false,
      isTouchFilterEnabled: map['is_touch_filter_enabled'] as bool? ?? false,
    );
  }

  /// Converts this snapshot to a map matching the platform channel format.
  Map<String, dynamic> toMap() {
    return {
      'is_overlay_detected': isOverlayDetected,
      'is_partial_overlay': isPartialOverlay,
      'is_touch_filter_enabled': isTouchFilterEnabled,
    };
  }

  @override
  String toString() {
    return 'TapjackSnapshot(\nisOverlayDetected: $isOverlayDetected, \nisPartialOverlay: $isPartialOverlay, \nisTouchFilterEnabled: $isTouchFilterEnabled\n)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TapjackSnapshot &&
        other.isOverlayDetected == isOverlayDetected &&
        other.isPartialOverlay == isPartialOverlay &&
        other.isTouchFilterEnabled == isTouchFilterEnabled;
  }

  @override
  int get hashCode {
    return isOverlayDetected.hashCode ^
        isPartialOverlay.hashCode ^
        isTouchFilterEnabled.hashCode;
  }
}
