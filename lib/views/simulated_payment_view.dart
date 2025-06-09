// SimulatedPaymentView.dart
import 'package:flutter/material.dart';
import 'order_tracking_view.dart';

class SimulatedPaymentView extends StatefulWidget {
  const SimulatedPaymentView({super.key});

  @override
  State<SimulatedPaymentView> createState() => _SimulatedPaymentViewState();
}

class _SimulatedPaymentViewState extends State<SimulatedPaymentView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OrderTrackingView()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Procesando pago...', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
