import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/features/reports/widgets/occupancy_chart.dart';

void main() {
  testWidgets('OccupancyChart renders core components', (tester) async {
    // 1. Arrange
    final data = [0.5, 0.7, 0.2, 0.9, 0.6, 0.8, 0.4];

    // 2. Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 300,
            width: 400,
            child: OccupancyChart(data: data),
          ),
        ),
      ),
    );

    // 3. Assert
    expect(find.byType(LineChart), findsOneWidget);
    // You can't easy verify the lines, but verifying the widget renders is good.
  });
}
