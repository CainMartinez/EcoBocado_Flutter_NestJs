import 'package:flutter/material.dart';

class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.contentPadding,
    this.secondary,
    this.icon,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? subtitle;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? secondary;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      title: Text(label),
      subtitle: subtitle == null ? null : Text(subtitle!),
      contentPadding: contentPadding,
      secondary: secondary ?? (icon != null ? Icon(icon) : null),
      onChanged: onChanged,
    );
  }
}
