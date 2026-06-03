import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:sistema_escolar_bnl/shared/mutations/index.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:sistema_escolar_bnl/core/db/db.dart';
import 'package:sistema_escolar_bnl/core/utils/fn.dart';

class FormWithAsyncValidation<
  MutInput,
  Mutation extends MutationResult<dynamic, Exception, MutInput>
> {
  final bool isModal;
  Mutation? mutation;

  FormWithAsyncValidation({this.isModal = false});

  final formKey = GlobalKey<ShadFormState>();

  late final isSubmitting = Signal(false, autoDispose: !isModal);

  bool get enabled => !isSubmitting.value;
  bool get invalid => formKey.currentState!.saveAndValidate() != true;

  Future<bool> checkAsyncErrorsBeforeSubmit() {
    throw UnimplementedError('Debe implementarse en la clase que lo use');
  }

  T getValue<T>(String key) {
    final val = formKey.currentState!.fields[key]?.value;

    if (val.runtimeType == String) return val.trim();

    return val;
  }

  Future<dynamic> submit(BuildContext context) async {
    if (isSubmitting.value || invalid) return;

    isSubmitting.value = true;

    final error = await delay(
      checkAsyncErrorsBeforeSubmit(),
      const .new(milliseconds: 250),
    );

    if (error) return isSubmitting.value = false;

    final input = getFormData();

    try {
      return await mutation!.mutateAsync(input);
    } catch (e) {
      if (context.mounted) toast(context: context, message: e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  MutInput getFormData() {
    throw UnimplementedError(
      'getFormData must be implemented to perform mutation',
    );
  }
}

class ModalFormWithAsyncValidation<Input, NewObj extends Object>
    extends FormWithAsyncValidation<Input, SingleAddMutation<Input, NewObj>> {
  ModalFormWithAsyncValidation(this.db, {super.isModal = true});

  final AppDatabase db;

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
  Future<dynamic> submit(BuildContext modalContext) async {
    final result = await super.submit(modalContext);

    if (modalContext.mounted) Navigator.of(modalContext).pop();

    return result;
  }
}
