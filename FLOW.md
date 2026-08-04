# Screenshot & demo regeneration

How the captured `screenshots/` PNGs and `screenshots/demo.gif` are produced. Everything is
driven by a launch-argument router in `ChainAlertApp.swift`, so any screen can be rendered
directly without tapping through the app.

## How the router works

`RootView` reads launch arguments (as `UserDefaults` values):

- `-SCREEN <key>` renders one screen directly via `ScreenRouter`, where `<key>` is a design
  screen name, e.g. `06-feed`, `11-alert-rules`, `13-subscription-manage`. The three primary
  screens (feed / tracked / settings) are rendered with the mandatory bottom tab bar pinned.
- `-DEMO YES` runs `DemoTour`, which auto-advances through a curated set of screens every
  1.4s with a fade - used only to record the demo GIF.

With no arguments the app runs the normal flow: onboarding -> paywall -> main tab bar.

## 1. Build and install

```sh
xcodegen generate
xcrun simctl boot "iPhone 17 Pro"
xcodebuild -project ChainAlert.xcodeproj -scheme ChainAlert \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  -derivedDataPath build -configuration Debug build
xcrun simctl install booted build/Build/Products/Debug-iphonesimulator/ChainAlert.app
```

## 2. Capture the 13 screen PNGs

```sh
BID=com.chainalert.app
screens=(01-onboarding-welcome 02-onboarding-track 03-onboarding-rules \
  04-onboarding-notifications 05-paywall 06-feed 07-alert-detail 08-tracked-entities \
  09-add-entity 10-entity-detail 11-alert-rules 12-settings 13-subscription-manage)
for s in "${screens[@]}"; do
  xcrun simctl terminate booted "$BID" 2>/dev/null
  xcrun simctl launch booted "$BID" -SCREEN "$s"
  sleep 1.6
  xcrun simctl io booted screenshot "screenshots/$s.png"
done
```

If a stray iOS system alert appears, `xcrun simctl erase "iPhone 17 Pro"` for a clean state,
then reboot / reinstall before capturing.

## 3. Record the demo GIF

```sh
BID=com.chainalert.app
xcrun simctl launch booted "$BID" -DEMO YES
xcrun simctl io booted recordVideo --codec=h264 /tmp/chainalert-demo.mov &   # Ctrl-C after ~14s
# convert to an optimized GIF
ffmpeg -y -i /tmp/chainalert-demo.mov -vf "fps=12,scale=300:-1:flags=lanczos,palettegen=stats_mode=diff" /tmp/pal.png
ffmpeg -y -i /tmp/chainalert-demo.mov -i /tmp/pal.png \
  -lavfi "fps=12,scale=300:-1:flags=lanczos[x];[x][1:v]paletteuse=dither=bayer:bayer_scale=3" \
  screenshots/demo.gif
```
