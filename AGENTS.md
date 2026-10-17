# Panduan AI Agent — Runway Finance

Dokumen ini adalah aturan kerja untuk AI agent yang berkontribusi pada repositori **Runway Finance**.

## 1. Sumber Kebenaran (Source of Truth)
- Spesifikasi produk & teknis: `docs/runway-finance-spec (1).json`
- Panduan struktur proyek: `docs/PROJECT_STRUCTURE (2).md`
- Acuan visual & komponen UI: `docs/DESIGN_SYSTEM.md`

## 2. Aturan Arsitektur & Lapisan
- **features (UI) -> providers -> repositories -> DAOs -> Drift (SQLite)**
- Lapisan `domain/` **HARUS DART MURNI**:
  - Dilarang mengimpor Flutter, Drift, Riverpod, Google Sign-In, dll.
  - Berisi rumus bisnis: `runway.dart`, `sweat_calculator.dart`, `streak.dart`, `buffer.dart`, `pacing.dart`, `net_worth.dart`.
- Saldo **TIDAK** disimpan dalam kolom. Saldo selalu diturunkan dari histori buku besar (`transactions`).
- Semua operasi tulis yang melibatkan lebih dari satu entitas wajib dibungkus dalam `db.transaction()`.
- Pencairan Bantalan Bulan Depan (`buffer_release_service`) **wajib idempoten** (dipanggil berulang kali tidak mencairkan uang ganda).

## 3. Konvensi Data
- **Uang**: Simpan sebagai `int` Rupiah penuh (tanpa desimal/float). Contoh: Rp 1.500.000 disimpan sebagai `1500000`.
- **Tanggal & Waktu**:
  - Simpan sebagai `DateTime` UTC di Drift.
  - Sertakan `local_date` (TEXT 'YYYY-MM-DD' zona Asia/Makassar UTC+8) untuk transaksi dan agregasi harian.
- **Identitas**: Primary key semua tabel menggunakan `uuid v4` (TEXT).

## 4. Desain & UI (Neo-Brutalism)
- Gunakan token dari `core/theme/brutal_tokens.dart` dan komponen dari `shared/widgets/brutal/`.
- Jangan hardcode warna, border, atau bayangan di layar fitur.
- Karakter: border tebal hitam (`ink` #111111), bayangan keras tanpa blur, radius 0, warna datar jenuh.
- Bahasa UI: Bahasa Indonesia, santai, lugas, jujur ("kamu").

## 5. Kualitas & Validasi
- Selalu uji dengan `flutter analyze` dan `flutter test` sebelum menyelesaikan tugas.
- Tulis unit test untuk setiap rumus domain di `test/domain/`.
