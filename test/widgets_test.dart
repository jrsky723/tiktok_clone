import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiktok_clone/features/authentication/views/widgets/form_button.dart';

void main() {
  group(
    "Form Button Tests",
    () {
      testWidgets("Enables State", (WidgetTester tester) async {
        await tester.pumpWidget(
          Theme(
            data: ThemeData(
              primaryColor: Colors.red,
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: FormButton(
                disabled: false,
                text: "text",
                onTap: () {},
              ),
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

        expect(
          (tester
                  .firstWidget<AnimatedContainer>(
                      find.byType(AnimatedContainer))
                  .decoration as BoxDecoration)
              .color,
          Colors.red,
        );
      });

      testWidgets(
        "Disabled State",
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: FormButton(
                  disabled: true,
                  text: "text",
                  onTap: () {},
                ),
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
            Colors.grey.shade400,
          );
        },
      );

      testWidgets(
        "Disabled State Dark Mode",
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(
                platformBrightness: Brightness.dark,
              ),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: FormButton(
                  disabled: true,
                  text: "text",
                  onTap: () {},
                ),
              ),
            ),
          );
          expect(
            (tester
                    .firstWidget<AnimatedContainer>(
                        find.byType(AnimatedContainer))
                    .decoration as BoxDecoration)
                .color,
            Colors.grey.shade800,
          );
        },
      );
      testWidgets(
        "Disabled State Light Mode",
        (WidgetTester tester) async {
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(
                platformBrightness: Brightness.light,
              ),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: FormButton(
                  disabled: true,
                  text: "text",
                  onTap: () {},
                ),
              ),
            ),
          );
          expect(
            (tester
                    .firstWidget<AnimatedContainer>(
                        find.byType(AnimatedContainer))
                    .decoration as BoxDecoration)
                .color,
            Colors.grey.shade300,
          );
        },
      );
    },
  );
}
