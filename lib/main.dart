import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuel Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FuelTrackerScreen(),
    );
  }
}


class FuelTrackerScreen extends StatefulWidget {
  const FuelTrackerScreen({super.key});

  @override
  _FuelTrackerScreenState createState() => _FuelTrackerScreenState();
}

class _FuelTrackerScreenState extends State<FuelTrackerScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _odometerController = TextEditingController();
  final TextEditingController _fuelController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  double? lastOdometer;
  double? averageConsumption;

  void _calculateConsumption() {
    if (_formKey.currentState!.validate()) {
      double odometer = double.parse(_odometerController.text);
      double fuel = double.parse(_fuelController.text);

      if (lastOdometer != null) {
        double distance = odometer - lastOdometer!;
        if (distance > 0) {
          setState(() {
            averageConsumption = (fuel / distance) * 100;
          });
        }
      }
      lastOdometer = odometer;
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fuel Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _odometerController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stav tachometru (km)'),
                validator: (value) => value!.isEmpty ? 'Zadejte hodnotu' : null,
              ),
              TextFormField(
                controller: _fuelController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Množství paliva (litry)'),
                validator: (value) => value!.isEmpty ? 'Zadejte hodnotu' : null,
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cena za litr (Kč)'),
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Poznámky'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateConsumption,
                child: const Text('Spočítat spotřebu'),
              ),
              if (averageConsumption != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    'Průměrná spotřeba: ${averageConsumption!.toStringAsFixed(2)} l/100km',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
