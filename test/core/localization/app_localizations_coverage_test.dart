import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/core/localization/app_localizations.dart';

void main() {
  test('all supported languages expose the same localization keys', () {
    final source =
        File('lib/core/localization/app_localizations.dart').readAsStringSync();
    final localeKeys = <String, Set<String>>{};

    for (final mapName in ['_localizedValues', '_extendedLocalizedValues']) {
      final mapBlock = _extractConstMap(source, mapName);
      final parsed = _parseLocaleBlocks(mapBlock);
      for (final entry in parsed.entries) {
        localeKeys.putIfAbsent(entry.key, () => <String>{}).addAll(entry.value);
      }
    }

    expect(localeKeys.keys.toSet(), supportedLanguageCodes.toSet());

    final allKeys = localeKeys.values.fold<Set<String>>(
      <String>{},
      (keys, localeSet) => keys..addAll(localeSet),
    );

    for (final code in supportedLanguageCodes) {
      expect(
        localeKeys[code],
        containsAll(allKeys),
        reason: '$code locale is missing localization keys',
      );
    }
  });

  test(
      'every l10n key used in lib has a translation in every supported language',
      () {
    final source =
        File('lib/core/localization/app_localizations.dart').readAsStringSync();
    final localeKeys = <String, Set<String>>{};

    for (final mapName in ['_localizedValues', '_extendedLocalizedValues']) {
      final parsed = _parseLocaleBlocks(_extractConstMap(source, mapName));
      for (final entry in parsed.entries) {
        localeKeys.putIfAbsent(entry.key, () => <String>{}).addAll(entry.value);
      }
    }

    final usedKeys = <String>{};
    for (final file in Directory('lib').listSync(recursive: true)) {
      if (file is! File || !file.path.endsWith('.dart')) continue;
      if (file.path.endsWith('.g.dart') ||
          file.path.endsWith('.freezed.dart')) {
        continue;
      }

      final text = file.readAsStringSync();
      for (final pattern in [
        RegExp(r"\.t\('([^']+)'\)"),
        RegExp(r"\.tf\('([^']+)'"),
        RegExp(r"\.upper\('([^']+)'\)"),
      ]) {
        usedKeys.addAll(pattern.allMatches(text).map((match) => match[1]!));
      }
    }

    for (final code in supportedLanguageCodes) {
      final missing = usedKeys.difference(localeKeys[code] ?? const {});
      expect(missing, isEmpty, reason: '$code is missing used keys: $missing');
    }
  });
}

String _extractConstMap(String source, String mapName) {
  final declaration = source.indexOf('static const $mapName');
  expect(declaration, isNonNegative, reason: '$mapName not found');

  final start = source.indexOf('{', declaration);
  var depth = 0;
  for (var i = start; i < source.length; i++) {
    if (source[i] == '{') depth++;
    if (source[i] == '}') {
      depth--;
      if (depth == 0) {
        return source.substring(start + 1, i);
      }
    }
  }

  fail('Could not parse $mapName');
}

Map<String, Set<String>> _parseLocaleBlocks(String mapBlock) {
  final localeKeys = <String, Set<String>>{};
  var offset = 0;
  final localeStartPattern = RegExp(r"'([a-z]{2})'\s*:\s*\{");

  while (offset < mapBlock.length) {
    final match = localeStartPattern.matchAsPrefix(mapBlock, offset) ??
        localeStartPattern.firstMatch(mapBlock.substring(offset));
    if (match == null) break;

    final matchStart =
        localeStartPattern.matchAsPrefix(mapBlock, offset) == null
            ? offset + match.start
            : offset;
    final code = match[1]!;
    final blockStart = matchStart + match.group(0)!.length - 1;
    var depth = 0;
    var blockEnd = blockStart;

    for (var i = blockStart; i < mapBlock.length; i++) {
      if (mapBlock[i] == '{') depth++;
      if (mapBlock[i] == '}') {
        depth--;
        if (depth == 0) {
          blockEnd = i;
          break;
        }
      }
    }

    final localeBlock = mapBlock.substring(blockStart + 1, blockEnd);
    final keys = RegExp(r"'([^']+)'\s*:")
        .allMatches(localeBlock)
        .map((match) => match[1]!)
        .toSet();
    localeKeys[code] = keys;
    offset = blockEnd + 1;
  }

  return localeKeys;
}
