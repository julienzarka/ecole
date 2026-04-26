import 'package:flutter/material.dart';

import '../../../shared/widgets/scaffold_message.dart';

class ApeRequestScreen extends StatelessWidget {
  const ApeRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScaffold(
      title: 'Demande d\'adhésion APE',
      message:
          'Upload du justificatif et choix de l\'école (à brancher sur Cloud Storage).',
    );
  }
}
