#!/bin/sh
set -e
cd "$(dirname "$0")"
flutter create --platforms=android --project-name fixora_mobile .
flutter pub get
printf '\nSiap. Buka folder ini di Android Studio lalu run lib/main.dart.\n'
