class TapjackSnapshot {
  final bool isOverlayDetected;
  final bool isPartialOverlay;
  final bool isTouchFilterEnabled;

  TapjackSnapshot({
    required this.isOverlayDetected,
    this.isPartialOverlay = false,
    this.isTouchFilterEnabled = false,
  });

  factory TapjackSnapshot.fromMap(Map<String, dynamic> map) {
    return TapjackSnapshot(
      isOverlayDetected: map['is_overlay_detected'] as bool? ?? false,
      isPartialOverlay: map['is_partial_overlay'] as bool? ?? false,
      isTouchFilterEnabled: map['is_touch_filter_enabled'] as bool? ?? false,
    );
  }

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
