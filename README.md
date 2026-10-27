# Как развернуть

1. `flutter create --org com.example --project-name balance_game balance_game`
2. Скопируйте поверх созданного проекта: `lib/`, `assets/`, `.github/`.
3. Из `pubspec_snippet.yaml` перенесите секции `dependencies` и `flutter: assets` в ваш `pubspec.yaml`
   (или просто выполните `flutter pub add flutter_card_swiper flutter_animate provider`
   и добавьте `assets/questions.json` в раздел assets).
4. `flutter pub get`, затем `flutter run`.
5. `git init`, `git add .`, `git commit`, `git push` в ветку `main`: APK появится во вкладке Actions → Artifacts → `balance-apk`.

Версии пакетов подобраны под Flutter stable; если `pub get` ругается на совместимость,
запустите `flutter pub upgrade --major-versions`. Код писался под API flutter_card_swiper 7.x
(`onSwipe(previous, current, direction)`, `AllowedSwipeDirection.only`).
Код не проверялся компиляцией (во время подготовки Flutter не был установлен), поэтому первую сборку лучше прогнать локально.
