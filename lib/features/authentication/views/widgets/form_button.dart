import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

class FormButton extends StatelessWidget {
  const FormButton({
    super.key,
    required this.disabled,
    required this.text,
    required this.onTap,
  });

  final bool disabled;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: AnimatedContainer(
          padding: const EdgeInsets.symmetric(
            vertical: Sizes.size16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizes.size5),
            color: disabled
                ? isDarkMode(context)
                    ? Colors.grey.shade800
                    : Colors.grey.shade300
                : Theme.of(context).primaryColor,
          ),
          duration: const Duration(milliseconds: 500),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 500),
            style: TextStyle(
              color: disabled ? Colors.grey.shade400 : Colors.white,
              fontWeight: FontWeight.w600,
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: Sizes.size16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
