import 'package:flutter/material.dart';


class CashWithdrawalPage extends StatelessWidget {
  final int id;
  final dynamic phone;
  final String email;

  const CashWithdrawalPage({Key? key, required this.id, required this.phone, required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Cash Withdrawal',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              const Text(
                'Withdrawal Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                style: const TextStyle(
                  color: Colors.black, // Set text color to black
                ),
                cursorColor: Colors.black, // Set cursor color to black
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: const TextStyle(
                    color: Colors.black, // Set label color to black
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black, // Set border color to black when focused
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black, // Set border color to black
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                style: const TextStyle(
                  color: Colors.black, // Set text color to black
                ),
                cursorColor: Colors.black, // Set cursor color to black
                decoration: InputDecoration(
                  labelText: 'Bank Name',
                  labelStyle: const TextStyle(
                    color: Colors.black, // Set label color to black
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black, // Set border color to black when focused
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black, // Set border color to black
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                style: const TextStyle(
                  color: Colors.black, // Set text color to black
                ),
                cursorColor: Colors.black, // Set cursor color to black
                decoration: InputDecoration(
                  labelText: 'Account Number',
                  labelStyle: const TextStyle(
                    color: Colors.black, // Set label color to black
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black, // Set border color to black when focused
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black, // Set border color to black
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                style: const TextStyle(
                  color: Colors.black, // Set text color to black
                ),
                cursorColor: Colors.black, // Set cursor color to black
                decoration: InputDecoration(
                  labelText: 'Account Holder Name',
                  labelStyle: const TextStyle(
                    color: Colors.black, // Set label color to black
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black, // Set border color to black when focused
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black, // Set border color to black
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Perform withdrawal logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Use the desired color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                    child: Text(
                      'Withdraw',
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
