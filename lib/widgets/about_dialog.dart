import 'package:flutter/material.dart';

class CustomAboutDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Text(
        'Funcionamento',
      ),
      content: Text(
        'Aberto aos dias: \n\t\t3ª, 4ª, 5ª, 6ª e Sábado\n\nHorários: \n\t\t19:30 até 22:30',
      ),
    );
  }
}
