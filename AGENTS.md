# real-qr-code Agent Qoidalari

- Menga doim o'zbek tilida javob ber.
- Kodda kommentariya yozma.
- Bu loyiha Flutter package va `packages/web` ichidagi npm package'dan iborat; ikkala surface API parity saqlansin.
- Public API'da breaking change taxmin bilan kiritilmasin; Flutter va Web option nomlari imkon qadar bir xil semantikada qolsin.
- O'zgargan kod uchun minimal gate: Flutter tomonda `dart analyze` yoki `flutter analyze`, web tomonda `npm --prefix packages/web run build`.

## Tezkor runtime verification

- Flutter widget xulqi o'zgarsa `example/` app orqali real rendering verification qilinsin.
- Web package o'zgarsa `packages/web/example/index.html` yoki mos minimal harness bilan render tekshirilsin; kerak bo'lsa `Playwright` ishlatilsin.
- Takrorlanuvchi cross-surface smoke kerak bo'lsa `Maestro MCP` web va mobile uchun ishlatilishi mumkin, lekin default birinchi tanlov emas.
- Screenshot final evidence uchun olinsin; render natijasi, API output va build log asosiy signal bo'lsin.
