import 'package:flutter/material.dart';
import 'simulated_payment_view.dart'; // Asegúrate de importar esta vista

class OrderModeView extends StatefulWidget {
  const OrderModeView({super.key});

  @override
  State<OrderModeView> createState() => _OrderModeViewState();
}

class _OrderModeViewState extends State<OrderModeView> {
  final _formKey = GlobalKey<FormState>();
  String _orderMode = 'mesa';
  final TextEditingController _mesaController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SimulatedPaymentView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: AppBar(
          backgroundColor: const Color(0xFF14532D),
          elevation: 0,
          toolbarHeight: 110,
          centerTitle: true,
          title: const Text(
            'Elegir modalidad de pedido',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selecciona la modalidad:',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              ListTile(
                title: const Text(
                  'En mesa (1 - 10)',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Radio<String>(
                  value: 'mesa',
                  groupValue: _orderMode,
                  onChanged: (value) {
                    setState(() {
                      _orderMode = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text(
                  'Para llevar',
                  style: TextStyle(color: Colors.black),
                ),
                leading: Radio<String>(
                  value: 'llevar',
                  groupValue: _orderMode,
                  onChanged: (value) {
                    setState(() {
                      _orderMode = value!;
                    });
                  },
                ),
              ),
              if (_orderMode == 'mesa') ...[
                TextFormField(
                  controller: _mesaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Número de mesa',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa un número de mesa';
                    }
                    if (int.tryParse(value) == null ||
                        int.parse(value) <= 0 ||
                        int.parse(value) > 10) {
                      return 'Número inválido';
                    }
                    return null;
                  },
                ),
              ] else ...[
                TextFormField(
                  controller: _direccionController,
                  decoration: const InputDecoration(
                    labelText: 'Dirección de entrega',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black54),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa una dirección válida';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14532D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text(
                    'Confirmar pedido',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
