import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/shared/mutations/index.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:meta/meta.dart';
import 'package:sistema_escolar_bnl/core/utils/fn.dart';
import 'package:sistema_escolar_bnl/shared/repository.dart';
import 'package:sistema_escolar_bnl/shared/widgets/form/field_with_custom_validation.dart';

class FormWithAsyncValidation<
  Repo extends Repository,
  MutInput extends Insertable
> {
  final bool isModal;

  SingleAddMutation<MutInput>? mutation;

  void ensureMutationIsSet(BuildContext context) =>
      mutation ??= createMutation(context);

  final Repo repository;

  FormWithAsyncValidation(this.repository, {this.isModal = false});

  final formKey = GlobalKey<ShadFormState>();

  late final isSubmitting = Signal(false, autoDispose: !isModal);

  bool get enabled => !isSubmitting.value;
  bool get invalid => formKey.currentState!.saveAndValidate() != true;

  @mustBeOverridden
  Future<bool> checkAsyncErrorsBeforeSubmit() {
    throw UnimplementedError('Debe implementarse en la clase que lo use');
  }

  T getValue<T>(String key) {
    final val = formKey.currentState!.fields[key]?.value;

    if (val is String) return val.trim() as T;

    return val;
  }

  FieldState getFieldState<T extends Enum>(T key) {
    final state = formKey.currentState!.fields[key.name];
    if (state == null) throw Exception('Field ${key.name} not found');
    return state;
  }

  Future<bool> submit(BuildContext context) async {
    if (isSubmitting.value || invalid) return false;

    isSubmitting.value = true;

    final error = await delay(
      checkAsyncErrorsBeforeSubmit(),
      const .new(milliseconds: 250),
    );

    if (error) {
      if (context.mounted) {
        toast(
          context: context,
          destructive: true,
          message: 'Corrige los errores del formulario',
        );
      }

      return isSubmitting.value = false;
    }

    final input = createNewObj();

    try {
      await delay(mutation!.mutateAsync(input), const .new(milliseconds: 250));
      return true;
    } catch (e) {
      if (context.mounted) toast(context: context, message: e.toString());
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  @mustBeOverridden
  MutInput createNewObj() {
    throw UnimplementedError(
      'getFormData must be implemented to perform mutation',
    );
  }

  @mustBeOverridden
  SingleAddMutation<MutInput> createMutation(BuildContext context) =>
      throw UnimplementedError('createMutation must be overridden');

  AsyncValidatorResult checkFieldAsync<T>({
    required T value,
    required Future<bool> Function(T) repoCheckerFn,
    required String errorMsg,
  }) async {
    final found = await repoCheckerFn(value);
    return found ? errorMsg : null;
  }
}

class ModalFormWithAsyncValidation<
  Repo extends Repository,
  Input extends Insertable
>
    extends FormWithAsyncValidation<Repo, Input> {
  ModalFormWithAsyncValidation(super.repository, {super.isModal = true});

  /// Used signals must be disposed manually to prevent crashing when using them when modal is opened again
  void disposeSignals() {
    isSubmitting.dispose();
  }

  /// Dispose signals when the widget that shows  is disposed
  void useSignalsDispose() {
    useEffect(() {
      return disposeSignals;
    }, []);
  }

  @override
  // ignore: avoid_renaming_method_parameters
  Future<bool> submit(BuildContext modalContext) async {
    final fine = await super.submit(modalContext);

    if (fine && modalContext.mounted) Navigator.of(modalContext).pop();

    return fine;
  }

  @override
  @mustBeOverridden
  Future<bool> checkAsyncErrorsBeforeSubmit() {
    throw UnimplementedError();
  }

  @override
  @mustBeOverridden
  Input createNewObj() {
    throw UnimplementedError();
  }

  @override
  SingleAddMutation<Input> createMutation(BuildContext context) =>
      throw UnimplementedError('createMutation must be overridden');
}

typedef FieldState =
    ShadFormBuilderFieldState<ShadFormBuilderField<dynamic>, dynamic>?;
