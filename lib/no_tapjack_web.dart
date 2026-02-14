import 'no_tapjack_safe_noop.dart';

/// Web entry point for the no_tapjack plugin.
///
/// Delegates to [NoTapjackSafeNoop] since tapjacking is not a real threat
/// on the web platform (browsers enforce same-origin policy; clickjacking
/// is a server-side concern handled by X-Frame-Options and CSP headers).
class NoTapjackWeb {
  static void registerWith(dynamic registrar) {
    NoTapjackSafeNoop.registerWith(registrar);
  }
}
