import 'package:flutter/widgets.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/shared/widgets/form/label.dart';

class PasswordField extends StatelessWidget {
  final String? id;
  final String? label;
  final String? placeholder;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final AutovalidateMode? autovalidateMode;
  final bool? enabled;
  final Widget? leading;

  const PasswordField({
    super.key,
    this.label,
    this.placeholder,
    this.leading,
    this.id,
    this.controller,
    this.validator,
    this.onSubmitted,
    this.onChanged,
    this.autovalidateMode,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final obscure = Signal(true);

    return SignalBuilder(
      builder: (context, child) => ShadInputFormField(
        id: id,
        label: label != null ? Label(label!) : null,
        placeholder: placeholder != null ? Text(placeholder!) : null,
        obscureText: obscure.value,
        controller: controller,
        validator: validator,
        leading: leading,
        enabled: enabled ?? true,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        autovalidateMode: autovalidateMode,
        trailing: SizedBox.square(
          dimension: 24,
          child: OverflowBox(
            maxWidth: 28,
            maxHeight: 28,
            child: ShadIconButton.ghost(
              iconSize: 18,
              padding: const .all(2),
              icon: Icon(obscure.value ? LucideIcons.eyeOff : LucideIcons.eye),
              onPressed: () => obscure.value = !obscure.value,
            ),
          ),
        ),
      ),
    );
  }
}
