# Changelog

## 0.0.1 — 2026-03-24

- QR kod generatsiya qiluvchi Flutter kutubxona yaratildi
- Rounded finder patterns (uchta burchakdagi katta kvadratlar yumuqlashtirilgan)
- Blob effekt — yonma-yon turgan data modullar bir-biriga qo'shilib, organik ko'rinish beradi
- Markazda 80dp bo'sh joy — logo qo'yish uchun
- Logo overlay — ixtiyoriy Widget sifatida markaz ustiga qo'yiladi
- borderRadius orqali QR kodning tashqi burchaklari yumuqlashtiriladi
- Error correction H (30%) — markaziy bo'shliq tufayli ishonchli skanerlanish
- Example app yaratildi (flutter_dash icon bilan)

## 2026-03-24 — Web versiya + yaxshilashlar

- NPM paket yaratildi (packages/web) — SVG asosida, har qanday web framework bilan ishlaydi
- Nuxt, React, Vue, vanilla JS da ishlatish mumkin
- Alignment pattern stilizatsiyasi qo'shildi (pastki-o'ng burchakdagi kichik kvadrat)
- Radiuslar proporsional bo'ldi — turli QR versiyalarida to'g'ri ko'rinadi
- O'lcham moslashuchan — size bermasa parent o'lchamiga moslashadi
- Logo rangi avtomatik QR rangiga mos keladi (IconTheme orqali)
- Figma dizayniga moslashtirildi (ranglar: #0E121B, #F7F8F9)
