import 'dart:ffi';
import 'dart:io';

import 'package:logging/logging.dart';

final searchPaths = [
  '/lib',
  '/usr/lib',
  '/lib32',
  '/lib64',
  '/usr/lib32',
  '/usr/lib64',
  '/usr/local/lib',
  '/usr/lib/x86_64-linux-gnu',
];

DynamicLibrary? tryLoadLibrary(String libName) {
  final log = Logger('tryLoadLibrary');
  for (final path in searchPaths) {
    final fullPath = '$path/$libName';
    if (File(fullPath).existsSync()) {
      log.info('Loading library from: $fullPath');
      return DynamicLibrary.open(fullPath);
    }
  }

  log.severe('Library $libName not found in search paths: $searchPaths');
  return null;
}
