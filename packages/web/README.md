# real-qr-code

Stylized QR code generator with rounded finder patterns, blob-effect data modules, and center logo space. Outputs clean SVG — works with any web framework.

<p align="center">
  <img src="../../assets/screenshot.png" width="280" alt="Real QR Code example" />
</p>

## Installation

```bash
npm install real-qr-code
```

## Quick start

```js
import { renderQrCode } from 'real-qr-code';

renderQrCode(document.getElementById('qr'), {
  data: 'https://example.com',
  size: 300,
});
```

## API

### `renderQrCode(container, options)`

Renders an SVG QR code into the given DOM element.

```js
import { renderQrCode } from 'real-qr-code';

const container = document.getElementById('qr');
renderQrCode(container, {
  data: 'https://example.com',
  size: 300,
  color: '#0E121B',
  backgroundColor: '#F7F8F9',
});
```

### `generateQrCodeSvg(options)`

Returns the QR code as an SVG string. Useful for SSR or when you need the raw markup.

```js
import { generateQrCodeSvg } from 'real-qr-code';

const svg = generateQrCodeSvg({
  data: 'https://example.com',
  size: 300,
});
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `data` | `string` | **required** | QR code content |
| `size` | `number` | `256` | Size in pixels |
| `centerSpaceSize` | `number` | `80` | Center clear zone for logo |
| `color` | `string` | `'#0E121B'` | Module color |
| `backgroundColor` | `string` | `'#F7F8F9'` | Background color |
| `borderRadius` | `number` | `16` | Outer corner radius |
| `finderPatternRadiusFraction` | `number` | `1.2` | Finder pattern roundness |
| `dataModuleRadiusFraction` | `number` | `0.45` | Data module roundness |

## Framework examples

### React

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

### Vue

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

### Nuxt / SSR

```vue
<template>
  <div ref="qrRef" />
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';

const qrRef = ref<HTMLDivElement>();

onMounted(async () => {
  const { renderQrCode } = await import('real-qr-code');
  if (qrRef.value) {
    renderQrCode(qrRef.value, { data: 'https://example.com', size: 300 });
  }
});
</script>
```

### Vanilla JS

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

## Adding a logo

The SVG leaves a clear zone in the center (`centerSpaceSize`). Overlay your logo using CSS:

```html
<div style="position: relative; display: inline-block;">
  <div id="qr"></div>
  <img
    src="logo.png"
    style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 48px; height: 48px;"
  />
</div>
```

## Features

- **Rounded finder patterns** — three corner markers with smooth rounded rectangles
- **Blob effect** — adjacent data modules merge into organic shapes
- **Rounded alignment patterns** — small 5x5 markers styled consistently
- **Center logo space** — clear zone for logo overlay
- **Error correction H (30%)** — reliable scanning even with center obstruction
- **Zero dependencies at runtime** — only `qrcode-generator` for QR matrix
- **ESM + CJS** — works with bundlers and Node.js

## License

MIT
