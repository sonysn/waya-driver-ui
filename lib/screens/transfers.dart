import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waya_driver/api/actions.dart';
import 'package:waya_driver/api/payments.dart';
import 'package:waya_driver/screens/paystack_deposit_webview.dart';

class TransferPage extends StatefulWidget {
  final dynamic phoneNumber;
  const TransferPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final TextEditingController _cashTransferController = TextEditingController();
  final TextEditingController _driverRecipentController = TextEditingController();

  void _transfer() async {
    final response = await transfer(("+${_removeComma(_cashTransferController.text)}"), _driverRecipentController.text, widget.phoneNumber);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response),
        duration: const Duration(seconds: 2),
      ),
    );
  }


  @override
  void dispose() {
    _cashTransferController.dispose();
    _driverRecipentController.dispose();
    super.dispose();
  }


  void _deleteLastCharacter() {
    final text = _cashTransferController.text;
    if (text.isNotEmpty) {
      final newText = text.substring(0, text.length - 1);
      _cashTransferController.text = newText;
      _cashTransferController.selection = TextSelection.fromPosition(TextPosition(offset: newText.length));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(top: 30),
          margin: const EdgeInsets.symmetric(horizontal: 7),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300.0,
                    child: TextField(
                      controller: _driverRecipentController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Enter Driver Phone',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: 300.0,
                    child: TextField(
                      controller: _cashTransferController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Enter cash transfer amount',
                      ),
                      enabled: false,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNumberButton('1'),
                      const SizedBox(width: 10),
                      _buildNumberButton('2'),
                      const SizedBox(width: 10),
                      _buildNumberButton('3')
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNumberButton('4'),
                      const SizedBox(width: 10),
                      _buildNumberButton('5'),
                      const SizedBox(width: 10),
                      _buildNumberButton('6'),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNumberButton('7'),
                      const SizedBox(width: 10),
                      _buildNumberButton('8'),
                      const SizedBox(width: 10),
                      _buildNumberButton('9'),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNumberButton('00'),
                      const SizedBox(width: 10),
                      _buildNumberButton('0'),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _deleteLastCharacter,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(60.0)),
                          ),
                        ),
                        child: const Icon(Icons.backspace),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      //String cashDeposit = _cashDepositController.text;
                      //_handleDeposit();
                      _transfer();
                      //print(_removeComma(_cashDepositController.text) + '00');
                      // handle cash deposit button press with the cashDeposit amount
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      textStyle: const TextStyle(fontSize: 20.0),
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    ),
                    child: const Text('Cash Deposit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberButton(String label) {
    return ElevatedButton(
      onPressed: () {
        final text = _cashTransferController.text;
        final newText = _formatNumber(_tryParseInt(_removeComma(text + label)));
        _cashTransferController.text = newText;
        _cashTransferController.selection =
            TextSelection.fromPosition(TextPosition(offset: newText.length));
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(60.0)),
        ),
      ),
      child: Text(label),
    );
  }

  String _formatNumber(int number) {
    final formatter = NumberFormat("#,###,###,###");
    return formatter.format(number);
  }

  String _removeComma(String text) {
    return text.replaceAll(',', '');
  }

  int _tryParseInt(String value) {
    try {
      final intValue = int.parse(value);
      if (intValue > 1000000000) {
        throw Exception('Value exceeds maximum limit');
      }
      return intValue;
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }
}
