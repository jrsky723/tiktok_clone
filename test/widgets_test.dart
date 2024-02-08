import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_clone/features/authentication/views/widgets/form_button.dart';

void main() {
  group("Form Button Tests", () {
    testWidgets("Enables State", (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: FormButton(
            disabled: false,
            text: "text",
            onTap: () {},
          ),
        ),
      );

      expect(find.text("text"), findsOneWidget);
      expect(
        tester
            .firstWidget<AnimatedDefaultTextStyle>(
                find.byType(AnimatedDefaultTextStyle))
            .style
            .color,
        Colors.white,
      );
    });
  });
}
