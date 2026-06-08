import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/shared/form_with_async_validation.dart';

class SubmitBtn extends StatelessWidget {
  final double? width;
  final double loaderSize;
  final String text;
  final FormWithAsyncValidation form;

  const SubmitBtn({
    super.key,
    this.width,
    this.loaderSize = 16,
    required this.text,
    required this.form,
  });

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context, child) => ShadButton(
        onPressed: () => form.submit(context),
        enabled: !form.isSubmitting.value,
        leading: form.isSubmitting.value ? getLoader(context) : null,
        width: width,
        child: Text(text),
      ),
    );
  }

  Widget getLoader(BuildContext context) {
    return SizedBox.square(
      dimension: loaderSize,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: ShadTheme.of(context).colorScheme.primaryForeground,
      ),
    );
  }
}
