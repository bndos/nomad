import 'package:flutter/material.dart';

const lightGreyColor = Color(0xFFF2F2F2);

class RoundedIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final String? textLabel;
  final bool isDisabled;
  final bool expanded;
  final Color color;
  final Color? containerColor;
  final Color iconColor;
  final Color? labelColor;
  final Color foregroundColor;
  final double? height;
  final double? width;
  final double radius;

  const RoundedIconButton({
    Key? key,
    required this.icon,
    required this.label,
    this.onPressed,
    this.textLabel,
    this.isDisabled = false, // Set default value to false
    this.color = lightGreyColor,
    this.containerColor,
    this.iconColor = Colors.black,
    this.labelColor,
    this.foregroundColor = Colors.black,
    this.height,
    this.width,
    this.expanded = true,
    this.radius = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return expanded
        ? Expanded(
            child: RoundedButtonContainer(
              icon: icon,
              label: label,
              onPressed: onPressed,
              textLabel: textLabel,
              isDisabled: isDisabled,
              color: color,
              containerColor: containerColor,
              iconColor: iconColor,
              labelColor: labelColor,
              foregroundColor: foregroundColor,
              height: height,
              width: width,
              radius: radius,
            ),
          )
        : RoundedButtonContainer(
            icon: icon,
            label: label,
            onPressed: onPressed,
            textLabel: textLabel,
            isDisabled: isDisabled,
            color: color,
            labelColor: labelColor,
            containerColor: containerColor,
            iconColor: iconColor,
            foregroundColor: foregroundColor,
            height: height,
            width: width,
            radius: radius,
          );
  }
}

class RoundedButtonContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final double radius;
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final String? textLabel;
  final bool isDisabled;
  final Color color;
  final Color? containerColor;
  final Color iconColor;
  final Color? labelColor;
  final Color foregroundColor;

  const RoundedButtonContainer({
    Key? key,
    this.height,
    this.width,
    this.onPressed,
    required this.icon,
    required this.label,
    this.textLabel,
    this.isDisabled = false,
    this.color = lightGreyColor,
    this.containerColor,
    this.labelColor,
    this.iconColor = Colors.black,
    this.foregroundColor = Colors.black,
    this.radius = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isDisabled ? Colors.grey[50] : color,
          foregroundColor: foregroundColor, // Black foreground color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
        ),
        onPressed: isDisabled
            ? () => {}
            : onPressed, // Disable onPressed when isDisabled is true
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                if (label.isNotEmpty) const SizedBox(width: 8.0),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: isDisabled
                          ? Colors.grey[400]
                          : labelColor, // Reduce opacity of the text when disabled
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
