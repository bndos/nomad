import 'package:flutter/material.dart';

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final String? textLabel;

  const RoundedIconButton({
    Key? key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.textLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0, // Set elevation to 0 to remove the shadow
            backgroundColor: Colors.grey[100], // Pale grey background color
            foregroundColor: Colors.black, // Black foreground color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          ),
          onPressed: onPressed,
          child: Column(
            children: [
              if (textLabel != null)
                Text(
                  textLabel!,
                  style: TextStyle(
                    // a subtle, light, grey text style
                    color: Colors.grey[600],
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16.0),
                  const SizedBox(width: 8.0),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 12.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
