import 'package:flutter/material.dart';

const lightGreyColor = Color(0xFFF2F2F2);

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final String? textLabel;
  final bool isDisabled; // New property for disabled state
  final Color color;
  final Color iconColor;
  final Color foregroundColor;

  const RoundedIconButton({
    Key? key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.textLabel,
    this.isDisabled = false, // Set default value to false
    this.color = lightGreyColor,
    this.iconColor = Colors.black,
    this.foregroundColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0, // Set elevation to 0 to remove the shadow
            backgroundColor: isDisabled
                ? Colors.grey[50]
                : color, // Use different background color for disabled state
            foregroundColor: foregroundColor, // Black foreground color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
          ),
          onPressed: isDisabled
              ? () => {}
              : onPressed, // Disable onPressed when isDisabled is true
          child: Column(
            children: [
              if (textLabel != null)
                Text(
                  textLabel!,
                  style: TextStyle(
                    color: isDisabled
                        ? Colors.grey[400]
                        : Colors.grey[
                            600], // Use different text color for disabled state
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              if (textLabel != null) const SizedBox(height: 3.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 16.0,
                    color: isDisabled
                        ? Colors.grey[400]
                        : iconColor, // Reduce opacity of the icon when disabled
                  ),
                  const SizedBox(width: 8.0),
                  Flexible(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: isDisabled
                            ? Colors.grey[400]
                            : null, // Reduce opacity of the text when disabled
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
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
