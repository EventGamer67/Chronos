import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

share({required String text, required List<Uint8List> files}) async {
  GetIt.I.get<Talker>().debug("STUB EXPORT");
}
