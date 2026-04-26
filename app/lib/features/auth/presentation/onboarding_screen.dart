import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  static const List<_Slide> _slides = <_Slide>[
    _Slide(
      title: 'Signaler en 30 secondes',
      body:
          'Saisissez l\'absence d\'un enseignant, AESH, ATSEM ou animateur en quelques taps.',
    ),
    _Slide(
      title: 'Votre APE valide',
      body:
          'Seuls les membres validés d\'une APE rattachée à votre école peuvent confirmer un signalement.',
    ),
    _Slide(
      title: 'Stats publiques par école',
      body:
          'Les chiffres sont agrégés par établissement, commune et agglomération. Aucune donnée nominative.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        actions: <Widget>[
          TextButton(
            onPressed: () => context.go(AppRoutes.login),
            child: const Text('Passer'),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _slides.length,
              onPageChanged: (int i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                final _Slide slide = _slides[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        slide.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        slide.body,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int i = 0; i < _slides.length; i++)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: i == _index
                        ? scheme.primary
                        : scheme.outlineVariant,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: FilledButton(
              onPressed: _next,
              child: Text(_index < _slides.length - 1 ? 'Suivant' : 'Commencer'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Slide {
  const _Slide({required this.title, required this.body});
  final String title;
  final String body;
}
