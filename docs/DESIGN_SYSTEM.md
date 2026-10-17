# Design System — Runway Finance (Neo-Brutalism)

Dokumen ini adalah acuan visual. AI agent WAJIB memakai token dan komponen di sini. Dilarang menulis warna, ukuran border, atau bayangan langsung (hardcode) di widget fitur.

## 1. Karakter desain

Aplikasi ini memberi "tamparan realita" tentang uang. Neo-brutalism cocok karena jujur, tegas, dan susah diabaikan.

| Prinsip | Artinya di aplikasi |
|---|---|
| Border tebal hitam | Semua kartu, tombol, input punya garis hitam 3px |
| Bayangan keras | Bayangan offset tanpa blur (hard shadow), bukan elevation Material |
| Warna datar jenuh | Tanpa gradien, tanpa transparansi untuk warna status |
| Sudut tajam | Radius 0 sebagai default |
| Tipografi besar dan tebal | Angka runway dibuat raksasa |
| Warna = makna | Warna dipakai untuk status dan kategori, bukan hiasan |
| Gerak singkat dan tegas | Tombol "tenggelam" saat ditekan, tanpa animasi lembut berlebihan |

Nada teks: blak-blakan, santai, tidak menghakimi. Pakai "kamu".

## 2. Palet warna (mode terang, v1)

| Token | Hex | Dipakai untuk |
|---|---|---|
| `ink` | `#111111` | Teks, border, bayangan |
| `canvas` | `#F5F0E6` | Latar layar |
| `paper` | `#FFFFFF` | Latar kartu netral |
| `safe` | `#5BE584` | Health Bar aman (runway > 30), uang masuk, sukses |
| `warn` | `#FFD43B` | Health Bar waspada (15-30), peringatan, tombol utama |
| `danger` | `#FF5C5C` | Health Bar bahaya (< 15), uang keluar, tagihan mendesak |
| `needs` | `#74B9FF` | Amplop Needs |
| `wants` | `#FF9EDB` | Amplop Wants |
| `buffer` | `#B197FC` | Bantalan Bulan Depan |
| `goal` | `#FFA94D` | Target, Dana Darurat, api streak |
| `muted` | `#4A4A4A` | Teks sekunder di atas `canvas`/`paper` |
| `disabled` | `#D9D4C7` | Latar elemen nonaktif (teks `#8A8577`) |

Aturan warna:
1. Teks di atas warna jenuh **selalu `ink`**, tidak pernah putih.
2. Status tidak boleh hanya warna: selalu ada teks (AMAN / WASPADA / BAHAYA) dan ikon.
3. Satu layar maksimal 3 warna jenuh agar tidak ramai.
4. Warna status (`safe/warn/danger`) hanya untuk status. Jangan dipakai untuk dekorasi.
5. Mode gelap **tidak** masuk v1 (keputusan: ditunda). Siapkan token lewat `ThemeExtension` agar bisa ditambah nanti.

## 3. Tipografi

| Peran | Font | Catatan |
|---|---|---|
| UI dan judul | **Space Grotesk** (Bold/Medium) | Tegas dan modern |
| Angka uang dan hari | **Space Mono** (Bold) | Lebar angka konsisten, rapi untuk Rupiah |

- Font **dibundel di `assets/fonts/`**, bukan diunduh saat runtime (aplikasi harus jalan offline). Keduanya berlisensi terbuka (OFL); cek lisensi saat memasang.
- Label kecil: huruf kapital, letter-spacing +0.5.

| Gaya | Ukuran | Font |
|---|---|---|
| `hero` (angka runway) | 96 | Space Mono Bold |
| `display` (Unassigned, nominal besar) | 40 | Space Mono Bold |
| `h1` | 28 | Space Grotesk Bold |
| `h2` | 22 | Space Grotesk Bold |
| `body` | 16 | Space Grotesk Medium |
| `label` | 12 | Space Grotesk Bold, KAPITAL |
| `money` (nominal di daftar) | 18 | Space Mono Bold |

Teks harus tetap rapi sampai skala font sistem 1.3x.

## 4. Token ukuran

| Token | Nilai |
|---|---|
| Spasi | 4, 8, 12, 16, 24, 32 (grid 4) |
| Border | `thin` 2, `base` 3, `heavy` 4 (hero) |
| Bayangan keras (offset x=y, blur 0, warna `ink`) | `sm` 3, `md` 5, `lg` 8 |
| Radius | 0 (default). Pengecualian: titik/penanda bulat kecil |
| Target sentuh minimum | 48 x 48 dp |
| Padding layar | 16 horizontal |

## 5. Komponen inti (`lib/shared/widgets/brutal/`)

| Komponen | Spesifikasi |
|---|---|
| `BrutalCard` | Latar `paper` atau warna kategori, border `base`, bayangan `md`, padding 16 |
| `BrutalButton` | Varian: `primary` (warn), `safe`, `danger`, `neutral` (paper). Border `base`, bayangan `md`. **Saat ditekan:** bergeser (+offset, +offset) dan bayangan menjadi 0, haptic ringan. Tanpa ripple Material |
| `BrutalChip` | Border `thin`, teks label kapital, dipakai untuk status dan pilihan amplop. Boleh dimiringkan -2 derajat sebagai aksen (hanya untuk stempel status) |
| `BrutalTextField` | Latar `paper`, border `base`; fokus: bayangan `sm` berwarna `warn` |
| `MoneyTextField` | Input nominal besar, Space Mono, hanya angka, otomatis format ribuan |
| `Numpad` | Keypad 3x4 dengan tombol besar (0-9, 000, hapus), dipakai di input transaksi |
| `BrutalProgressBar` | Segmen persegi (misal 10 kotak) atau batang tebal berborder; isi warna kategori |
| `BrutalSegmented` | Tab jenis transaksi: blok berdempetan, yang aktif terisi `warn` |
| `BrutalBottomNav` | 3 tab, label kapital; tab aktif terisi warna + border. Ruang kosong di tengah untuk FAB |
| `BrutalFab` | Kotak 64 dp, latar `warn`, ikon plus tebal, border `heavy`, bayangan `lg` |
| `BrutalDialog` / `BrutalSheet` | Border `heavy`, bayangan `lg`, tanpa sudut membulat, tanpa blur latar (scrim `ink` 60%) |
| `HazardStripes` | Pita garis diagonal kuning-hitam (CustomPainter) untuk peringatan: tagihan H-3, backup lama |
| `Stamp` | Label status berbingkai (AMAN, WASPADA, BAHAYA, LUNAS, DIJEDA) |
| `EmptyState` | Kotak berbingkai putus-putus (dashed) + teks blak-blakan + satu tombol aksi |

## 6. Peta halaman

Navigasi: 3 tab bawah + FAB tengah (➕).

```
Onboarding ──► Shell (3 tab + FAB)
                ├─ Beranda
                ├─ Alokasi
                ├─ Target
                └─ ➕ Input Transaksi (sheet)

Dari Beranda   : Pengaturan, Backup & Pemulihan, Riwayat Transaksi, Daftar Uang di Jalan
Dari Alokasi   : Detail Amplop, Kelola Amplop, Radar Langganan (daftar + form), Alokasi (sheet)
Dari Target    : Detail Target (form), Dana Darurat
Dari Pengaturan: Backup & Pemulihan, Ekspor, Notifikasi, Aturan Runway
```

### 6.1 Daftar halaman

| # | Halaman | Versi | Isi utama |
|---|---|---|---|
| 1 | Onboarding | v1 | Pilih "Mulai baru" atau "Pulihkan". Saldo awal, amplop default, izin notifikasi, hubungkan Drive |
| 2 | **Beranda** | v1 | Health Bar, Pending Income, Puasa Jajan, banner backup, (v1.5) net worth |
| 3 | **Alokasi** | v1 | Unassigned Funds, Bantalan, amplop Needs/Wants, Radar Langganan |
| 4 | **Target** | v1 | Kartu target, Dana Darurat, placeholder Portofolio |
| 5 | Input Transaksi (sheet) | v1 | Jenis transaksi, nominal + numpad, amplop, catatan |
| 6 | Dialog Kalkulator Keringat | v1 | Peringatan hari runway yang dikorbankan |
| 7 | Dialog Saran Bantalan | v1 | Tawaran amankan sebagian uang project besar |
| 8 | Sheet Alokasi | v1 | Bagi Unassigned ke amplop |
| 9 | Detail Amplop | v1 (usulan) | Saldo, riwayat transaksi amplop, edit/arsip |
| 10 | Riwayat Transaksi | v1 (usulan) | Semua transaksi, filter, **edit/hapus** (soft delete) |
| 11 | Daftar Uang di Jalan | v1 (usulan) | Pending income, tandai "sudah cair" |
| 12 | Langganan (daftar + form) | v1 | Tagihan berulang, jatuh tempo, amplop sumber |
| 13 | Detail Target (form) | v1 | Nama, nominal, tenggat, pacing, setor |
| 14 | Pengaturan | v1 | Aturan runway, notifikasi, backup, ekspor |
| 15 | Backup & Pemulihan | v1 | Status, backup sekarang, daftar backup, pulihkan |
| 16 | Portofolio, Detail Aset, Net Worth | v1.5 | Aset input manual, tren, porsi |
| 17 | Galeri Desain (debug) | v1 | Hanya mode debug, untuk melihat semua komponen |

Halaman bertanda **(usulan)** belum ada di spec JSON. Tanpanya pengguna tidak bisa mengedit atau menghapus transaksi (BR-10). Lihat bagian 9.

## 7. Tata letak per halaman utama

### Beranda
1. **Bar atas:** nama aplikasi (blok `ink`, teks `paper`) dan tombol pengaturan persegi.
2. **Health Bar (hero):** blok penuh selebar layar, warna sesuai status, border `heavy`, bayangan `lg`.
   - Stempel status (AMAN/WASPADA/BAHAYA) di pojok.
   - Angka hari raksasa (`hero`) dan kata `HARI`.
   - Kalimat: "Aman untuk 47 hari ke depan".
   - Batang segmen 10 kotak: terisi sesuai runway terhadap target 30 hari.
3. **Uang di jalan:** strip `paper` berbingkai. "Ada Rp 1.500.000 menunggu cair." Disembunyikan jika kosong.
4. **Puasa Jajan:** kartu `goal` berisi 7 kotak hari (terisi + ikon api jika sukses), angka streak dan rekor. Rekor baru memicu perayaan.
5. **Banner backup:** pita `HazardStripes` kuning-hitam, hanya jika belum/lama tidak backup.
6. (v1.5) Baris net worth kecil.

### Alokasi
1. **Unassigned Funds:** blok besar. Rp 0 = `safe` dengan stempel "SEMUA UANG PUNYA TUGAS". > 0 = `warn`. < 0 = `danger`.
2. **Bantalan Bulan Depan** (hanya jika ada): kartu `buffer`, ikon gembok, "CAIR 1 NOV".
3. **Needs:** daftar tile berlatar `needs` (nama, saldo `money`, batang sisa).
4. **Wants:** sama, berlatar `wants`.
5. **Radar Langganan:** tile `paper`; jatuh tempo <= 3 hari memakai `HazardStripes` + latar `danger`: "VPS HOSTINGER, 3 HARI LAGI, Rp 150.000".

### Target
1. Kartu target (`goal`): nama, batang progres, "Sisihkan Rp 12.000 per hari" (Savings Pacing).
2. Kartu Dana Darurat: batang tebal, "2,1 dari 6 bulan".
3. Placeholder Portofolio: `EmptyState` putus-putus berlabel "SEGERA (v1.5)".

### Input Transaksi (sheet penuh)
1. Tab `BrutalSegmented`: MASUK | KELUAR | DI JALAN | PINDAH | TARGET.
2. Nominal raksasa (`display`), warna teks `ink` di atas latar sesuai jenis (masuk `safe`, keluar `danger`).
3. Pilihan amplop sebagai deretan `BrutalChip` berwarna kategori.
4. Catatan + tanggal (default hari ini).
5. `Numpad` besar di bawah, tombol SIMPAN lebar penuh.

### Dialog Kalkulator Keringat
Latar `warn` atau `danger` (jika > 3 hari), ikon peringatan, teks raksasa "1 HARI". Kalimat: "Beli ini bakal makan 1 hari daya tahan hidupmu. Yakin?"
Dua tombol: **GAK JADI** (`safe`, di atas) dan **TETAP BELI** (`neutral`, lebih kecil).

## 8. Teks antarmuka (contoh nada)

| Situasi | Teks |
|---|---|
| Runway aman | "Aman untuk 47 hari ke depan." |
| Runway kuning | "Hati-hati. Tinggal 22 hari." |
| Runway merah | "Bahaya. 9 hari lagi dompetmu kosong." |
| Belum ada data | "Catat dulu pengeluaranmu. Belum ada yang bisa dihitung." |
| Unassigned > 0 | "Masih ada Rp 400.000 nganggur. Kasih tugas." |
| Streak | "5 hari tanpa jajan. Lanjut." |
| Rekor baru | "REKOR BARU. 12 hari." |
| Backup lama | "Data belum di-backup 9 hari. HP hilang = data hilang." |
| Konfirmasi restore | "Data di HP ini bakal diganti. Lanjut?" |

## 9. Perubahan yang diusulkan ke spec (menunggu persetujuan)

1. Tambah halaman **Riwayat Transaksi**, **Detail Amplop**, dan **Daftar Uang di Jalan** sebagai v1 (diperlukan untuk edit/hapus transaksi dan menandai uang cair).
2. Tambah **Galeri Desain** (hanya debug) untuk memeriksa komponen tanpa membuka seluruh aplikasi.
3. Keputusan: mode gelap ditunda; font dibundel; radius 0.

## 10. Gerak dan interaksi

- Tekan tombol: bergeser sebesar offset bayangan, bayangan hilang, durasi 80-100 ms, haptic ringan. Lepas: kembali.
- Transisi halaman: geser horizontal 150 ms linear, atau potong langsung. Tanpa efek memantul.
- Angka Health Bar: hitung naik (count-up) 400 ms saat layar dibuka.
- Perayaan rekor streak: kotak-kotak konfeti bersudut tajam jatuh singkat (maks 1,5 detik). Hormati pengaturan "kurangi animasi" sistem.
- Ripple Material dimatikan (`NoSplash`); umpan balik sentuh hanya dari efek tekan.

## 11. Aksesibilitas

- Kontras: teks `ink` di atas semua warna jenuh memenuhi kontras tinggi.
- Target sentuh minimal 48 dp. Jarak antar tombol minimal 8 dp.
- Status selalu punya teks dan ikon, tidak hanya warna.
- Beri `Semantics` pada Health Bar: "Runway 47 hari, status aman".
- Dukung skala font sistem sampai 1.3x tanpa teks terpotong.

## 12. Implementasi di Flutter

```
lib/core/theme/
  brutal_tokens.dart        # warna, spasi, border, bayangan, radius (const)
  brutal_theme.dart         # ThemeData + ThemeExtension<BrutalTheme>
  app_theme.dart            # merakit tema
lib/shared/widgets/brutal/
  brutal_card.dart  brutal_button.dart  brutal_chip.dart  brutal_text_field.dart
  money_text_field.dart  numpad.dart  brutal_progress_bar.dart  brutal_segmented.dart
  brutal_bottom_nav.dart  brutal_fab.dart  brutal_dialog.dart  brutal_sheet.dart
  hazard_stripes.dart  stamp.dart  empty_state.dart
lib/features/dev/design_gallery_screen.dart   # hanya kDebugMode
assets/fonts/                                   # SpaceGrotesk-*.ttf, SpaceMono-*.ttf
```

Aturan teknis:
1. Bayangan dibuat dengan `BoxDecoration(border: ..., boxShadow: [BoxShadow(offset: Offset(d, d), blurRadius: 0, color: ink)])`. Jangan pakai `elevation`/`Material` shadow.
2. Matikan ripple: `splashFactory: NoSplash.splashFactory`. Efek tekan dibuat sendiri di `BrutalButton`.
3. Warna dan ukuran hanya dari `brutal_tokens.dart`. Hardcode warna di fitur = ditolak saat review.
4. Daftarkan font di `pubspec.yaml` (bagian `fonts`), jangan memakai pengunduhan saat runtime.
5. Widget fitur memakai komponen `Brutal*`, tidak memakai `ElevatedButton`/`Card` bawaan langsung.
6. Warna Health Bar dipilih dari fungsi domain (status), widget hanya memetakan status ke token warna.
7. Tambahkan golden test untuk komponen inti (opsional) agar tampilan tidak berubah tanpa disengaja.

## 13. Token mode gelap (cadangan, belum dipakai)

| Token | Hex |
|---|---|
| `canvas` | `#151515` |
| `paper` | `#222222` |
| `ink` (border/teks) | `#F5F0E6` |
| Warna status dan kategori | tetap sama; teks di atasnya tetap `#111111` |
| Bayangan | warna `#F5F0E6`, atau warna kategori |
