import 'package:flutter/material.dart';
import 'progress_service.dart';

class ProgressScope extends InheritedNotifier<ProgressService> {
  const ProgressScope({
    super.key,
    required ProgressService progressService,
    required super.child,
  }) : super(notifier: progressService);

  static ProgressService of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ProgressScope>();
    assert(scope != null, 'No ProgressScope found in BuildContext');
    return scope!.notifier!;
  }
}
