# real_qr_code

A Flutter package for generating stylized QR codes with rounded finder patterns, blob-effect data modules, and a center space for logo overlay.

## Features

- Rounded finder patterns (3 corners)
- Blob effect — adjacent data modules merge into organic shapes
- Rounded alignment patterns
- Center space for logo overlay
- Customizable colors, border radius, and module radius
- Error correction level H (30%) for reliable scanning
- Responsive sizing — adapts to parent constraints

## Usage

```dart
import 'package:real_qr_code/real_qr_code.dart';

RealQrCode(
  data: 'https://example.com',
  size: 300,
  centerSpaceSize: 80,
  color: Color(0xFF0E121B),
  backgroundColor: Color(0xFFF7F8F9),
  borderRadius: 16,
  logo: Icon(Icons.star, size: 48),
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | `String` | required | QR code content |
| `size` | `double?` | parent size | QR code size in pixels |
| `centerSpaceSize` | `double` | `80` | Center clear zone for logo |
| `color` | `Color` | `#0E121B` | Module color |
| `backgroundColor` | `Color` | `#F7F8F9` | Background color |
| `logo` | `Widget?` | `null` | Logo widget (centered) |
| `borderRadius` | `double` | `16` | Outer corner radius |
| `finderPatternRadiusFraction` | `double` | `1.2` | Finder pattern roundness (relative to module size) |
| `dataModuleRadiusFraction` | `double` | `0.45` | Data module roundness (relative to module size) |

## Web version

An npm package is also available at `packages/web/` for use in web projects (Nuxt, React, Vue, vanilla JS).

```js
import { renderQrCode } from 'real-qr-code';

renderQrCode(document.getElementById('qr'), {
  data: 'https://example.com',
  size: 300,
});
```
