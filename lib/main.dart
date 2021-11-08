import 'package:flutter/material.dart';
import 'package:goran_game/game_screen.dart';
import 'package:flame/flame.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();

  runApp(const GameScreen());
}