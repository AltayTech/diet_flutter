part of sizer;

/// Provides `Context`, `Orientation`, and `DeviceType` parameters to the builder function
typedef ResponsiveBuild = Widget Function(
    BuildContext context,
    Orientation orientation,
    DeviceType deviceType,
    BoxConstraints constraints,
    );

/// A widget that gets the device's details like orientation and constraints
///
/// Usage: Wrap MaterialApp with this widget
class Sizer extends StatelessWidget {
  const Sizer({
    Key? key,
    required this.builder,
    this.minRatio,
    this.maxWidth,
    this.maxHeight,
  }) : super(key: key);

  /// Builds the widget whenever the orientation changes
  final ResponsiveBuild builder;
  final double? minRatio;
  final double? maxWidth;
  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizerUtil.setScreenSize(
          constraints: constraints,
          currentOrientation: orientation,
          minRatio: minRatio,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        );
        final newConstraints = BoxConstraints(
          maxWidth: SizerUtil.width,
          maxHeight: SizerUtil.height,
        );
        return builder(
          context,
          orientation,
          SizerUtil.deviceType,
          constraints.enforce(newConstraints),
        );
      });
    });
  }
}
