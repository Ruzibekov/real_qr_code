import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:qr/qr.dart';

import 'qr_module_resolver.dart';

class RealQrCodePainter extends CustomPainter {
  final String data;
  final Color color;
  final Color backgroundColor;
  final double centerSpaceSize;
  final double finderPatternRadiusFraction;
  final double dataModuleRadiusFraction;
  final double borderRadius;

  late final QrCode _qrCode;
  late final QrImage _qrImage;
  late final Paint _modulePaint;
  late final Paint _bgPaint;

  RealQrCodePainter({
    required this.data,
    required this.color,
    required this.backgroundColor,
    required this.centerSpaceSize,
    required this.finderPatternRadiusFraction,
    required this.dataModuleRadiusFraction,
    required this.borderRadius,
  }) {
    _qrCode = QrCode.fromData(
      data: data,
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );
    _qrImage = QrImage(_qrCode);
    _modulePaint = Paint()..color = color;
    _bgPaint = Paint()..color = backgroundColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double qrSize = size.shortestSide;
    if (qrSize <= 0) return;

    final int moduleCount = _qrImage.moduleCount;
    final double moduleSize = qrSize / moduleCount;
    final int centerClearModules = (centerSpaceSize / moduleSize).ceil();

    final QrModuleResolver resolver = QrModuleResolver(
      qrImage: _qrImage,
      centerClearModules: centerClearModules,
    );

    final double finderRadius = moduleSize * finderPatternRadiusFraction;
    final double dataRadius = moduleSize * dataModuleRadiusFraction;

    final RRect clipRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, qrSize, qrSize),
      Radius.circular(borderRadius),
    );
    canvas.save();
    canvas.clipRRect(clipRect);
    canvas.drawPaint(_bgPaint);

    _drawDataModules(canvas, resolver, moduleCount, moduleSize, dataRadius);
    _drawFinderPattern(canvas, 0, 0, moduleSize, finderRadius);
    _drawFinderPattern(
      canvas, 0, (moduleCount - 7) * moduleSize, moduleSize, finderRadius,
    );
    _drawFinderPattern(
      canvas, (moduleCount - 7) * moduleSize, 0, moduleSize, finderRadius,
    );

    for (final center in resolver.alignmentCenters) {
      _drawAlignmentPattern(
        canvas,
        (center.row - 2) * moduleSize,
        (center.col - 2) * moduleSize,
        moduleSize,
        finderRadius * 0.6,
      );
    }

    canvas.restore();
  }

  void _drawDataModules(
    Canvas canvas,
    QrModuleResolver resolver,
    int moduleCount,
    double moduleSize,
    double radius,
  ) {
    final double maxRadius = moduleSize / 2;
    final double r = math.min(radius, maxRadius);

    for (int row = 0; row < moduleCount; row++) {
      for (int col = 0; col < moduleCount; col++) {
        final ModuleType type = resolver.getModuleType(row, col);
        if (type != ModuleType.data) continue;
        if (!resolver.isDark(row, col)) continue;

        final bool up = resolver.hasNeighbor(row, col, -1, 0);
        final bool down = resolver.hasNeighbor(row, col, 1, 0);
        final bool left = resolver.hasNeighbor(row, col, 0, -1);
        final bool right = resolver.hasNeighbor(row, col, 0, 1);

        final double tl = (up || left) ? 0 : r;
        final double tr = (up || right) ? 0 : r;
        final double bl = (down || left) ? 0 : r;
        final double br = (down || right) ? 0 : r;

        final RRect rRect = RRect.fromRectAndCorners(
          Rect.fromLTWH(
            col * moduleSize,
            row * moduleSize,
            moduleSize,
            moduleSize,
          ),
          topLeft: Radius.circular(tl),
          topRight: Radius.circular(tr),
          bottomLeft: Radius.circular(bl),
          bottomRight: Radius.circular(br),
        );

        canvas.drawRRect(rRect, _modulePaint);
      }
    }
  }

  void _drawFinderPattern(
    Canvas canvas,
    double top,
    double left,
    double moduleSize,
    double radius,
  ) {
    final double patternSize = moduleSize * 7;

    final RRect outer = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, patternSize, patternSize),
      Radius.circular(radius),
    );
    canvas.drawRRect(outer, _modulePaint);

    final double gapInset = moduleSize;
    final RRect inner = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        left + gapInset,
        top + gapInset,
        patternSize - gapInset * 2,
        patternSize - gapInset * 2,
      ),
      Radius.circular(radius * 0.7),
    );
    canvas.drawRRect(inner, _bgPaint);

    final double dotInset = moduleSize * 2;
    final RRect dot = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        left + dotInset,
        top + dotInset,
        patternSize - dotInset * 2,
        patternSize - dotInset * 2,
      ),
      Radius.circular(radius * 0.5),
    );
    canvas.drawRRect(dot, _modulePaint);
  }

  void _drawAlignmentPattern(
    Canvas canvas,
    double top,
    double left,
    double moduleSize,
    double radius,
  ) {
    final double patternSize = moduleSize * 5;

    final RRect outer = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, patternSize, patternSize),
      Radius.circular(radius),
    );
    canvas.drawRRect(outer, _modulePaint);

    final double gapInset = moduleSize;
    final RRect inner = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        left + gapInset,
        top + gapInset,
        patternSize - gapInset * 2,
        patternSize - gapInset * 2,
      ),
      Radius.circular(radius * 0.6),
    );
    canvas.drawRRect(inner, _bgPaint);

    final double dotInset = moduleSize * 2;
    final RRect dot = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        left + dotInset,
        top + dotInset,
        patternSize - dotInset * 2,
        patternSize - dotInset * 2,
      ),
      Radius.circular(radius * 0.3),
    );
    canvas.drawRRect(dot, _modulePaint);
  }

  @override
  bool shouldRepaint(covariant RealQrCodePainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.centerSpaceSize != centerSpaceSize ||
        oldDelegate.finderPatternRadiusFraction !=
            finderPatternRadiusFraction ||
        oldDelegate.dataModuleRadiusFraction != dataModuleRadiusFraction ||
        oldDelegate.borderRadius != borderRadius;
  }
}
