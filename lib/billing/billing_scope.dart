import 'package:flutter/widgets.dart';

import 'billing_controller.dart';

class BillingScope extends InheritedNotifier<BillingController> {
  const BillingScope({
    super.key,
    required BillingController controller,
    required super.child,
  }) : super(notifier: controller);

  static BillingController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<BillingScope>();
    assert(scope != null, 'BillingScope is missing in this widget tree.');
    return scope!.notifier!;
  }

  static BillingController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<BillingScope>()
        ?.notifier;
  }
}
