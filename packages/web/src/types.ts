export interface RealQrCodeOptions {
  data: string;
  size?: number;
  centerSpaceSize?: number;
  color?: string;
  backgroundColor?: string;
  borderRadius?: number;
  finderPatternRadiusFraction?: number;
  dataModuleRadiusFraction?: number;
}

export interface AlignmentCenter {
  row: number;
  col: number;
}

export enum ModuleType {
  FinderTopLeft = 'finderTopLeft',
  FinderTopRight = 'finderTopRight',
  FinderBottomLeft = 'finderBottomLeft',
  Alignment = 'alignment',
  Data = 'data',
  CenterSpace = 'centerSpace',
}
