import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router.dart';
import '../domain/report.dart';

/// Squelette du flow de déclaration multi-étapes (cf. specs/parcours.md, P2).
/// La logique de soumission Firestore est branchée plus tard.
class DeclareFlowScreen extends StatefulWidget {
  const DeclareFlowScreen({super.key});

  @override
  State<DeclareFlowScreen> createState() => _DeclareFlowScreenState();
}

class _DeclareFlowScreenState extends State<DeclareFlowScreen> {
  int _step = 0;
  AgentType? _agentType;
  SchoolLevel? _level;

  static const List<String> _stepTitles = <String>[
    'Type d\'agent',
    'Niveau',
    'Date et durée',
    'Remplacé ?',
    'Contexte',
    'Récap',
  ];

  void _next() {
    if (_step < _stepTitles.length - 1) {
      setState(() => _step += 1);
    } else {
      _submit();
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step -= 1);
    } else {
      context.pop();
    }
  }

  void _submit() {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Signalement envoyé'),
        content: const Text(
          'Il sera publié dans les statistiques après validation par votre APE. '
          'Délai habituel : 48 h.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go(AppRoutes.home);
            },
            child: const Text('Retour'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _back,
        ),
        title: Text('Signaler · ${_step + 1}/${_stepTitles.length}'),
      ),
      body: Column(
        children: <Widget>[
          LinearProgressIndicator(
            value: (_step + 1) / _stepTitles.length,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildStep(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: _next,
              child: Text(_step < _stepTitles.length - 1 ? 'Continuer' : 'Envoyer'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _AgentTypeGrid(
          selected: _agentType,
          onChange: (AgentType t) => setState(() => _agentType = t),
        );
      case 1:
        return _LevelChips(
          selected: _level,
          onChange: (SchoolLevel l) => setState(() => _level = l),
        );
      case 2:
        return const _PlaceholderStep('Date et durée (à brancher).');
      case 3:
        return const _PlaceholderStep('Remplacé ? (à brancher).');
      case 4:
        return const _PlaceholderStep('Contexte (à brancher).');
      default:
        return const _PlaceholderStep('Vérifiez et envoyez.');
    }
  }
}

class _AgentTypeGrid extends StatelessWidget {
  const _AgentTypeGrid({required this.selected, required this.onChange});

  final AgentType? selected;
  final ValueChanged<AgentType> onChange;

  static const Map<AgentType, String> _labels = <AgentType, String>{
    AgentType.teacher: 'Enseignant',
    AgentType.aesh: 'AESH',
    AgentType.atsem: 'ATSEM',
    AgentType.animator: 'Animateur ALSH',
    AgentType.aed: 'AED',
    AgentType.cpe: 'CPE',
    AgentType.cantine: 'Cantine',
    AgentType.garderie: 'Garderie',
    AgentType.etude: 'Étude',
  };

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2,
      children: <Widget>[
        for (final MapEntry<AgentType, String> e in _labels.entries)
          _AgentCard(
            label: e.value,
            isSelected: e.key == selected,
            onTap: () => onChange(e.key),
          ),
      ],
    );
  }
}

class _AgentCard extends StatelessWidget {
  const _AgentCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Card(
      color: isSelected ? scheme.primaryContainer : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _LevelChips extends StatelessWidget {
  const _LevelChips({required this.selected, required this.onChange});

  final SchoolLevel? selected;
  final ValueChanged<SchoolLevel> onChange;

  static const Map<SchoolLevel, String> _labels = <SchoolLevel, String>{
    SchoolLevel.ps: 'PS',
    SchoolLevel.ms: 'MS',
    SchoolLevel.gs: 'GS',
    SchoolLevel.cp: 'CP',
    SchoolLevel.ce1: 'CE1',
    SchoolLevel.ce2: 'CE2',
    SchoolLevel.cm1: 'CM1',
    SchoolLevel.cm2: 'CM2',
    SchoolLevel.sixieme: '6e',
    SchoolLevel.cinquieme: '5e',
    SchoolLevel.quatrieme: '4e',
    SchoolLevel.troisieme: '3e',
    SchoolLevel.seconde: '2nde',
    SchoolLevel.premiere: '1ère',
    SchoolLevel.terminale: 'Terminale',
  };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        for (final MapEntry<SchoolLevel, String> e in _labels.entries)
          ChoiceChip(
            label: Text(e.value),
            selected: e.key == selected,
            onSelected: (bool sel) {
              if (sel) onChange(e.key);
            },
          ),
      ],
    );
  }
}

class _PlaceholderStep extends StatelessWidget {
  const _PlaceholderStep(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
