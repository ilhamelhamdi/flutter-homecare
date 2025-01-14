import 'package:flutter/material.dart';
import 'package:m2health/const.dart';
import 'package:m2health/main.dart';
import 'package:m2health/views/appointment.dart';
import 'package:go_router/go_router.dart';
// import 'package:navbar_router/navbar_router.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

// void navbarVisibility(bool status) {
//   NavbarNotifier.hideBottomNavBar = status;
//   if (status == true) {
//     NavbarNotifier.hideBottomNavBar = false;
//     if (NavbarNotifier.isNavbarHidden) {
//       NavbarNotifier.hideBottomNavBar = false;
//     }
//   } else {
//     NavbarNotifier.hideBottomNavBar = true;
//     if (NavbarNotifier.isNavbarHidden) {
//       NavbarNotifier.hideBottomNavBar = true;
//     }
//   }
// }

class _PaymentPageState extends State<PaymentPage> {
  String selectedPaymentMethod = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/images_olla.png', // Replace with your actual image path
                          width: 50,
                          height: 50,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Angela Xianxian',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text('Staff Nurse'),
                        Row(
                          children: [
                            Icon(Icons.star_half, color: Colors.yellow),
                            SizedBox(width: 4),
                            Text('4.8 (153 reviews)'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Charge',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Inject'),
                Text('\$250'),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Blood Glucose Check'),
                Text('\$65'),
              ],
            ),
            const Divider(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '\$315',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            _buildPaymentMethodCard('Visa', '**** **** **** 1234', '12/26',
                'assets/icons/ic_visa.png'),
            _buildPaymentMethodCard('MasterCard', '**** **** **** 5678',
                '11/25', 'assets/icons/mastercard.png'),
            _buildPaymentMethodCard('Alipay', '**** **** **** 9012', '10/24',
                'assets/icons/ic_alipay.png'),
            _buildPaymentMethodCard('PayNow', '**** **** **** 9012', '10/24',
                'assets/icons/ic_paynow.jpg'),
            _buildPaymentMethodCard(
                'Cash', ' ', '12/26', 'assets/icons/cash.png'),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return PaymentSuccessDialog();
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Const.tosca, // Set the button color to Const.tosca
          ),
          child: const Text(
            'Confirm',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(
      String method, String accountNumber, String expiryDate, String iconPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
        });
      },
      child: Card(
        color: selectedPaymentMethod == method ? Colors.blue[50] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.asset(iconPath, width: 40, height: 40),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (accountNumber.isNotEmpty) ...[
                    Text(accountNumber),
                    Text('Expired: $expiryDate'),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentSuccessDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      contentPadding: const EdgeInsets.all(16.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/icons/ic_checklist.png', // Replace with your actual image path
            width: 142,
            height: 142,
          ),
          const SizedBox(height: 16),
          const Text(
            'Payment Success',
            style: TextStyle(
              color: Const.tosca,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Your money has been successfully sent to Angela Xianxian.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Amount'),
              Text(
                '\$220',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34),
              ),
            ],
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
            height: 32,
          ),
          const Text(
            'How is your experience?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your feedback will help us to improve your\nexperience better',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return FeedbackForm();
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Const.tosca, // Set the button color to Const.tosca
              minimumSize:
                  const Size(150, 50), // Customize the width and height
            ),
            child: const Text(
              'Please Feedback',
              style:
                  TextStyle(color: Colors.white), // Set the text color to white
            ),
          ),
        ],
      ),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  int selectedStar = 5;
  String selectedTip = '';
  bool showOtherAmountField = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: index < selectedStar ? Colors.yellow : Colors.grey,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedStar = index + 1;
                      });
                    },
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Excellent',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'You rated Angela $selectedStar stars',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Write your text',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            const Text(
              'Give some tips to Angela Xianxian',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTipCard('\$1'),
                _buildTipCard('\$2'),
                _buildTipCard('\$5'),
                _buildTipCard('\$10'),
                _buildTipCard('\$20'),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                setState(() {
                  showOtherAmountField = true;
                });
              },
              child: const Text(
                'Enter other amount',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (showOtherAmountField) ...[
              const SizedBox(height: 8),
              const TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: 353, // Set the width to 353
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FeedbackDetails()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Const.tosca, // Set the button color to Const.tosca
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(String amount) {
    bool isSelected = selectedTip == amount;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTip = amount;
        });
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? Const.tosca : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Const.tosca : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class FeedbackDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Feedback'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/ic_checklist.png', // Replace with your actual image path
              width: 142,
              height: 142,
            ),
            const SizedBox(height: 20),
            const Text(
              'Thank you for your feedback',
              style: TextStyle(color: Const.tosca, fontSize: 20),
            ),
            const SizedBox(height: 10),
            const Text(
              'This appointment has been completed and can be viewed in the completed orders menu',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    // navbarVisibility(true); // Tampilkan navbar sebelum navigasi
                    context.go('/dasboard');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Const.tosca, // Set the button color to Const.tosca
                  ),
                  child: const Text(
                    'View Detail',
                    style: TextStyle(
                        color: Colors.white), // Set the text color to white
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
