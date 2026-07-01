# AGENTS.md

## Project Context

Ini adalah project Flutter lama yang sudah berjalan dan memiliki konfigurasi versi yang sensitif.

Jangan mengubah arsitektur utama, versi SDK, dependency, konfigurasi Android, konfigurasi iOS, atau sistem build tanpa alasan kuat dan tanpa persetujuan.

Sebelum mengedit file:

1. baca struktur project,
2. periksa `pubspec.yaml`,
3. periksa pola kode yang sudah digunakan,
4. identifikasi arsitektur dan state management existing,
5. ikuti gaya coding existing,
6. jelaskan rencana perubahan,
7. ubah file seminimal mungkin.

Utamakan kompatibilitas dengan kondisi project saat ini, bukan penggunaan versi atau pola terbaru.

## Important Rules

* Jangan mengubah arsitektur utama tanpa diminta.
* Jangan mengganti state management existing.
* Jangan mengganti navigation atau routing system existing.
* Jangan mengubah struktur folder utama tanpa persetujuan.
* Jangan mengubah pola model, repository, service, controller, provider, bloc, atau view model yang sudah digunakan.
* Jangan melakukan refactor besar untuk task kecil.
* Jangan mengubah file yang tidak berkaitan dengan request.
* Jangan menghapus file tanpa konfirmasi.
* Jangan menjalankan command destructive.
* Jangan menjalankan command Git yang dapat menghilangkan perubahan lokal.
* Jangan mengubah `.env`, credential, API key, signing key, atau secret.
* Jangan menampilkan isi `.env` atau file credential.
* Jangan mengubah database schema, local storage schema, migration, atau struktur data tanpa konfirmasi.
* Jangan menambahkan dependency baru tanpa izin.
* Jangan menghapus atau mengganti dependency tanpa izin.
* Jangan mengganti package dengan package alternatif hanya karena package lain lebih baru.
* Jangan mengubah format seluruh project jika hanya mengedit beberapa file.

## Strict Version Rules

Project ini sensitif terhadap perubahan versi.

Jangan melakukan tindakan berikut tanpa persetujuan:

* menjalankan `flutter upgrade`,
* menjalankan `flutter downgrade`,
* menjalankan `flutter pub upgrade`,
* menjalankan `flutter pub upgrade --major-versions`,
* mengubah versi Flutter SDK,
* mengubah versi Dart SDK,
* mengubah constraint `environment` pada `pubspec.yaml`,
* mengubah versi dependency pada `pubspec.yaml`,
* mengubah isi `pubspec.lock` secara sengaja,
* menghapus `pubspec.lock`,
* menjalankan `dart fix --apply` untuk seluruh project,
* menjalankan `flutter create .`,
* meregenerasi folder `android/`, `ios/`, `web/`, `windows/`, `linux/`, atau `macos/`,
* mengganti Flutter channel,
* mengubah konfigurasi FVM apabila project menggunakan FVM.

Sebelum menyarankan perubahan versi:

1. identifikasi versi yang digunakan project,
2. periksa constraint pada `pubspec.yaml`,
3. periksa `pubspec.lock`,
4. periksa versi Flutter dan Dart yang aktif,
5. jelaskan alasan perubahan,
6. jelaskan risiko kompatibilitas,
7. minta persetujuan sebelum melakukan perubahan.

Gunakan versi existing sebagai sumber utama.

Jangan menganggap versi terbaru selalu lebih baik untuk project ini.

## Dependency Rules

* Gunakan dependency yang sudah tersedia di project.
* Jangan install package baru tanpa izin.
* Jangan mengganti package lama hanya karena deprecated tanpa analisis dampak.
* Jangan memperbarui banyak dependency sekaligus.
* Jangan mengubah dependency transitive secara manual.
* Jangan menghapus dependency yang terlihat tidak digunakan sebelum memeriksa seluruh project.
* Jangan mengubah `dependency_overrides` tanpa persetujuan.
* Jangan mengubah package lokal, Git dependency, atau path dependency tanpa persetujuan.

Jika dependency baru benar-benar diperlukan:

1. jelaskan kebutuhan dependency,
2. jelaskan mengapa solusi existing tidak mencukupi,
3. sebutkan dependency yang akan ditambahkan,
4. sebutkan versi yang kompatibel dengan project,
5. jelaskan dampaknya,
6. tunggu persetujuan sebelum mengubah `pubspec.yaml`.

## Android Version and Build Rules

Jangan mengubah konfigurasi Android tanpa persetujuan, termasuk:

* `compileSdk`,
* `targetSdk`,
* `minSdk`,
* Android Gradle Plugin,
* versi Gradle Wrapper,
* versi Kotlin,
* versi Java atau JVM,
* `namespace`,
* `applicationId`,
* `buildTypes`,
* signing configuration,
* ProGuard atau R8 rules,
* Android Manifest,
* permission,
* product flavor,
* Firebase configuration,
* `google-services.json`.

Jangan mengedit file berikut tanpa alasan yang berhubungan langsung dengan task:

* `android/build.gradle`,
* `android/settings.gradle`,
* `android/gradle.properties`,
* `android/gradle/wrapper/gradle-wrapper.properties`,
* `android/app/build.gradle`,
* `android/app/src/main/AndroidManifest.xml`.

Jika terjadi error Gradle atau Android build:

1. baca error lengkap,
2. identifikasi akar masalah,
3. periksa kompatibilitas versi existing,
4. jangan langsung menaikkan versi Gradle, Kotlin, AGP, atau SDK,
5. prioritaskan solusi dengan perubahan paling kecil,
6. minta persetujuan jika perubahan versi diperlukan.

## iOS Version and Build Rules

Jangan mengubah konfigurasi iOS tanpa persetujuan, termasuk:

* iOS deployment target,
* versi CocoaPods,
* `Podfile`,
* `Podfile.lock`,
* Xcode build settings,
* signing configuration,
* bundle identifier,
* entitlements,
* permission pada `Info.plist`,
* Firebase configuration,
* `GoogleService-Info.plist`.

Jangan menjalankan `pod update` tanpa persetujuan.

Jika diperlukan instalasi pod, prioritaskan:

```bash
pod install
```

bukan:

```bash
pod update
```

## Flutter Coding Rules

* Gunakan null safety sesuai kondisi project.
* Jangan memigrasikan project ke null safety jika project belum menggunakannya, kecuali diminta.
* Ikuti pola widget existing.
* Gunakan `StatelessWidget` atau `StatefulWidget` sesuai pola existing.
* Jangan mengubah widget menjadi pola state management lain tanpa alasan.
* Jangan menambahkan `const` secara massal jika dapat menimbulkan perubahan besar.
* Jangan mengganti seluruh widget hanya untuk memperbaiki bagian kecil.
* Hindari duplikasi kode, tetapi jangan melakukan abstraksi berlebihan.
* Letakkan reusable logic mengikuti struktur existing.
* Gunakan komponen, theme, helper, service, dan utility yang sudah tersedia.
* Jangan membuat folder baru jika folder existing masih sesuai.
* Jangan mengubah nama class, method, route, key JSON, atau parameter API tanpa memeriksa seluruh penggunaannya.
* Pertahankan backward compatibility selama memungkinkan.

## State Management Rules

Sebelum mengubah state:

1. identifikasi state management yang digunakan,
2. cari implementasi serupa dalam project,
3. ikuti pola existing,
4. jangan mencampurkan state management baru,
5. jangan memindahkan logic ke pola lain tanpa diminta.

Contoh state management yang mungkin digunakan:

* `setState`,
* Provider,
* Riverpod,
* BLoC atau Cubit,
* GetX,
* MobX,
* Redux,
* ChangeNotifier,
* ValueNotifier.

Gunakan yang sudah dipakai project.

## Navigation Rules

* Ikuti navigation system existing.
* Jangan mengganti Navigator dengan router package lain.
* Jangan mengubah route name tanpa memeriksa seluruh referensinya.
* Jangan mengganti named routes dengan declarative routing atau sebaliknya tanpa diminta.
* Jangan menambahkan package routing baru tanpa izin.
* Periksa mekanisme pengiriman argument sebelum mengubah route.

## API and Data Rules

* Ikuti pola API service existing.
* Jangan mengganti HTTP client existing.
* Jangan mengubah base URL tanpa persetujuan.
* Jangan mengubah request body, response model, header, token handling, atau endpoint tanpa memeriksa dampaknya.
* Jangan menampilkan token atau credential pada log.
* Jangan mengubah JSON key tanpa memastikan format API.
* Pertahankan kompatibilitas model data existing.
* Jangan mengubah error handling secara global untuk task lokal.
* Jangan menonaktifkan SSL verification atau security validation.

## UI and Styling Rules

* Ikuti design system existing.
* Jangan mengganti theme utama tanpa diminta.
* Jangan mengganti styling system existing.
* Jangan mengubah font, warna global, spacing global, atau asset tanpa persetujuan.
* Gunakan widget dan komponen reusable yang sudah ada.
* Jangan menambahkan UI framework baru.
* Jangan melakukan redesign halaman jika request hanya meminta perbaikan fungsi.
* Pertahankan responsive behavior existing.
* Periksa kemungkinan overflow pada ukuran layar berbeda.

## Assets Rules

* Jangan menghapus atau mengganti asset tanpa konfirmasi.
* Jangan mengubah nama atau lokasi asset tanpa memeriksa seluruh referensi.
* Jika menambahkan asset, periksa konfigurasi pada `pubspec.yaml`.
* Hindari perubahan pada seluruh bagian assets apabila hanya satu asset yang diperlukan.

## Generated Files

Jangan mengedit file generated secara manual kecuali memang diwajibkan oleh pola project.

Contoh file generated:

* `*.g.dart`,
* `*.freezed.dart`,
* `*.gr.dart`,
* file hasil `build_runner`,
* file localization generated,
* registrant plugin generated.

Jika perubahan memerlukan code generation:

1. periksa tool yang digunakan project,
2. gunakan versi tool existing,
3. jelaskan command yang akan dijalankan,
4. jangan memperbarui generator tanpa izin,
5. jangan menjalankan `build_runner` dengan opsi penghapusan konflik tanpa menjelaskan risikonya.

## Command Rules

Command yang relatif aman:

```bash
flutter pub get
flutter analyze
flutter test
dart format <file-yang-diubah>
```

Gunakan format hanya pada file yang diubah, bukan seluruh project, kecuali diminta.

Jangan menjalankan tanpa persetujuan:

```bash
flutter upgrade
flutter downgrade
flutter pub upgrade
flutter pub upgrade --major-versions
dart fix --apply
flutter create .
flutter clean
pod update
gradlew clean
git reset --hard
git clean -fd
git checkout .
git restore .
```

`flutter clean` dan clean command lain hanya boleh digunakan setelah menjelaskan alasan dan dampaknya.

## Workflow

Untuk setiap task:

1. pahami request,
2. baca struktur project,
3. periksa `pubspec.yaml`,
4. identifikasi versi dan pola existing yang relevan,
5. cari file yang berhubungan dengan task,
6. cari implementasi serupa dalam project,
7. jelaskan akar masalah atau kebutuhan perubahan,
8. jelaskan rencana perubahan,
9. edit file seminimal mungkin,
10. jangan mengubah versi kecuali disetujui,
11. jalankan pemeriksaan yang relevan,
12. jelaskan hasil perubahan,
13. beri cara test atau manual check.

Untuk task sederhana, tetap lakukan pemeriksaan singkat sebelum mengedit.

Untuk task kompleks, jangan langsung mengubah kode sebelum menjelaskan rencana.

## Testing and Validation

Setelah perubahan, lakukan pemeriksaan yang relevan.

Prioritas pemeriksaan:

```bash
dart format <file-yang-diubah>
flutter analyze
flutter test
```

Jangan mengklaim test berhasil jika command belum dijalankan.

Jika test tidak dapat dijalankan:

* jelaskan alasan,
* sebutkan bagian yang belum tervalidasi,
* berikan langkah manual check.

Jika terdapat error existing yang tidak disebabkan oleh perubahan:

* pisahkan error existing dari error baru,
* jangan memperbaiki semua error existing tanpa diminta,
* jelaskan error tersebut pada laporan akhir.

## Scope Control

* Kerjakan hanya scope yang diminta.
* Jangan melakukan improvement tambahan tanpa menjelaskan terlebih dahulu.
* Jangan melakukan cleanup besar bersamaan dengan bug fix.
* Jangan mengubah banyak file jika solusi dapat dilakukan pada satu atau dua file.
* Jangan memperbaiki warning lain yang tidak berkaitan dengan task.
* Jangan mengganti pola lama dengan best practice baru tanpa mempertimbangkan kompatibilitas.
* Utamakan stabilitas project dibanding modernisasi.

## Response Format

Setelah selesai, jawab dengan format berikut:

### 1. Ringkasan Perubahan

Jelaskan secara singkat apa yang diperbaiki atau ditambahkan.

### 2. File yang Diubah

Sebutkan setiap file yang diubah dan fungsi perubahannya.

### 3. Versi dan Dependency

Jelaskan apakah ada versi atau dependency yang berubah.

Jika tidak ada, tuliskan:

```text
Tidak ada perubahan versi Flutter, Dart, Gradle, Kotlin, SDK, atau dependency.
```

### 4. Cara Menjalankan atau Test

Berikan command dan langkah manual untuk mengecek hasil.

### 5. Hasil Validasi

Sebutkan hasil dari:

* formatting,
* `flutter analyze`,
* `flutter test`,
* build atau manual check jika dilakukan.

Jangan menyatakan berhasil apabila belum benar-benar dijalankan.

### 6. Risiko atau Hal yang Perlu Dicek Manual

Jelaskan risiko, keterbatasan, atau hal yang perlu diperiksa pengguna.

## Definition of Done

Task dianggap selesai jika:

* request utama sudah dipenuhi,
* perubahan tetap dalam scope,
* perubahan file dibuat seminimal mungkin,
* pola existing tetap dipertahankan,
* tidak ada perubahan versi tanpa persetujuan,
* tidak ada dependency baru tanpa persetujuan,
* tidak ada secret atau credential yang terekspos,
* file yang berubah sudah dijelaskan,
* cara test sudah diberikan,
* hasil validasi dilaporkan secara jujur.
