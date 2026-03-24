import 'package:qr/qr.dart';

enum ModuleType {
  finderTopLeft,
  finderTopRight,
  finderBottomLeft,
  alignment,
  data,
  centerSpace,
}

class QrModuleResolver {
  final QrImage _qrImage;
  final int _moduleCount;
  final int _centerClearModules;
  final List<AlignmentCenter> _alignmentCenters;

  QrModuleResolver({
    required QrImage qrImage,
    required int centerClearModules,
  })  : _qrImage = qrImage,
        _moduleCount = qrImage.moduleCount,
        _centerClearModules = centerClearModules,
        _alignmentCenters = _computeAlignmentCenters(qrImage.moduleCount);

  int get moduleCount => _moduleCount;

  List<AlignmentCenter> get alignmentCenters => _alignmentCenters;

  bool isDark(int row, int col) {
    if (row < 0 || row >= _moduleCount || col < 0 || col >= _moduleCount) {
      return false;
    }
    return _qrImage.isDark(row, col);
  }

  ModuleType getModuleType(int row, int col) {
    if (_isInFinderPattern(row, col, 0, 0)) return ModuleType.finderTopLeft;
    if (_isInFinderPattern(row, col, 0, _moduleCount - 7)) {
      return ModuleType.finderTopRight;
    }
    if (_isInFinderPattern(row, col, _moduleCount - 7, 0)) {
      return ModuleType.finderBottomLeft;
    }
    if (_isInAlignmentPattern(row, col)) return ModuleType.alignment;
    if (_isInCenterSpace(row, col)) return ModuleType.centerSpace;
    return ModuleType.data;
  }

  bool _isInFinderPattern(int row, int col, int startRow, int startCol) {
    return row >= startRow &&
        row < startRow + 7 &&
        col >= startCol &&
        col < startCol + 7;
  }

  bool _isInAlignmentPattern(int row, int col) {
    for (final center in _alignmentCenters) {
      if (row >= center.row - 2 &&
          row <= center.row + 2 &&
          col >= center.col - 2 &&
          col <= center.col + 2) {
        return true;
      }
    }
    return false;
  }

  bool _isInCenterSpace(int row, int col) {
    final double center = (_moduleCount - 1) / 2.0;
    final double half = _centerClearModules / 2.0;
    final double dx = (row - center).abs();
    final double dy = (col - center).abs();
    if (dx > half || dy > half) return false;
    final double innerHalf = half - 1.0;
    if (dx <= innerHalf && dy <= innerHalf) return true;
    final int hash = (row * 31 + col * 17 + _moduleCount * 7) & 0xFFFF;
    return hash % 4 != 0;
  }

  bool hasNeighbor(int row, int col, int dRow, int dCol) {
    final int nr = row + dRow;
    final int nc = col + dCol;
    if (nr < 0 || nr >= _moduleCount || nc < 0 || nc >= _moduleCount) {
      return false;
    }
    final ModuleType neighborType = getModuleType(nr, nc);
    if (neighborType == ModuleType.centerSpace ||
        neighborType == ModuleType.alignment) {
      return false;
    }
    if (neighborType != ModuleType.data) return false;
    return isDark(nr, nc);
  }

  static List<AlignmentCenter> _computeAlignmentCenters(int moduleCount) {
    final List<int> positions = _alignmentPositions(moduleCount);
    if (positions.isEmpty) return [];

    final List<AlignmentCenter> centers = [];
    for (final int row in positions) {
      for (final int col in positions) {
        if (row <= 8 && col <= 8) continue;
        if (row <= 8 && col >= moduleCount - 8) continue;
        if (row >= moduleCount - 8 && col <= 8) continue;
        centers.add(AlignmentCenter(row, col));
      }
    }
    return centers;
  }

  static List<int> _alignmentPositions(int moduleCount) {
    final int version = (moduleCount - 17) ~/ 4;
    if (version < 2) return [];

    const List<List<int>> table = [
      [], // v0
      [], // v1
      [6, 18], // v2
      [6, 22], // v3
      [6, 26], // v4
      [6, 30], // v5
      [6, 34], // v6
      [6, 22, 38], // v7
      [6, 24, 42], // v8
      [6, 26, 46], // v9
      [6, 28, 50], // v10
      [6, 30, 54], // v11
      [6, 32, 58], // v12
      [6, 34, 62], // v13
      [6, 26, 46, 66], // v14
      [6, 26, 48, 70], // v15
      [6, 26, 50, 74], // v16
      [6, 30, 54, 78], // v17
      [6, 30, 56, 82], // v18
      [6, 30, 58, 86], // v19
      [6, 34, 62, 90], // v20
      [6, 28, 50, 72, 94], // v21
      [6, 26, 50, 74, 98], // v22
      [6, 30, 54, 78, 102], // v23
      [6, 28, 54, 80, 106], // v24
      [6, 32, 58, 84, 110], // v25
      [6, 30, 58, 86, 114], // v26
      [6, 34, 62, 90, 118], // v27
      [6, 26, 50, 74, 98, 122], // v28
      [6, 30, 54, 78, 102, 126], // v29
      [6, 26, 52, 78, 104, 130], // v30
      [6, 30, 56, 82, 108, 134], // v31
      [6, 34, 60, 86, 112, 138], // v32
      [6, 30, 58, 86, 114, 142], // v33
      [6, 34, 62, 90, 118, 146], // v34
      [6, 30, 54, 78, 102, 126, 150], // v35
      [6, 24, 50, 76, 102, 128, 154], // v36
      [6, 28, 54, 80, 106, 132, 158], // v37
      [6, 32, 58, 84, 110, 136, 162], // v38
      [6, 26, 54, 82, 110, 138, 166], // v39
      [6, 30, 58, 86, 114, 142, 170], // v40
    ];

    if (version >= table.length) return [];
    return table[version];
  }
}

class AlignmentCenter {
  final int row;
  final int col;

  const AlignmentCenter(this.row, this.col);
}
