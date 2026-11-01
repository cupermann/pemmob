# Pemetaan Stitch → Flutter

Sumber: `stitch_fixora_mobile_ui_design (1).zip` (9 folder screen, masing-masing `code.html` dan `screen.png` + `DESIGN.md`).

| Folder Stitch | Kelas Flutter |
|---|---|
| 01_welcome_masuk | `WelcomePage` |
| 01a_login_mahasiswa | `LoginPage` |
| 01b_lupa_password | `ForgotPasswordPage` |
| 02_daftar_akun_mahasiswa | `RegisterPage` |
| 03_beranda_dashboard | `StudentHomePage` |
| 04_buat_laporan_kerusakan | `CreateReportPage` |
| 05_riwayat_laporan_saya | `HistoryPage` |
| 06_detail_laporan_kerusakan | `ReportDetailPage` |
| 07_profil_mahasiswa | `StudentProfilePage` |

Tambahan kebutuhan alur: `ReportSuccessPage` untuk konfirmasi pengiriman laporan, `StudentShell` untuk mengelola tab, `FixoraStore` untuk data simulasi lokal, `FxBottomNav` dan komponen UI reusable.

Komponen dibuat ulang sebagai widget Material/Flutter. Tidak menggunakan WebView maupun screenshot layar penuh. Foto dokumentasi dan kerusakan dipotong dari aset screenshot pengguna di ZIP agar visual tetap dekat dengan referensi.

Keterbatasan: layer desain HTML Stitch menggunakan external images dan ikon web yang tidak otomatis tersedia di Android. Beberapa ikon dan ilustrasi diterjemahkan menjadi padanan Flutter sehingga visual mendekati — bukan pixel-perfect — desain referensi. Tidak ada backend di ZIP; seluruh API asli harus dihubungkan terpisah.
