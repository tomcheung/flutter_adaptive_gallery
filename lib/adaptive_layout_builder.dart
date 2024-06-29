import 'package:flutter/material.dart';

enum LayoutSizeData { large, medium, small }

class AdaptiveLayoutBuilder extends StatelessWidget {
  final Widget Function(LayoutSizeData) layoutBuilder;

  const AdaptiveLayoutBuilder({
    super.key,
    required this.layoutBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    LayoutSizeData size = switch (width) {
      >= 800 => LayoutSizeData.large,
      >= 600 => LayoutSizeData.medium,
      _ => LayoutSizeData.small
    };

    return layoutBuilder(size);
  }
}

class LayoutSize extends InheritedWidget {
  final LayoutSizeData size;

  const LayoutSize({super.key, required this.size, required super.child});

  @override
  bool updateShouldNotify(covariant LayoutSize oldWidget) {
    return oldWidget.size != size;
  }

  static LayoutSizeData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LayoutSize>()!.size;
  }
}