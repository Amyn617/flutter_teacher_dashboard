import 'package:flutter/material.dart';
import 'package:teacher_dashboard/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, MMM d').format(DateTime.now());
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Reports',
        subtitle: today,
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://randomuser.me/api/portraits/women/44.jpg', // Placeholder
              ),
              radius: 18,
            ),
            onPressed: () {
              // Profile action
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: const Center(child: Text('Reports Page - Coming Soon!')),
    );
  }
}
