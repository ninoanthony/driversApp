import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drivers_app/Models/allUsers.dart';
import 'package:geolocator/geolocator.dart';

String mapKey = "AIzaSyBy5oklSOKVd4xpmSVUSq2E9jWbuxfId04";

User firebaseUser;

Users userCurrentInfo;

User currentfirebaseUser;

StreamSubscription<Position> homeTabPageStreamSubscription;

final assetsAudioPlayer = AssetsAudioPlayer();

