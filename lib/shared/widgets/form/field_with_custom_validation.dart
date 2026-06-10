import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/shared/debouncer.dart';
import 'package:sistema_escolar_bnl/shared/form_with_async_validation.dart';
import 'package:sistema_escolar_bnl/shared/widgets/form/label.dart';

typedef AsyncValidator<T> = AsyncValidatorResult Function(T value);
typedef AsyncValidatorResult = Future<String?>;
typedef ValidatorFn<T> = String? Function(T? value);

/// Widget that wraps a form field with custom validation logic.
///
/// This widget handles both synchronous and asynchronous validation,
/// debouncing validation calls to improve performance.
class FieldWithCustomValidation<T> extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    void Function(T?) onChanged,
    ValidatorFn<T> validator,
  )
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

    return builder(context, onChanged, validate);
  }

  factory FieldWithCustomValidation.text(TextFactoryParams<T> params) {
    return FieldWithCustomValidation<T>(
      validate: params.validate,
      validateAsync: params.validateAsync,
      getFieldState: () => params.vm.getFieldState(params.id),
      builder: (context, onChanged, validator) => ShadInputFormField(
        id: params.id.name,
        label: Label(params.label),
        keyboardType: params.keyboardType,
        enabled: params.vm.enabled,
        onSubmitted: (_) => params.vm.submit(context),
        validator: validator as String? Function(String?),
        onChanged: onChanged as void Function(String?),
      ),
    );
  }

  factory FieldWithCustomValidation.textarea(TextFactoryParams<T> params) {
    return FieldWithCustomValidation<T>(
      validate: params.validate,
      validateAsync: params.validateAsync,
      getFieldState: () => params.vm.getFieldState(params.id),
      builder: (context, onChanged, validator) => ShadTextareaFormField(
        id: params.id.name,
        label: Label(params.label),
        resizable: false,
        enabled: params.vm.enabled,
        onSubmitted: (_) => params.vm.submit(context),
        validator: validator as String? Function(String?),
        onChanged: onChanged as void Function(String?),
      ),
    );
  }
}

class FactoriesCommonParams<T> {
  final Enum id;
  final FormWithAsyncValidation vm;
  final ValidatorFn<T> validate;
  final AsyncValidator<T>? validateAsync;
  final String label;

  const FactoriesCommonParams({
    required this.id,
    required this.vm,
    required this.validate,
    this.validateAsync,
    required this.label,
  });
}

class TextFactoryParams<T> extends FactoriesCommonParams<T> {
  final TextInputType? keyboardType;

  TextFactoryParams({
    required super.id,
    required super.vm,
    required super.validate,
    super.validateAsync,
    required super.label,
    this.keyboardType,
  });
}
