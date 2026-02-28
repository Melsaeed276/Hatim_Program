import 'dart:io';

enum RuleSeverity { error, warning }

class DesignGuardRule {
  const DesignGuardRule({
    required this.id,
    required this.description,
    required this.severity,
    required this.evaluate,
  });

  final String id;
  final String description;
  final RuleSeverity severity;
  final List<String> Function(DesignGuardContext context) evaluate;
}

class DesignGuardContext {
  const DesignGuardContext({
    required this.repoRoot,
    required this.packageRoot,
    required this.targets,
    required this.changedPaths,
    required this.changedOnly,
  });

  final Directory repoRoot;
  final Directory packageRoot;
  final List<DesignFileTarget> targets;
  final List<String> changedPaths;
  final bool changedOnly;
}

class DesignFileTarget {
  const DesignFileTarget({required this.path, required this.contents});

  final String path;
  final String contents;
}

Future<void> main(List<String> args) async {
  final bool changedOnly = args.contains('--changed-only');
  final String? baseRef = _readArgValue(args, '--base-ref');

  final Directory packageRoot = Directory.current;
  final Directory repoRoot = packageRoot.parent;

  final List<String> changedPaths = changedOnly
      ? await _readChangedPaths(repoRoot.path, baseRef)
      : <String>[];

  final List<DesignFileTarget> targets = await _collectTargets(
    packageRoot.path,
    changedPaths,
    changedOnly,
  );

  final DesignGuardContext context = DesignGuardContext(
    repoRoot: repoRoot,
    packageRoot: packageRoot,
    targets: targets,
    changedPaths: changedPaths,
    changedOnly: changedOnly,
  );

  final List<DesignGuardRule> rules = <DesignGuardRule>[
    DesignGuardRule(
      id: 'NO_HARDCODED_COLOR',
      description: 'Disallow hardcoded colors outside theme files.',
      severity: RuleSeverity.error,
      evaluate: _checkHardcodedColors,
    ),
    DesignGuardRule(
      id: 'NO_TEXTSTYLE_CONSTRUCTOR',
      description: 'Disallow TextStyle constructor usage outside theme files.',
      severity: RuleSeverity.error,
      evaluate: _checkTextStyleConstructors,
    ),
    DesignGuardRule(
      id: 'INTERACTIVE_SEMANTICS',
      description: 'Require semantics in design preview interactive widgets.',
      severity: RuleSeverity.error,
      evaluate: _checkSemanticsInDesignPreview,
    ),
    DesignGuardRule(
      id: 'DOC_COMPONENTS_PRESENT',
      description:
          'Ensure component documentation contains Shared Widgets section.',
      severity: RuleSeverity.error,
      evaluate: _checkComponentsDocumentation,
    ),
    DesignGuardRule(
      id: 'PREVIEW_GOLDEN_COVERAGE',
      description:
          'Require golden test updates when design preview layout changes.',
      severity: RuleSeverity.error,
      evaluate: _checkPreviewGoldenCoverage,
    ),
  ];

  final List<String> violations = <String>[];
  final List<String> warnings = <String>[];

  for (final DesignGuardRule rule in rules) {
    final List<String> findings = rule.evaluate(context);
    if (findings.isEmpty) {
      continue;
    }

    final List<String> target = rule.severity == RuleSeverity.error
        ? violations
        : warnings;
    for (final String message in findings) {
      target.add('[${rule.id}] $message');
    }
  }

  if (warnings.isNotEmpty) {
    stdout.writeln('Design guard warnings:');
    for (final String warning in warnings) {
      stdout.writeln('  - $warning');
    }
  }

  if (violations.isNotEmpty) {
    stderr.writeln(
      'Design guard failed with ${violations.length} violation(s):',
    );
    for (final String violation in violations) {
      stderr.writeln('  - $violation');
    }
    exit(1);
  }

  stdout.writeln('Design guard passed with no violations.');
}

String? _readArgValue(List<String> args, String flag) {
  for (var i = 0; i < args.length - 1; i++) {
    if (args[i] == flag) {
      return args[i + 1];
    }
  }
  return null;
}

Future<List<String>> _readChangedPaths(String repoPath, String? baseRef) async {
  final String resolvedBaseRef = (baseRef == null || baseRef.isEmpty)
      ? 'HEAD~1'
      : baseRef;

  final ProcessResult result = await Process.run('git', <String>[
    'diff',
    '--name-only',
    '--diff-filter=ACMRTUXB',
    '$resolvedBaseRef...HEAD',
  ], workingDirectory: repoPath);

  if (result.exitCode != 0) {
    stderr.writeln(
      'Could not read changed files from git diff for $resolvedBaseRef. '
      'Falling back to full repository scan.',
    );
    return <String>[];
  }

  return result.stdout
      .toString()
      .split('\n')
      .map((String path) => path.trim())
      .where((String path) => path.isNotEmpty)
      .toList();
}

Future<List<DesignFileTarget>> _collectTargets(
  String packageRootPath,
  List<String> changedPaths,
  bool changedOnly,
) async {
  final List<DesignFileTarget> targets = <DesignFileTarget>[];

  if (changedOnly && changedPaths.isNotEmpty) {
    for (final String path in changedPaths) {
      if (!path.endsWith('.dart')) {
        continue;
      }

      String? packageRelative;
      if (path.startsWith('project_code/lib/')) {
        packageRelative = path.replaceFirst('project_code/', '');
      } else if (path.startsWith('lib/')) {
        packageRelative = path;
      }

      if (packageRelative == null || !packageRelative.startsWith('lib/')) {
        continue;
      }

      final File file = File('$packageRootPath/$packageRelative');
      if (!file.existsSync()) {
        continue;
      }

      targets.add(
        DesignFileTarget(
          path: 'project_code/$packageRelative',
          contents: await file.readAsString(),
        ),
      );
    }

    return targets;
  }

  final Directory libDir = Directory('$packageRootPath/lib');
  if (!libDir.existsSync()) {
    return targets;
  }

  await for (final FileSystemEntity entity in libDir.list(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) {
      continue;
    }

    final String normalized = entity.path.replaceAll('\\', '/');
    final int index = normalized.indexOf('/lib/');
    final String relative = index >= 0
        ? normalized.substring(index + 1)
        : normalized;

    targets.add(
      DesignFileTarget(
        path: 'project_code/$relative',
        contents: await entity.readAsString(),
      ),
    );
  }

  return targets;
}

List<String> _checkHardcodedColors(DesignGuardContext context) {
  final RegExp colorsClass = RegExp(r'\bColors\.');
  final RegExp colorConstructor = RegExp(r'\bColor\s*\(');

  final List<String> violations = <String>[];
  for (final DesignFileTarget target in context.targets) {
    if (_isThemeFile(target.path)) {
      continue;
    }

    if (colorsClass.hasMatch(target.contents) ||
        colorConstructor.hasMatch(target.contents)) {
      violations.add('${target.path} contains hardcoded color usage.');
    }
  }

  return violations;
}

List<String> _checkTextStyleConstructors(DesignGuardContext context) {
  final RegExp textStyleCtor = RegExp(r'\bTextStyle\s*\(');
  final List<String> violations = <String>[];

  for (final DesignFileTarget target in context.targets) {
    if (_isThemeFile(target.path)) {
      continue;
    }

    if (textStyleCtor.hasMatch(target.contents)) {
      violations.add(
        '${target.path} uses TextStyle constructor outside theme helpers.',
      );
    }
  }

  return violations;
}

List<String> _checkSemanticsInDesignPreview(DesignGuardContext context) {
  final RegExp interactive = RegExp(
    r'\b(FilledButton|OutlinedButton|TextButton|ElevatedButton|IconButton|FloatingActionButton|GestureDetector|InkWell)\b',
  );

  final List<String> violations = <String>[];
  for (final DesignFileTarget target in context.targets) {
    if (!target.path.contains('project_code/lib/features/design_preview/')) {
      continue;
    }

    if (interactive.hasMatch(target.contents) &&
        !target.contents.contains('Semantics(')) {
      violations.add(
        '${target.path} defines interactive widgets without Semantics wrapper.',
      );
    }
  }

  return violations;
}

List<String> _checkComponentsDocumentation(DesignGuardContext context) {
  final File componentsDoc = File(
    '${context.repoRoot.path}/docs/design-system/components.md',
  );
  if (!componentsDoc.existsSync()) {
    return <String>['docs/design-system/components.md is missing.'];
  }

  final String contents = componentsDoc.readAsStringSync();
  if (!contents.contains('## Shared Widgets')) {
    return <String>[
      'docs/design-system/components.md must include a "## Shared Widgets" section.',
    ];
  }

  return <String>[];
}

List<String> _checkPreviewGoldenCoverage(DesignGuardContext context) {
  if (!context.changedOnly || context.changedPaths.isEmpty) {
    return <String>[];
  }

  final bool previewChanged = context.changedPaths.any(
    (String path) =>
        path.startsWith('project_code/lib/features/design_preview/'),
  );

  if (!previewChanged) {
    return <String>[];
  }

  final bool goldenChanged = context.changedPaths.any(
    (String path) =>
        path.startsWith('project_code/test/goldens/') ||
        path == 'project_code/test/design/design_golden_test.dart',
  );

  if (goldenChanged) {
    return <String>[];
  }

  return <String>[
    'Design preview files changed but no golden file or golden test update was detected.',
  ];
}

bool _isThemeFile(String path) {
  return path.startsWith('project_code/lib/app/theme/');
}
