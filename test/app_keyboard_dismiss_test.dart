import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/app.dart';

void main() {
  testWidgets('app surface dismisses text field focus on outside tap',
      (tester) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      KeyboardDismissSurface(
        child: MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                TextField(focusNode: focusNode),
                const Expanded(
                  child: ColoredBox(
                    key: Key('outside-surface'),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();

    expect(focusNode.hasFocus, isTrue);

    await tester.tapAt(
      tester.getCenter(find.byKey(const Key('outside-surface'))),
    );
    await tester.pump();

    expect(focusNode.hasFocus, isFalse);
  });
}
