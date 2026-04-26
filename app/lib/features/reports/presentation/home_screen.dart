import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('école-asso'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Profil',
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push(AppRoutes.profile),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Collège Jean Moulin',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Paris 11e · Public',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => context.push(AppRoutes.declare),
              icon: const Icon(Icons.add),
              label: const Text('Signaler une absence'),
            ),
            const SizedBox(height: 24),
            Text(
              'Mes signalements',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const _ReportTile(
              status: 'En attente de validation',
              statusColor: Colors.orange,
              summary: 'Maths · 4e · 22 avril · 1 h',
            ),
            const SizedBox(height: 8),
            const _ReportTile(
              status: 'Validé',
              statusColor: Colors.green,
              summary: 'AESH · 6e · 18 avril · 1 j',
            ),
            const SizedBox(height: 8),
            const _ReportTile(
              status: 'Rejeté · doublon',
              statusColor: Colors.red,
              summary: 'Anglais · 4e · 15 avril',
            ),
            const SizedBox(height: 24),
            FilledButton.tonal(
              onPressed: () => context.push(AppRoutes.stats),
              child: const Text('Voir les stats publiques'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({
    required this.status,
    required this.statusColor,
    required this.summary,
  });

  final String status;
  final Color statusColor;
  final String summary;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(status, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 2),
                  Text(summary, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
