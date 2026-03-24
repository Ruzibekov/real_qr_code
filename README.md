# real_qr_code

A stylized QR code generator with rounded finder patterns, blob-effect data modules, and a center space for logo overlay.

Available for **Flutter** (pub.dev) and **Web** (npm).

<p align="center">
  <img src="assets/screenshot.png" width="280" alt="Real QR Code example" />
</p>

## Flutter

### Installation

```yaml
dependencies:
  real_qr_code: ^0.0.1
```

### Usage

```dart
import 'package:real_qr_code/real_qr_code.dart';

RealQrCode(
  data: 'https://example.com',
  size: 300,
  logo: Icon(Icons.flutter_dash, size: 48),
)
```

### With custom styling

```dart
RealQrCode(
  data: 'https://example.com',
  size: 300,
  centerSpaceSize: 80,
  color: Color(0xFF0E121B),
  backgroundColor: Color(0xFFF7F8F9),
  borderRadius: 16,
  finderPatternRadiusFraction: 1.2,
  dataModuleRadiusFraction: 0.45,
  logo: Image.asset('assets/logo.png', width: 48, height: 48),
)
```

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | `String` | **required** | QR code content |
| `size` | `double?` | parent size | QR code size in pixels |
| `centerSpaceSize` | `double` | `80` | Center clear zone size |
| `color` | `Color` | `#0E121B` | Module color |
| `backgroundColor` | `Color` | `#F7F8F9` | Background color |
| `logo` | `Widget?` | `null` | Widget centered over QR |
| `borderRadius` | `double` | `16` | Outer corner radius |
| `finderPatternRadiusFraction` | `double` | `1.2` | Finder pattern roundness |
| `dataModuleRadiusFraction` | `double` | `0.45` | Data module roundness |

If `size` is not specified, the widget adapts to parent constraints via `LayoutBuilder`.

The `logo` widget is rendered via `Stack` + `Center`, so any widget works — `Icon`, `Image`, `SvgPicture`, etc. Logo color automatically inherits the QR `color` through `IconTheme`.

---

## Web (npm)

An SVG-based QR code generator for any web framework — React, Vue, Nuxt, Svelte, or vanilla JS.

### Installation

```bash
npm install real-qr-code
```

### Usage

```js
import { renderQrCode } from 'real-qr-code';

renderQrCode(document.getElementById('qr'), {
  data: 'https://example.com',
  size: 300,
});
```

### Get SVG string

```js
import { generateQrCodeSvg } from 'real-qr-code';

const svg = generateQrCodeSvg({
  data: 'https://example.com',
  size: 300,
  color: '#0E121B',
  backgroundColor: '#F7F8F9',
});
```

### Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `data` | `string` | **required** | QR code content |
| `size` | `number` | `256` | Size in pixels |
| `centerSpaceSize` | `number` | `80` | Center clear zone |
| `color` | `string` | `'#0E121B'` | Module color |
| `backgroundColor` | `string` | `'#F7F8F9'` | Background color |
| `borderRadius` | `number` | `16` | Outer corner radius |
| `finderPatternRadiusFraction` | `number` | `1.2` | Finder pattern roundness |
| `dataModuleRadiusFraction` | `number` | `0.45` | Data module roundness |

### Framework examples

**React**
```tsx
import { useRef, useEffect } from 'react';
import { renderQrCode } from 'real-qr-code';

function QrCode({ data }: { data: string }) {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (ref.current) {
      renderQrCode(ref.current, { data, size: 300 });
    }
  }, [data]);

  return <div ref={ref} />;
}
```

**Vue**
```vue
<template>
  <div ref="qrRef" />
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { renderQrCode } from 'real-qr-code';

const qrRef = ref<HTMLDivElement>();

onMounted(() => {
  if (qrRef.value) {
    renderQrCode(qrRef.value, { data: 'https://example.com', size: 300 });
  }
});
</script>
```

**Vanilla JS**
```html
<div id="qr"></div>
<script type="module">
  import { renderQrCode } from 'real-qr-code';
  renderQrCode(document.getElementById('qr'), {
    data: 'https://example.com',
    size: 300,
  });
</script>
```

---

## Features

- **Rounded finder patterns** — three corner markers with smooth rounded rectangles
- **Blob effect** — adjacent data modules merge into organic shapes
- **Rounded alignment patterns** — small 5x5 markers styled consistently
- **Center logo space** — 80dp clear zone for logo overlay
- **Error correction H (30%)** — reliable scanning even with center obstruction
- **Responsive sizing** — adapts to parent/container when size is not set

## How it works

The QR matrix is generated using [`qr`](https://pub.dev/packages/qr) (Flutter) / [`qrcode-generator`](https://www.npmjs.com/package/qrcode-generator) (Web). Each module is then rendered with per-corner radius based on neighbor detection:

```
if neighbor exists → radius = 0 (modules merge)
if no neighbor    → radius = dataModuleRadius (rounded corner)
```

This creates the distinctive blob effect where clusters of dark modules flow together organically.

## License

MIT
