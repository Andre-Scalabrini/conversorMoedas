import 'package:flutter/material.dart';

void main() {
  runApp(MeuApp());
}

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversor de Moedas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ConversorMoeda(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ConversorMoeda extends StatefulWidget {
  @override
  _ConversorMoedaState createState() => _ConversorMoedaState();
}

class _ConversorMoedaState extends State<ConversorMoeda> {
  final TextEditingController _controladorValor = TextEditingController();
  final TextEditingController _controladorTaxa = TextEditingController();
  double _valorConvertido = 0.0;

  void _converterMoeda() {
    double valorEntrada = double.tryParse(_controladorValor.text) ?? 0.0;
    double taxaConversao = double.tryParse(_controladorTaxa.text) ?? 1.0;
    setState(() {
      _valorConvertido = valorEntrada * taxaConversao;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversor de Moedas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controladorValor,
              decoration: InputDecoration(
                labelText: 'Valor em USD',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (text) {
                _converterMoeda();
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _controladorTaxa,
              decoration: InputDecoration(
                labelText: 'Taxa de Conversão',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (text) {
                _converterMoeda();
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Valor em BRL: $_valorConvertido',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
