import 'billing_gateway.dart';
import 'billing_gateway_stub.dart'
    if (dart.library.io) 'billing_gateway_io.dart';

BillingGateway createBillingGateway() => createPlatformBillingGateway();
