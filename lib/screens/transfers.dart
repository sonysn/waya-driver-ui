import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:waya_driver/api/actions.dart';
import 'package:waya_driver/api/payments.dart';
import 'package:waya_driver/screens/paystack_deposit_webview.dart';
import '../colorscheme.dart';

class TransferPage extends StatefulWidget {
  final dynamic phoneNumber;

  const TransferPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final TextEditingController _cashTransferController = TextEditingController();
  final TextEditingController _driverRecipientController =
  TextEditingController();
  Timer? _debounceTimer; // Timer for debounce delay

  void _transfer() {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel(); // Cancel the previous timer
    }

    // Start a new timer to prevent multiple triggers within 2 seconds
    _debounceTimer = Timer(const Duration(seconds: 3), () {
      _performTransfer();
    });
  }

  void _performTransfer() async {
    final response = await transfer(
      ("+${_removeComma(_cashTransferController.text)}"),
      _driverRecipientController.text,
      widget.phoneNumber,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel(); // Cancel the timer when the widget is disposed
    _cashTransferController.dispose();
    _driverRecipientController.dispose();
    super.dispose();
  }

  String _formatNumber(int number) {
    final formatter = NumberFormat("#,###,###,###");
    return formatter.format(number);
  }

  String _removeComma(String text) {
    return text.replaceAll(',', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Transfer to Driver',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              const Text(
                'Transfer Amount',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _cashTransferController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter transfer amount',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Recipient Driver',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _driverRecipientController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter recipient driver phone number',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: _transfer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 32.0),
                    child: Text(
                      'Transfer Funds',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
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
