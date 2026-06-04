import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void toast({
  required BuildContext context,
  required String message,
  Duration duration = const Duration(seconds: 5),
  Alignment? alignment,
}) {
  ShadToaster.of(context).show(
    ShadToast(title: Text(message), duration: duration, alignment: alignment),
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
