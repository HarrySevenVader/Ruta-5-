// order_tracking_view.dart
import 'dart:async';
import 'package:flutter/material.dart';

class OrderTrackingView extends StatefulWidget {
  const OrderTrackingView({super.key});

  @override
  State<OrderTrackingView> createState() => _OrderTrackingViewState();
}

class _OrderTrackingViewState extends State<OrderTrackingView> {
  final StreamController<String> _statusController = StreamController<String>();
  final List<String> _statuses = [
    'Confirmado',
    'En preparación',
    'Listo para servir',
    'Entregado',
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _emitStatuses();
  }

  void _emitStatuses() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentIndex < _statuses.length) {
        _statusController.add(_statuses[_currentIndex]);
        _currentIndex++;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _statusController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguimiento del Pedido'),
        backgroundColor: const Color(0xFF14532D),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<String>(
        stream: _statusController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.local_dining, size: 60, color: Colors.green),
                const SizedBox(height: 20),
                Text(
                  'Estado actual:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  snapshot.data!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF14532D),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
