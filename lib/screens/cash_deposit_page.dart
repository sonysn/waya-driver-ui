import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CashDepositPage extends StatefulWidget {
  const CashDepositPage({Key? key}) : super(key: key);

  @override
  _CashDepositPageState createState() => _CashDepositPageState();
}

class _CashDepositPageState extends State<CashDepositPage> {
  final TextEditingController _cashDepositController = TextEditingController();

  @override
  void dispose() {
    _cashDepositController.dispose();
    super.dispose();
  }

  void _deleteLastCharacter() {
    final text = _cashDepositController.text;
    if (text.isNotEmpty) {
      final newText = text.substring(0, text.length - 1);
      _cashDepositController.text = newText;
      _cashDepositController.selection = TextSelection.fromPosition(TextPosition(offset: newText.length));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16.0),
            SizedBox(
              width: 300.0,
              child: TextField(
                controller: _cashDepositController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Enter cash deposit amount',
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
                  child: const Icon(Icons.backspace),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shape: const CircleBorder(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String cashDeposit = _cashDepositController.text;
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
      ),
    );
  }

  Widget _buildNumberButton(String label) {
    return ElevatedButton(
      onPressed: () {
        final text = _cashDepositController.text;
        final newText = _formatNumber(_tryParseInt(_removeComma(text + label)));
        _cashDepositController.text = newText;
        _cashDepositController.selection =
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
