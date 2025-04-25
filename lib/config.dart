import 'dart:io';
import 'package:logging/logging.dart';
import 'package:miracle_settings/ffi/miracle_config.dart';
import 'package:toml/toml.dart';
import 'package:path/path.dart' as p;

final String _configFileName = p.join('miracle-settings', 'config.toml');

String findOrCreateConfigFile(String relativePath) {
  final env = Platform.environment;
  final home = env['HOME'];
  if (home == null) {
    throw Exception("HOME environment variable is not set.");
  }

  final xdgConfigHome = env['XDG_CONFIG_HOME'] ?? p.join(home, '.config');
  final fallbackConfigPath = p.join(xdgConfigHome, relativePath);

  // Check if file exists in any XDG path
  final pathsToCheck = <String>[
    p.join(xdgConfigHome, relativePath),
    if (xdgConfigHome != p.join(home, '.config'))
      p.join(home, '.config', relativePath),
    for (final dir in (env['XDG_CONFIG_DIRS'] ?? '/etc/xdg').split(':'))
      p.join(dir, relativePath),
  ];

  for (final path in pathsToCheck) {
    final file = File(path);
    if (file.existsSync()) {
      return file.path;
    }
  }

  // If not found, create the file in $XDG_CONFIG_HOME or fallback
  final fileToCreate = File(fallbackConfigPath);
  fileToCreate.parent.createSync(recursive: true);
  fileToCreate.createSync();
  return fileToCreate.path;
}

class ConfigParser {
  final _log = Logger('ConfigParser');
  final String _configFilePath = findOrCreateConfigFile(_configFileName);

  String _getDefaultPath() {
    _log.info('Using default config path: ${MiracleConfig.defaultConfigPath}');
    return MiracleConfig.defaultConfigPath;
  }

  /// Attempts to read and parse the TOML file,
  /// and returns the value of `config_file_path` if it exists.
  Future<String> getConfigFilePath() async {
    try {
      final file = File(_configFilePath);
      _log.info('Miracle Settings file path: $_configFilePath');
      if (!await file.exists()) {
        _log.info('TOML file not found: $_configFilePath');
        return _getDefaultPath();
      }

      final content = await file.readAsString();
      final tomlMap = TomlDocument.parse(content).toMap();

      final configPath = tomlMap['config_file_path'];
      if (configPath is String) {
        return configPath;
      } else {
        _log.info('Key "config_file_path" not found or not a string.');
        return _getDefaultPath();
      }
    } catch (e) {
      _log.shout('Failed to parse TOML file: $e');
      return _getDefaultPath();
    }
  }
}
