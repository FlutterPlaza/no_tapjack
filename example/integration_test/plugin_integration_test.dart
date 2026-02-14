import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:no_tapjack/no_tapjack.dart';
import 'package:no_tapjack/tapjack_snapshot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('startListening and tapjackStream test', (
    WidgetTester tester,
  ) async {
    final plugin = NoTapjack.instance;
    await plugin.startListening();

    expect(plugin.tapjackStream, isInstanceOf<Stream<TapjackSnapshot>>());

    await plugin.stopListening();
  });
}
