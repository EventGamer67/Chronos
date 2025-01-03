import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdaptiveLayout extends ConsumerWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const AdaptiveLayout({
    required this.mobile, required this.desktop, super.key,
    this.tablet,
  });

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return LayoutBuilder(
      builder: (final context, final constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktop;
        } else if (constraints.maxWidth >= 600) {
          return tablet ?? desktop;
        } else {
          return mobile;
        }
      },
    );
  }
} 
