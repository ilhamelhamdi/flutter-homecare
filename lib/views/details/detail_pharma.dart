import 'package:flutter/material.dart';
import '../search/search_pharmacist.dart';
import 'package:m2health/widgets/image_preview.dart';
import 'dart:io';

class DetailPersonalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Personal Case Detail',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 0.0),
            const Column(
              children: [
                Center(
                  child: Text(
                    'Tell Us Your Concern',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF35C5CF),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    'There are no issues added yet.\n Please add one or more issues so\nyou can proceed to the next step.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 352,
                  height: 58,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddConcernPage(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF35C5CF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Add an Issue',
                      style: TextStyle(color: Color(0xFF35C5CF), fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 352,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle next button press
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB2B9C4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
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
  TextEditingController _issueTitleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  List<File> _images = [];

  void _addImage(File image) {
    setState(() {
      _images.add(image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add an Issue',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tell us your concern',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 338,
              height: 50,
              child: TextField(
                controller: _issueTitleController,
                decoration: InputDecoration(
                  hintText: 'Issue Title',
                  hintStyle:
                      const TextStyle(color: Color(0xFFD0D0D0), fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              width: 338,
              height: 129,
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText:
                      'Please enter questions, concerns, relevant symptoms related to your case along with related keywords.',
                  hintStyle:
                      const TextStyle(color: Color(0xFFD0D0D0), fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10), // Adjust the vertical padding as needed
                ),
                maxLines: null,
                expands: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  ImagePreview(onImageSelected: _addImage),
                  const SizedBox(height: 30),
                  ImagePreview(onImageSelected: _addImage),
                  const SizedBox(height: 30),
                  ImagePreview(onImageSelected: _addImage),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 352,
              height: 58,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddSummaryPage(
                        issueTitle: _issueTitleController.text,
                        description: _descriptionController.text,
                        images: _images,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF35C5CF),
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddSummaryPage extends StatelessWidget {
  final String issueTitle;
  final String description;
  final List<File> images;

  AddSummaryPage({
    required this.issueTitle,
    required this.description,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Summary',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tell us your concern',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Issue Title: $issueTitle',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            Text(
              'Description: $description',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            Row(
              children: images.map((image) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey.shade200,
                    child: Image.file(image, fit: BoxFit.cover),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 352,
                  height: 58,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddConcernPage(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF35C5CF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Add an Issue',
                      style: TextStyle(color: Color(0xFF35C5CF), fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 352,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle next action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF35C5CF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
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
        title: const Text(
          'Personal Case Detail',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select your mobility status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  activeColor: const Color(0xFF35C5CF),
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
                  activeColor: const Color(0xFF35C5CF),
                ),
                RadioListTile<String>(
                  title: const Text('Walking Aid'),
                  value: 'Walking Aid',
                  groupValue: _mobilityStatus,
                  onChanged: (value) {
                    setState(() {
                      _mobilityStatus = value!;
                    });
                  },
                  activeColor: const Color(0xFF35C5CF),
                ),
                RadioListTile<String>(
                  title: const Text('Mobile Without Aid'),
                  value: 'Mobile Without Aid',
                  groupValue: _mobilityStatus,
                  onChanged: (value) {
                    setState(() {
                      _mobilityStatus = value!;
                    });
                  },
                  activeColor: const Color(0xFF35C5CF),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Select a related health record',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            Container(
              width: 362,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
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
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  dropdownColor: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 352,
              height: 58,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPharma(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF35C5CF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
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

  List<String> serviceTitles = [
    'Analyze patient physiological data,\ninitial drug treatment plan, and patient treatment response',
    'Analyze specific treatment problems:\npoor response to treatment;poor\npatient medication compliance;\ndrug side effect; drug interactions',
    'Drug therapy adjustment made to\nphysicians by the pharmacist when\napropriate',
    'Diet History & Evaluations',
    'Follow-up the therapy and ensure\npositive outcomes and reduces adverse effects',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacist Services',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            for (int i = 0; i < serviceTitles.length; i++)
              Card(
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedServices[i] = !_selectedServices[i];
                      });
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _selectedServices[i]
                            ? const Color(0xFF35C5CF)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: const Color(0xFF35C5CF)),
                      ),
                      child: _selectedServices[i]
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 16)
                          : null,
                    ),
                  ),
                  title: Text(
                    serviceTitles[i],
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold), // Set the font size
                    overflow:
                        TextOverflow.visible, // Ensure the text is fully shown
                  ),
                  trailing: const Icon(Icons.info_outline_rounded,
                      color: Colors.grey),
                ),
              ),
            const Spacer(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Estimated Budget',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.info_outline_rounded, color: Colors.grey),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '\$145',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(width: 5),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 352,
              height: 58,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPharmacistPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF35C5CF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Book Appointment',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
