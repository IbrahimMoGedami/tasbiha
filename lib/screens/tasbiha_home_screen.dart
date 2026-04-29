import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tasbiha/storage/shared_preferences_helper.dart';
import 'package:tasbiha/storage/shared_preferences_key.dart';

class TasbihaHomeScreen extends StatefulWidget {
  const TasbihaHomeScreen({super.key});

  @override
  State<TasbihaHomeScreen> createState() => _TasbihaHomeScreenState();
}

class _TasbihaHomeScreenState extends State<TasbihaHomeScreen> {
  static const int _cycleLength = 33;

  int _total = 0;

  @override
  void initState() {
    super.initState();
    _total = SharedPreferencesHelper.instance
            .getInt(SharedPreferencesKey.appCounter) ??
        0;
  }

  int get _positionInCycle {
    if (_total == 0) return 0;
    final rem = _total % _cycleLength;
    return rem == 0 ? _cycleLength : rem;
  }

  int get _completedSets => _total ~/ _cycleLength;

  Future<void> _persist() async {
    await SharedPreferencesHelper.instance
        .setInt(SharedPreferencesKey.appCounter, _total);
  }

  void _onTap() {
    HapticFeedback.lightImpact();
    setState(() {
      _total++;
    });
    unawaited(_persist());
  }

  Future<void> _confirmReset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reset counter'),
          content: const Text(
            'This clears your saved count. This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
    if (ok != true || !mounted) return;
    HapticFeedback.mediumImpact();
    setState(() => _total = 0);
    unawaited(_persist());
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final display = _total == 0 ? '0' : '$_positionInCycle';

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              scheme.surface,
              Color.lerp(scheme.surface, scheme.primaryContainer, 0.35)!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      tooltip: 'Reset',
                      onPressed: _total == 0 ? null : _confirmReset,
                      icon: const Icon(Icons.restart_alt_rounded),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Column(
                  children: [
                    Text(
                      'تَسْبِيحَة',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: scheme.primary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tasbiha',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                            letterSpacing: 3,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'سُبْحَانَ اللَّه',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    Text(
                      'Subhan Allah',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Material(
                    color: scheme.surfaceContainerHighest.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(32),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      key: const Key('tasbiha_tap'),
                      onTap: _onTap,
                      splashColor: scheme.primary.withValues(alpha: 0.12),
                      highlightColor: scheme.primary.withValues(alpha: 0.06),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              display,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                    fontSize: 96,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'of $_cycleLength in this set',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Total: $_total',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (_completedSets > 0) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Sets completed: $_completedSets',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.touch_app_rounded,
                                  size: 20,
                                  color: scheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Tap here to count',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(color: scheme.primary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
