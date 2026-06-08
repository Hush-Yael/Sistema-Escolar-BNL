import 'package:flutter/widgets.dart';
import 'package:sistema_escolar_bnl/core/theme/theme.dart';

class Label extends StatelessWidget {
  final String text;
  const Label(this.text, {super.key, required});

  @override
  Widget build(BuildContext context) {
    final labelStyles = AppTheme.labelStyles(context);

    return Text(text, style: labelStyles);
  }
}
