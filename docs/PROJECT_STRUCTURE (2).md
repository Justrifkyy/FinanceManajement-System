# Struktur Proyek — Runway Finance (Flutter + Drift, Android)

Pola: **feature-first** dengan lapisan **domain murni** terpisah dari UI dan data.
Folder bertanda `(sudah ada)` dibuat otomatis oleh `flutter create`. Sisanya dibuat manual.

## Pohon direktori

```
runway_finance/
├── AGENTS.md                         # Panduan AI agent (dibaca otomatis Antigravity)
├── GEMINI.md                         # Pointer ke AGENTS.md (opsional)
├── pubspec.yaml                      # (sudah ada) dependensi
├── analysis_options.yaml             # (sudah ada) aturan lint
├── .gitignore                        # pastikan memuat: key.properties, *.jks, *.keystore
│
├── docs/
│   ├── runway-finance-spec.json      # Spesifikasi produk (sumber kebenaran)
│   ├── PROJECT_STRUCTURE.md          # File ini
│   ├── DESIGN_SYSTEM.md              # Gaya visual neo-brutalism
│   └── BACKUP_SETUP.md               # Setup Google Cloud untuk backup (langkah manual)
│
├── assets/
│   └── fonts/                        # SpaceGrotesk-*.ttf, SpaceMono-*.ttf (dibundel, offline)
│
├── android/                          # (sudah ada) proyek native Android
│   └── app/build.gradle              # minSdk, desugaring, signing release
│
├── lib/
│   ├── main.dart                     # Init: timezone, database, notifikasi, ProviderScope
│   ├── app.dart                      # MaterialApp.router + tema
│   │
│   ├── core/                         # Hal umum, tanpa logika bisnis
│   │   ├── constants/
│   │   │   ├── strings.dart          # Semua teks UI (Bahasa Indonesia)
│   │   │   └── app_constants.dart    # APP_NAME, default setting, angka magic
│   │   ├── theme/
│   │   │   ├── brutal_tokens.dart    # warna, spasi, border, bayangan (const)
│   │   │   ├── brutal_theme.dart     # ThemeExtension<BrutalTheme>
│   │   │   └── app_theme.dart
│   │   ├── router/
│   │   │   └── app_router.dart       # go_router + ShellRoute (3 tab + FAB)
│   │   └── utils/
│   │       ├── money_formatter.dart  # int Rupiah -> "Rp 1.500.000"
│   │       ├── date_helper.dart      # local_date & batas hari/bulan Asia/Makassar
│   │       └── id_generator.dart     # uuid v4
│   │
│   ├── domain/                       # DART MURNI. Dilarang import flutter/drift/google_sign_in/riverpod
│   │   ├── entities/                 # Objek bisnis sederhana
│   │   │   ├── transaction_entity.dart
│   │   │   ├── envelope_entity.dart
│   │   │   ├── goal_entity.dart
│   │   │   └── buffer_entry_entity.dart
│   │   ├── runway.dart               # avg_daily_spend, runway_days, status Health Bar
│   │   ├── sweat_calculator.dart     # nominal -> hari runway yang dikorbankan
│   │   ├── streak.dart               # Puasa Jajan: streak & rekor
│   │   ├── buffer.dart               # saran Bantalan + aturan pencairan
│   │   ├── pacing.dart               # Savings Pacing harian/bulanan
│   │   ├── priority_ladder.dart      # tangga prioritas (v1.5 dipakai penuh)
│   │   └── net_worth.dart            # v1.5
│   │
│   ├── data/                         # Penyimpanan. Tidak berisi rumus bisnis
│   │   ├── database/
│   │   │   ├── app_database.dart     # @DriftDatabase, schemaVersion, MigrationStrategy, seed
│   │   │   ├── app_database.g.dart   # (generated oleh build_runner)
│   │   │   ├── tables/
│   │   │   │   ├── envelopes_table.dart
│   │   │   │   ├── transactions_table.dart
│   │   │   │   ├── pending_incomes_table.dart
│   │   │   │   ├── buffer_entries_table.dart
│   │   │   │   ├── subscriptions_table.dart
│   │   │   │   ├── goals_table.dart
│   │   │   │   ├── resisted_events_table.dart
│   │   │   │   └── app_settings_table.dart
│   │   │   └── daos/                 # query SQL/Drift per area
│   │   │       ├── transaction_dao.dart
│   │   │       ├── envelope_dao.dart
│   │   │       ├── buffer_dao.dart
│   │   │       ├── subscription_dao.dart
│   │   │       ├── goal_dao.dart
│   │   │       └── settings_dao.dart
│   │   └── repositories/             # pembungkus DAO -> entity domain
│   │       ├── transaction_repository.dart
│   │       ├── envelope_repository.dart
│   │       ├── pending_income_repository.dart
│   │       ├── buffer_repository.dart
│   │       ├── subscription_repository.dart
│   │       ├── goal_repository.dart
│   │       └── settings_repository.dart
│   │
│   ├── services/                     # Layanan lintas fitur
│   │   ├── notification_service.dart       # jadwal notifikasi lokal + izin
│   │   ├── buffer_release_service.dart     # cairkan Bantalan saat app dibuka (idempoten)
│   │   └── backup/
│   │       ├── backup_service.dart         # snapshot (VACUUM INTO) + gzip + jadwal/debounce
│   │       ├── drive_client.dart           # login Google + upload/list/download/delete appDataFolder
│   │       ├── restore_service.dart        # validasi, salinan pengaman, ganti DB
│   │       └── export_service.dart         # ekspor manual via share sheet
│   │
│   ├── providers/                    # Riverpod: data -> domain -> UI
│   │   ├── database_provider.dart
│   │   ├── repository_providers.dart
│   │   ├── runway_provider.dart
│   │   ├── budget_provider.dart
│   │   ├── streak_provider.dart
│   │   ├── backup_provider.dart
│   │   └── settings_provider.dart
│   │
│   ├── features/                     # UI per layar/fitur
│   │   ├── shell/
│   │   │   └── main_shell.dart       # bottom tabs + tombol ➕ tengah
│   │   ├── home/                     # Tab 1: Survival Dashboard
│   │   │   ├── home_screen.dart
│   │   │   └── widgets/
│   │   │       ├── health_bar.dart
│   │   │       ├── pending_income_note.dart
│   │   │       ├── puasa_jajan_streak.dart
│   │   │       ├── backup_status_banner.dart
│   │   │       └── net_worth_line.dart        # v1.5
│   │   ├── budget/                   # Tab 2: Kolam Alokasi
│   │   │   ├── budget_screen.dart
│   │   │   └── widgets/
│   │   │       ├── unassigned_header.dart
│   │   │       ├── envelope_tile.dart
│   │   │       ├── income_buffer_card.dart
│   │   │       ├── subscription_radar.dart
│   │   │       └── allocate_sheet.dart
│   │   ├── future/                   # Tab 3: Target & Impian
│   │   │   ├── future_screen.dart
│   │   │   └── widgets/
│   │   │       ├── goal_card.dart
│   │   │       ├── emergency_fund_card.dart
│   │   │       └── portfolio_placeholder.dart  # placeholder, diisi di v1.5
│   │   ├── transaction/              # Tombol ➕
│   │   │   ├── transaction_entry_sheet.dart
│   │   │   └── widgets/
│   │   │       ├── sweat_calculator_dialog.dart
│   │   │       └── buffer_suggestion_dialog.dart
│   │   ├── backup/
│   │   │   └── backup_restore_screen.dart
│   │   ├── dev/
│   │   │   └── design_gallery_screen.dart   # hanya kDebugMode
│   │   ├── settings/
│   │   │   └── settings_screen.dart
│   │   └── onboarding/
│   │       └── onboarding_screen.dart      # termasuk opsi "Pulihkan dari backup"
│   │
│   └── shared/
│       └── widgets/
│           └── brutal/               # Komponen neo-brutalism (lihat DESIGN_SYSTEM.md)
│               ├── brutal_card.dart  brutal_button.dart  brutal_chip.dart
│               ├── brutal_text_field.dart  money_text_field.dart  numpad.dart
│               ├── brutal_progress_bar.dart  brutal_segmented.dart
│               ├── brutal_bottom_nav.dart  brutal_fab.dart
│               ├── brutal_dialog.dart  brutal_sheet.dart
│               └── hazard_stripes.dart  stamp.dart  empty_state.dart
│
└── test/
    ├── domain/                       # PRIORITAS TERTINGGI: unit test semua rumus
    │   ├── runway_test.dart
    │   ├── sweat_calculator_test.dart
    │   ├── streak_test.dart
    │   ├── buffer_test.dart
    │   └── pacing_test.dart
    ├── data/                         # database in-memory (NativeDatabase.memory())
    │   ├── transaction_dao_test.dart     # saldo diturunkan dari ledger
    │   ├── buffer_release_test.dart      # idempoten: dipanggil 2x tidak cair 2x
    │   └── migration_test.dart
    ├── services/
    │   └── backup_service_test.dart      # snapshot, kompres, validasi versi skema
    └── core/
        ├── money_formatter_test.dart
        └── date_helper_test.dart
```

## Aturan arah ketergantungan

```
features (UI) -> providers -> repositories -> daos -> Drift/SQLite
                     |
                     v
                  domain  (fungsi murni; tidak bergantung pada siapa pun)

services/backup -> (salinan file database) -> Google Drive appDataFolder
```

- `domain/` tidak boleh mengimpor `data/`, `features/`, `providers/`, atau paket flutter/drift/google.
- `features/` tidak boleh mengimpor `data/` langsung; lewat `providers/`.
- `data/` tidak berisi rumus bisnis. DAO hanya query.
- `services/backup/` bekerja pada file database; tidak boleh menyentuh logika bisnis.

## Pemetaan fitur ke file

| Fitur (spec) | Domain | Data | UI / Service |
|---|---|---|---|
| F-01 Health Bar / Runway | `runway.dart` | `transaction_dao`, `envelope_dao` | `home/widgets/health_bar.dart` |
| F-02 Pending Income | n/a | `pending_income_repository` | `home/widgets/pending_income_note.dart` |
| F-03 Puasa Jajan | `streak.dart` | `transaction_dao` | `home/widgets/puasa_jajan_streak.dart` |
| F-04 Unassigned Funds | n/a | `envelope_dao`, `transaction_dao` | `budget/widgets/unassigned_header.dart` |
| F-05 Bantalan Bulan Depan | `buffer.dart` | `buffer_dao` | `budget/widgets/income_buffer_card.dart`, `services/buffer_release_service.dart` |
| F-06 Amplop Needs/Wants | n/a | `envelope_dao` | `budget/widgets/envelope_tile.dart` |
| F-07 Radar Langganan | n/a | `subscription_dao` | `budget/widgets/subscription_radar.dart`, `services/notification_service.dart` |
| F-08 Kalkulator Keringat | `sweat_calculator.dart` | `resisted_events` | `transaction/widgets/sweat_calculator_dialog.dart` |
| F-09 Target & Pacing | `pacing.dart` | `goal_dao` | `future/widgets/goal_card.dart` |
| F-10 Dana Darurat | `pacing.dart` | `goal_dao` | `future/widgets/emergency_fund_card.dart` |
| F-11 Notifikasi Lokal | n/a | n/a | `services/notification_service.dart` |
| F-19 Backup & Restore | n/a | file DB | `services/backup/*`, `features/backup/`, `home/widgets/backup_status_banner.dart` |
| F-20 Ekspor manual | n/a | file DB | `services/backup/export_service.dart` |
| F-13..F-18 (v1.5) | `net_worth.dart`, `priority_ladder.dart` | tabel aset (baru) | `future/` bagian Portofolio |

## Langkah setup awal

```bash
# 1. Buat proyek Flutter (hanya Android dulu)
flutter create --platforms=android --org com.namamu runway_finance
cd runway_finance

# 2. Salin AGENTS.md, GEMINI.md, dan folder docs/ ke root proyek

# 3. Dependensi inti
flutter pub add flutter_riverpod go_router intl uuid
flutter pub add drift drift_flutter
flutter pub add dev:drift_dev dev:build_runner
flutter pub add flutter_local_notifications timezone flutter_timezone

# 4. Dependensi backup (ikuti README versi terpasang, terutama google_sign_in)
flutter pub add google_sign_in googleapis http path_provider share_plus

# 5. Kerangka folder (bisa diminta ke Antigravity)
mkdir -p lib/{core/{constants,theme,router,utils},domain/entities,data/{database/{tables,daos},repositories},services/backup,providers,features/{shell,home/widgets,budget/widgets,future/widgets,transaction/widgets,backup,settings,onboarding},shared/widgets}
mkdir -p test/{domain,data,services,core}

# 6. Setelah membuat tabel Drift
dart run build_runner build --delete-conflicting-outputs

# 7. Cek kesehatan
flutter analyze
flutter test
```

Ganti `com.namamu` dengan identitasmu. Package name Android ini juga dipakai di OAuth client Google (lihat `docs/BACKUP_SETUP.md`), jadi **tentukan sekali dan jangan diubah**.
