import 'package:flutter/material.dart';
import 'package:shopping_app/const/AppColors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.label, this.onPressed});
  final String label;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      height: 42,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.text_bold_Color,
          ),
        ),
      ),
    );
  }
}
