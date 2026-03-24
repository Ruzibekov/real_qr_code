import 'package:flutter/widgets.dart';

import 'real_qr_code_painter.dart';

class RealQrCode extends StatelessWidget {
  final String data;
  final double? size;
  final double centerSpaceSize;
  final Color color;
  final Color backgroundColor;
  final Widget? logo;
  final double borderRadius;
  final double finderPatternRadiusFraction;
  final double dataModuleRadiusFraction;

  const RealQrCode({
    super.key,
    required this.data,
    this.size,
    this.centerSpaceSize = 80,
    this.color = const Color(0xFF0E121B),
    this.backgroundColor = const Color(0xFFF7F8F9),
    this.logo,
    this.borderRadius = 16,
    this.finderPatternRadiusFraction = 1.2,
    this.dataModuleRadiusFraction = 0.45,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double resolvedSize = size ??
            constraints.biggest.shortestSide.clamp(0, double.infinity);

        return SizedBox(
          width: resolvedSize,
          height: resolvedSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(resolvedSize, resolvedSize),
                painter: RealQrCodePainter(
                  data: data,
                  color: color,
                  backgroundColor: backgroundColor,
                  centerSpaceSize: centerSpaceSize,
                  finderPatternRadiusFraction: finderPatternRadiusFraction,
                  dataModuleRadiusFraction: dataModuleRadiusFraction,
                  borderRadius: borderRadius,
                ),
              ),
              if (logo != null)
                IconTheme(
                  data: IconThemeData(color: color),
                  child: SizedBox(
                    width: centerSpaceSize,
                    height: centerSpaceSize,
                    child: logo,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
