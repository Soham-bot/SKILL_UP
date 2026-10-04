import 'package:flutter/material.dart';
import 'app.dart';
import 'services/progress_scope.dart';
import 'services/progress_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await StorageService.initialize();
  final progressService = ProgressService(storage);

  runApp(
    ProgressScope(
      progressService: progressService,
      child: const SkillUpApp(),
    ),
  );
}
