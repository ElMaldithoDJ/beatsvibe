import 'package:flutter/material.dart' show IconData;

class SettingsOptionsModel {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final String? route;

  SettingsOptionsModel({
    required this.title,
    this.subtitle,
    this.icon,
    this.route,
  });
}