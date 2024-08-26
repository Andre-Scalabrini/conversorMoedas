import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(AplicativoConversor());
}

class AplicativoConversor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversor de Moedas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ConversorMoedas(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ConversorMoedas extends StatefulWidget {
  @override
  _EstadoConversorMoedas createState() => _EstadoConversorMoedas();
}

class _EstadoConversorMoedas extends State<ConversorMoedas> {
  final TextEditingController _controladorValor =
      TextEditingController(text: '1');
  double _taxaUSD = 0.0;
  double _taxaEUR = 0.0;
  double _taxaGBP = 0.0;
  double _taxaJPY = 0.0;
  double _valorConvertidoUSD = 0.0;
  double _valorConvertidoEUR = 0.0;
  double _valorConvertidoGBP = 0.0;
  double _valorConvertidoJPY = 0.0;
  bool _carregando = false;
  String _mensagemErro = '';

  @override
  void initState() {
    super.initState();
    _buscarTaxasConversao();
  }

  Future<void> _buscarTaxasConversao() async {
    setState(() {
      _carregando = true;
      _mensagemErro = '';
    });

    try {
      final resposta = await http
          .get(Uri.parse('https://api.exchangerate-api.com/v4/latest/BRL'));
      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);
        setState(() {
          _taxaUSD = dados['rates']['USD'];
          _taxaEUR = dados['rates']['EUR'];
          _taxaGBP = dados['rates']['GBP'];
          _taxaJPY = dados['rates']['JPY'];
          _carregando = false;
        });
        _converterMoedas();
      } else {
        setState(() {
          _mensagemErro = 'Falha ao carregar taxas de câmbio';
          _carregando = false;
        });
      }
    } catch (e) {
      setState(() {
        _mensagemErro = 'Erro ao conectar com o servidor';
        _carregando = false;
      });
    }
  }

  void _converterMoedas() {
    String valorTexto = _controladorValor.text;

    valorTexto = valorTexto.replaceAll(',', '.');

    double valorEntrada = double.tryParse(valorTexto) ?? 0.0;

    setState(() {
      _valorConvertidoUSD = valorEntrada * _taxaUSD;
      _valorConvertidoEUR = valorEntrada * _taxaEUR;
      _valorConvertidoGBP = valorEntrada * _taxaGBP;
      _valorConvertidoJPY = valorEntrada * _taxaJPY;
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
                labelText: 'Valor em BRL',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (text) {
                _converterMoedas();
              },
            ),
            SizedBox(height: 16.0),
            if (_carregando)
              CircularProgressIndicator()
            else if (_mensagemErro.isNotEmpty)
              Text(
                _mensagemErro,
                style: TextStyle(color: Colors.red),
              )
            else ...[
              Text(
                'Valor em USD: $_valorConvertidoUSD',
                style: TextStyle(fontSize: 20.0),
              ),
              Text(
                'Valor em EUR: $_valorConvertidoEUR',
                style: TextStyle(fontSize: 20.0),
              ),
              Text(
                'Valor em GBP: $_valorConvertidoGBP',
                style: TextStyle(fontSize: 20.0),
              ),
              Text(
                'Valor em JPY: $_valorConvertidoJPY',
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
