import type { AlignmentCenter } from './types';
import { ModuleType } from './types';

export class QrModuleResolver {
  private readonly moduleCount: number;
  private readonly centerClearModules: number;
  private readonly isDarkFn: (row: number, col: number) => boolean;
  readonly alignmentCenters: AlignmentCenter[];

  constructor(
    moduleCount: number,
    isDarkFn: (row: number, col: number) => boolean,
    centerClearModules: number,
  ) {
    this.moduleCount = moduleCount;
    this.isDarkFn = isDarkFn;
    this.centerClearModules = centerClearModules;
    this.alignmentCenters = QrModuleResolver.computeAlignmentCenters(moduleCount);
  }

  isDark(row: number, col: number): boolean {
    if (row < 0 || row >= this.moduleCount || col < 0 || col >= this.moduleCount) {
      return false;
    }
    return this.isDarkFn(row, col);
  }

  getModuleType(row: number, col: number): ModuleType {
    if (this.isInFinderPattern(row, col, 0, 0)) return ModuleType.FinderTopLeft;
    if (this.isInFinderPattern(row, col, 0, this.moduleCount - 7)) return ModuleType.FinderTopRight;
    if (this.isInFinderPattern(row, col, this.moduleCount - 7, 0)) return ModuleType.FinderBottomLeft;
    if (this.isInAlignmentPattern(row, col)) return ModuleType.Alignment;
    if (this.isInCenterSpace(row, col)) return ModuleType.CenterSpace;
    return ModuleType.Data;
  }

  hasNeighbor(row: number, col: number, dRow: number, dCol: number): boolean {
    const nr = row + dRow;
    const nc = col + dCol;
    if (nr < 0 || nr >= this.moduleCount || nc < 0 || nc >= this.moduleCount) {
      return false;
    }
    const neighborType = this.getModuleType(nr, nc);
    if (neighborType === ModuleType.CenterSpace || neighborType === ModuleType.Alignment) {
      return false;
    }
    if (neighborType !== ModuleType.Data) return false;
    return this.isDark(nr, nc);
  }

  private isInFinderPattern(row: number, col: number, startRow: number, startCol: number): boolean {
    return row >= startRow && row < startRow + 7 && col >= startCol && col < startCol + 7;
  }

  private isInAlignmentPattern(row: number, col: number): boolean {
    for (const center of this.alignmentCenters) {
      if (row >= center.row - 2 && row <= center.row + 2 && col >= center.col - 2 && col <= center.col + 2) {
        return true;
      }
    }
    return false;
  }

  private isInCenterSpace(row: number, col: number): boolean {
    const center = (this.moduleCount - 1) / 2;
    const half = this.centerClearModules / 2;
    const dx = Math.abs(row - center);
    const dy = Math.abs(col - center);
    if (dx > half || dy > half) return false;
    const innerHalf = half - 1.0;
    if (dx <= innerHalf && dy <= innerHalf) return true;
    const hash = (row * 31 + col * 17 + this.moduleCount * 7) & 0xFFFF;
    return hash % 4 !== 0;
  }

  private static computeAlignmentCenters(moduleCount: number): AlignmentCenter[] {
    const positions = QrModuleResolver.alignmentPositions(moduleCount);
    if (positions.length === 0) return [];

    const centers: AlignmentCenter[] = [];
    for (const row of positions) {
      for (const col of positions) {
        if (row <= 8 && col <= 8) continue;
        if (row <= 8 && col >= moduleCount - 8) continue;
        if (row >= moduleCount - 8 && col <= 8) continue;
        centers.push({ row, col });
      }
    }
    return centers;
  }

  private static alignmentPositions(moduleCount: number): number[] {
    const version = Math.floor((moduleCount - 17) / 4);
    if (version < 2) return [];

    const table: number[][] = [
      [], [],
      [6, 18], [6, 22], [6, 26], [6, 30], [6, 34],
      [6, 22, 38], [6, 24, 42], [6, 26, 46], [6, 28, 50],
      [6, 30, 54], [6, 32, 58], [6, 34, 62],
      [6, 26, 46, 66], [6, 26, 48, 70], [6, 26, 50, 74],
      [6, 30, 54, 78], [6, 30, 56, 82], [6, 30, 58, 86],
      [6, 34, 62, 90],
      [6, 28, 50, 72, 94], [6, 26, 50, 74, 98], [6, 30, 54, 78, 102],
      [6, 28, 54, 80, 106], [6, 32, 58, 84, 110], [6, 30, 58, 86, 114],
      [6, 34, 62, 90, 118],
      [6, 26, 50, 74, 98, 122], [6, 30, 54, 78, 102, 126],
      [6, 26, 52, 78, 104, 130], [6, 30, 56, 82, 108, 134],
      [6, 34, 60, 86, 112, 138], [6, 30, 58, 86, 114, 142],
      [6, 34, 62, 90, 118, 146],
      [6, 30, 54, 78, 102, 126, 150], [6, 24, 50, 76, 102, 128, 154],
      [6, 28, 54, 80, 106, 132, 158], [6, 32, 58, 84, 110, 136, 162],
      [6, 26, 54, 82, 110, 138, 166], [6, 30, 58, 86, 114, 142, 170],
    ];

    if (version >= table.length) return [];
    return table[version];
  }
}
