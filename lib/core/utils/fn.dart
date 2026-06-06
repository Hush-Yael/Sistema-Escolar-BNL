import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void toast({
  required BuildContext context,
  required String message,
  Duration duration = const Duration(seconds: 5),
  Alignment? alignment,
  bool destructive = false,
}) {
  ShadToaster.of(context).show(
    Function.apply(destructive ? ShadToast.destructive : ShadToast.new, null, {
      #title: Text(message),
      #duration: duration,
      #alignment: alignment,
    }),
  );
}

// Prevents future from resolving too soon, useful to avoid flickering
Future<T> delay<T>(
  Future<T> resource, [
  Duration duration = const Duration(milliseconds: 500),
]) async {
  final [awaited, _] = await Future.wait([resource, Future.delayed(duration)]);
  return awaited;
}

Future<dynamic> confirmDeletion(
  BuildContext context, {
  required String title,
  required String msg,
  required void Function() onConfirmed,
  String cancelTxt = 'No, cancelar',
  String confirmTxt = 'Sí, eliminar',
}) => showShadDialog(
  context: context,
  builder: (context) => ShadDialog.alert(
    title: Text(title),
    description: Text(msg),
    actions: [
      ShadButton.outline(
        child: Text(cancelTxt),
        onPressed: () => Navigator.pop(context, 'No'),
      ),

      ShadButton.destructive(
        child: Text(confirmTxt),
        onPressed: () {
          onConfirmed();
          Navigator.pop(context, 'Si');
        },
      ),
    ],
  ),
);
