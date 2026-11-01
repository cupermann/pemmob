@echo off
cd /d "%~dp0"
where flutter >nul 2>nul
if errorlevel 1 (
  echo ERROR: Flutter SDK belum terpasang atau belum ada di PATH.
  echo Install Flutter dan Flutter plugin Android Studio terlebih dahulu.
  pause
  exit /b 1
)
echo Melengkapi file Android native dan Gradle wrapper...
call flutter create --platforms=android --project-name fixora_mobile .
if errorlevel 1 goto error
call flutter pub get
if errorlevel 1 goto error
echo.
echo Selesai. Buka folder ini di Android Studio dan jalankan lib/main.dart.
pause
exit /b 0
:error
echo Setup gagal. Jalankan flutter doctor -v untuk memeriksa lingkungan.
pause
exit /b 1
