import 'package:flutter/material.dart';
import '/views/search/search_pharma.dart';

class DetailPersonalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Case Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'There are no issues added yet. Please add one or more issues so you can proceed to the next step.',
              style: TextStyle(fontSize: 16),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddConcernPage(),
                      ),
                    );
                  },
                  child: Text('Add an Issue'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Next'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AddConcernPage extends StatefulWidget {
  @override
  _AddConcernPageState createState() => _AddConcernPageState();
}

class _AddConcernPageState extends State<AddConcernPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add an Issue'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tell us your concern',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Issue Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Please Enter Question',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Image less than 100MB',
              style: TextStyle(fontSize: 12),
            ),
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey.shade200,
                  child: Center(
                    child: Text('Preview'),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose File',
                      style: TextStyle(fontSize: 12),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Add your choose file logic here
                      },
                      child: Text('Choose File'),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddSummaryPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF35C5CF),
              ),
              child: Center(
                child: Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddSummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tell us your concern',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Issue Title: [Your Issue Title]',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Text(
              'Description: [Your Question]',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey.shade200,
                  child: Center(
                    child: Text('Image 1'),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey.shade200,
                  child: Center(
                    child: Text('Image 2'),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey.shade200,
                  child: Center(
                    child: Text('Image 3'),
                  ),
                ),
              ],
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddConcernPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    // primary: Colors.transparent,
                    // onPrimary: Color(0xFF35C5CF),
                    shadowColor: Colors.transparent,
                  ),
                  child: Text('Add an Issue'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddIssuePage()),
                    );
                    // Add your next step logic here
                  },
                  style: ElevatedButton.styleFrom(
                      // primary: Color(0xFF35C5CF),
                      ),
                  child: Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddIssuePage extends StatefulWidget {
  @override
  _AddIssuePageState createState() => _AddIssuePageState();
}

class _AddIssuePageState extends State<AddIssuePage> {
  String _mobilityStatus = 'bedbound';
  String _selectedStatus = 'Select Status';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Case Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your mobility status',
              style: TextStyle(fontSize: 16),
            ),
            Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Bedbound'),
                  value: 'bedbound',
                  groupValue: _mobilityStatus,
                  onChanged: (value) {
                    setState(() {
                      _mobilityStatus = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Wheelchair bound'),
                  value: 'wheelchair bound',
                  groupValue: _mobilityStatus,
                  onChanged: (value) {
                    setState(() {
                      _mobilityStatus = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Ambulatory'),
                  value: 'ambulatory',
                  groupValue: _mobilityStatus,
                  onChanged: (value) {
                    setState(() {
                      _mobilityStatus = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Independent'),
                  value: 'independent',
                  groupValue: _mobilityStatus,
                  onChanged: (value) {
                    setState(() {
                      _mobilityStatus = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Select a related health record',
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<String>(
              value: _selectedStatus,
              items: <String>[
                'Select Status',
                'Status 1',
                'Status 2',
                'Status 3'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedStatus = newValue!;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Add your add logic here
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPharma()),
                );
                // Add your next step logic here
              },
              style: ElevatedButton.styleFrom(
                  // primary: Color(0xFF35C5CF),
                  ),
              child: Center(
                child: Text('Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentPharma extends StatefulWidget {
  @override
  _PaymentPharmaState createState() => _PaymentPharmaState();
}

class _PaymentPharmaState extends State<PaymentPharma> {
  List<bool> _selectedServices = List<bool>.generate(5, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pharmacist Services'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            for (int i = 0; i < 5; i++)
              Card(
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedServices[i] = !_selectedServices[i];
                      });
                    },
                    child: Icon(
                      _selectedServices[i]
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: _selectedServices[i] ? Colors.green : Colors.grey,
                    ),
                  ),
                  title: Text('Service ${i + 1}'),
                  trailing: Icon(Icons.info, color: Colors.blue),
                ),
              ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Estimated Budget',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      '\$145',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.attach_money, color: Colors.green),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchPharmacistPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                  // primary: Color(0xFF35C5CF),
                  ),
              child: Center(
                child: Text('Book Appointment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
