import 'package:flutter/material.dart';
import 'package:sistema_escolar_bnl/shared/debouncer.dart';
import 'package:sistema_escolar_bnl/shared/form_with_async_validation.dart';

typedef AsyncValidator<T> = AsyncValidatorResult Function(T value);
typedef AsyncValidatorResult = Future<String?>;
typedef ValidatorFn<T> = String? Function(T? value);

/// Widget that wraps a form field with custom validation logic.
///
/// This widget handles both synchronous and asynchronous validation,
/// debouncing validation calls to improve performance.
class FieldWithCustomValidation<T> extends StatelessWidget {
  final Widget Function(void Function(T?) onChanged, ValidatorFn<T> validator)
  builder;
  final FieldState Function() getFieldState;
  final ValidatorFn<T> validate;
  final AsyncValidator<T>? validateAsync;

  const FieldWithCustomValidation({
    super.key,
    required this.builder,
    required this.getFieldState,
    required this.validate,
    this.validateAsync,
  });

  @override
  Widget build(BuildContext context) {
    FieldState fieldState;
    final debouncer = Debouncer(500);

    void onChanged(T? value) {
      fieldState ??= getFieldState();
      fieldState!.setError(null);

      debouncer.run(() {
        final error = validate(value);

        if (error != null) return fieldState!.setError(error);

        if (validateAsync != null && value != null) {
          Future.microtask(() async {
            final asyncError = await validateAsync!(value);

            if (asyncError != null) fieldState!.setError(asyncError);
          });
        }
      });
    }

    return builder(onChanged, validate);
  }
}
