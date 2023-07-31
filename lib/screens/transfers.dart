import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:qunot_driver/api/actions.dart';
import 'package:qunot_driver/colorscheme.dart';

class TransferPage extends StatefulWidget {
  final String phoneNumber;
  final String authToken;
  const TransferPage(
      {Key? key, required this.phoneNumber, required this.authToken})
      : super(key: key);

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
      _showTransferConfirmationDialog();
    });
  }

  void _showTransferConfirmationDialog() {
    final transferAmount = _cashTransferController.text.trim();
    final recipientDriver = _driverRecipientController.text.trim();

    if (transferAmount.isEmpty || recipientDriver.isEmpty) {
      // Don't show the dialog if the fields are empty
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Transfer Confirmation'),
          content: const Text('Are you sure you want to transfer funds?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performTransfer();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                backgroundColor: Colors.orangeAccent,
              ),
              child: const Text(
                'Yes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                backgroundColor: customPurple,
              ),
              child: const Text(
                'No',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performTransfer() async {
    final response = await transfer(
      ("+${_removeComma(_cashTransferController.text)}"),
      _driverRecipientController.text,
      widget.phoneNumber,
      widget.authToken,
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

  //TODO: CHECK THE USE OF THIS
  // String _formatNumber(int number) {
  //   final formatter = NumberFormat("#,###,###,###");
  //   return formatter.format(number);
  // }

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
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
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
