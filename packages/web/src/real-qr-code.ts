import qrcode from 'qrcode-generator';
import { QrModuleResolver } from './qr-module-resolver';
import { ModuleType, type RealQrCodeOptions } from './types';

const DEFAULTS: Required<Omit<RealQrCodeOptions, 'data'>> = {
  size: 300,
  centerSpaceSize: 80,
  color: '#0E121B',
  backgroundColor: '#F7F8F9',
  borderRadius: 16,
  finderPatternRadiusFraction: 1.2,
  dataModuleRadiusFraction: 0.45,
};

export function generateQrCodeSvg(options: RealQrCodeOptions): string {
  const opts = { ...DEFAULTS, ...options };
  const { data, size, centerSpaceSize, color, backgroundColor, borderRadius } = opts;

  const qr = qrcode(0, 'H');
  qr.addData(data);
  qr.make();

  const moduleCount = qr.getModuleCount();
  const moduleSize = size / moduleCount;
  const centerClearModules = Math.ceil(centerSpaceSize / moduleSize);
  const finderRadius = moduleSize * opts.finderPatternRadiusFraction;
  const dataRadius = Math.min(moduleSize * opts.dataModuleRadiusFraction, moduleSize / 2);

  const resolver = new QrModuleResolver(
    moduleCount,
    (row, col) => qr.isDark(row, col),
    centerClearModules,
  );

  const paths: string[] = [];

  paths.push(buildBackground(size, borderRadius, backgroundColor));
  paths.push(buildDataModules(resolver, moduleCount, moduleSize, dataRadius, color));
  paths.push(buildFinderPattern(0, 0, moduleSize, finderRadius, color, backgroundColor));
  paths.push(buildFinderPattern(0, (moduleCount - 7) * moduleSize, moduleSize, finderRadius, color, backgroundColor));
  paths.push(buildFinderPattern((moduleCount - 7) * moduleSize, 0, moduleSize, finderRadius, color, backgroundColor));

  for (const center of resolver.alignmentCenters) {
    paths.push(buildAlignmentPattern(
      (center.row - 2) * moduleSize,
      (center.col - 2) * moduleSize,
      moduleSize,
      finderRadius * 0.6,
      color,
      backgroundColor,
    ));
  }

  return [
    `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${size} ${size}" width="${size}" height="${size}">`,
    `<defs><clipPath id="qr-clip"><rect width="${size}" height="${size}" rx="${borderRadius}" ry="${borderRadius}"/></clipPath></defs>`,
    `<g clip-path="url(#qr-clip)">`,
    ...paths,
    `</g>`,
    `</svg>`,
  ].join('');
}

export function renderQrCode(container: HTMLElement, options: RealQrCodeOptions): void {
  const svg = generateQrCodeSvg(options);
  const parser = new DOMParser();
  const doc = parser.parseFromString(svg, 'image/svg+xml');
  const svgElement = doc.documentElement;
  container.replaceChildren(svgElement);
}

function buildBackground(size: number, borderRadius: number, color: string): string {
  return `<rect width="${size}" height="${size}" rx="${borderRadius}" ry="${borderRadius}" fill="${color}"/>`;
}

function buildDataModules(
  resolver: QrModuleResolver,
  moduleCount: number,
  moduleSize: number,
  radius: number,
  color: string,
): string {
  const rects: string[] = [];

  for (let row = 0; row < moduleCount; row++) {
    for (let col = 0; col < moduleCount; col++) {
      const type = resolver.getModuleType(row, col);
      if (type !== ModuleType.Data) continue;
      if (!resolver.isDark(row, col)) continue;

      const up = resolver.hasNeighbor(row, col, -1, 0);
      const down = resolver.hasNeighbor(row, col, 1, 0);
      const left = resolver.hasNeighbor(row, col, 0, -1);
      const right = resolver.hasNeighbor(row, col, 0, 1);

      const tl = (up || left) ? 0 : radius;
      const tr = (up || right) ? 0 : radius;
      const bl = (down || left) ? 0 : radius;
      const br = (down || right) ? 0 : radius;

      const x = col * moduleSize;
      const y = row * moduleSize;

      rects.push(roundedRect(x, y, moduleSize, moduleSize, tl, tr, br, bl, color));
    }
  }

  return rects.join('');
}

function buildFinderPattern(
  top: number,
  left: number,
  moduleSize: number,
  radius: number,
  color: string,
  bgColor: string,
): string {
  const patternSize = moduleSize * 7;
  const gapInset = moduleSize;
  const dotInset = moduleSize * 2;

  const outer = `<rect x="${left}" y="${top}" width="${patternSize}" height="${patternSize}" rx="${radius}" ry="${radius}" fill="${color}"/>`;
  const inner = `<rect x="${left + gapInset}" y="${top + gapInset}" width="${patternSize - gapInset * 2}" height="${patternSize - gapInset * 2}" rx="${radius * 0.7}" ry="${radius * 0.7}" fill="${bgColor}"/>`;
  const dot = `<rect x="${left + dotInset}" y="${top + dotInset}" width="${patternSize - dotInset * 2}" height="${patternSize - dotInset * 2}" rx="${radius * 0.5}" ry="${radius * 0.5}" fill="${color}"/>`;

  return outer + inner + dot;
}

function buildAlignmentPattern(
  top: number,
  left: number,
  moduleSize: number,
  radius: number,
  color: string,
  bgColor: string,
): string {
  const patternSize = moduleSize * 5;
  const gapInset = moduleSize;
  const dotInset = moduleSize * 2;

  const outer = `<rect x="${left}" y="${top}" width="${patternSize}" height="${patternSize}" rx="${radius}" ry="${radius}" fill="${color}"/>`;
  const inner = `<rect x="${left + gapInset}" y="${top + gapInset}" width="${patternSize - gapInset * 2}" height="${patternSize - gapInset * 2}" rx="${radius * 0.6}" ry="${radius * 0.6}" fill="${bgColor}"/>`;
  const dot = `<rect x="${left + dotInset}" y="${top + dotInset}" width="${patternSize - dotInset * 2}" height="${patternSize - dotInset * 2}" rx="${radius * 0.3}" ry="${radius * 0.3}" fill="${color}"/>`;

  return outer + inner + dot;
}

function roundedRect(
  x: number, y: number, w: number, h: number,
  tl: number, tr: number, br: number, bl: number,
  fill: string,
): string {
  if (tl === 0 && tr === 0 && br === 0 && bl === 0) {
    return `<rect x="${x}" y="${y}" width="${w}" height="${h}" fill="${fill}"/>`;
  }

  const d = [
    `M${x + tl},${y}`,
    `H${x + w - tr}`,
    tr ? `A${tr},${tr} 0 0 1 ${x + w},${y + tr}` : `H${x + w}`,
    `V${y + h - br}`,
    br ? `A${br},${br} 0 0 1 ${x + w - br},${y + h}` : `V${y + h}`,
    `H${x + bl}`,
    bl ? `A${bl},${bl} 0 0 1 ${x},${y + h - bl}` : `H${x}`,
    `V${y + tl}`,
    tl ? `A${tl},${tl} 0 0 1 ${x + tl},${y}` : `V${y}`,
    'Z',
  ].join(' ');

  return `<path d="${d}" fill="${fill}"/>`;
}
