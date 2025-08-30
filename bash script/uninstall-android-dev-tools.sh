#!/bin/bash

echo "🧹 Starting full cleanup of Android Studio, Java, Flutter, and React Native..."

### ---- Android Studio Removal ---- ###
echo "🔧 Removing Android Studio..."
sudo rm -rf /Applications/Android\ Studio.app
rm -rf ~/Library/Application\ Support/Google/AndroidStudio*
rm -rf ~/Library/Preferences/AndroidStudio*
rm -rf ~/Library/Logs/AndroidStudio*
rm -rf ~/Library/Caches/AndroidStudio*
rm -rf ~/Library/Android
rm -rf ~/.android
rm -rf ~/.gradle
rm -rf ~/.config/Google
rm -rf ~/Library/Application\ Support/JetBrains
rm -rf ~/Library/Preferences/com.jetbrains.*

### ---- Java (JDK) Removal ---- ###
echo "🔧 Removing Java (JDK)..."
sudo rm -rf /Library/Java/JavaVirtualMachines/*
sudo rm -rf /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin
sudo rm -rf /Library/PreferencePanes/JavaControlPanel.prefPane
sudo rm -rf ~/Library/Application\ Support/Oracle/Java

### ---- Flutter Removal ---- ###
echo "🔧 Removing Flutter..."
rm -rf ~/flutter
rm -rf ~/.flutter
rm -rf ~/.pub-cache
rm -rf ~/.dart-server
rm -rf ~/.dart-tool
rm -rf ~/.config/flutter
rm -rf ~/.config/dart

### ---- React Native Removal ---- ###
echo "🔧 Removing React Native..."
npm uninstall -g react-native-cli expo-cli
yarn global remove react-native-cli expo-cli
rm -rf /tmp/metro-*
find ~/ -name "node_modules" -type d -prune -exec rm -rf '{}' +

### ---- Cache Cleanup ---- ###
echo "🔧 Removing caches..."
rm -rf ~/.npm
rm -rf ~/.yarn
rm -rf ~/.nvm
rm -rf ~/.cache

echo "✅ All specified development tools and related files have been removed."
