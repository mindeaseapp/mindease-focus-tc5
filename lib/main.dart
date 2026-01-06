
import 'package:flutter/material.dart';
import 'features/dashboard/presentation/dashboard_page.dart';

void main() {
  runApp(const MindEaseApp());
}

class MindEaseApp extends StatelessWidget {
  const MindEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindEase',
      theme: ThemeData(useMaterial3: true),
      home: const DashboardPage(),
    );
  }
}
