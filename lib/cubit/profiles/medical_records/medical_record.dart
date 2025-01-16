import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

class MedicalRecordsPage extends StatefulWidget {
  @override
  _MedicalRecordsPageState createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage> {
  List<String> records = [
    'Arboviral Encephalitis',
    'Dengue Fever',
    'Malaria',
    'Tuberculosis',
    'Hepatitis B',
    'Influenza',
    'COVID-19'
  ];

  int? _editingIndex;
  bool _isAddingNewRecord = false;
  final TextEditingController _diseaseNameController = TextEditingController();
  final TextEditingController _diseaseHistoryController =
      TextEditingController();
  List<bool> _specialConsiderations = List.generate(6, (_) => false);

  void _modifyRecord(int index) {
    setState(() {
      _editingIndex = index;
      _diseaseNameController.text = records[index];
      _diseaseHistoryController.clear();
      _specialConsiderations = List.generate(6, (_) => false);
    });
  }

  void _removeRecord(int index) {
    setState(() {
      records.removeAt(index);
      if (_editingIndex == index) {
        _editingIndex = null;
      }
    });
  }

  void _submitModification() {
    setState(() {
      if (_editingIndex != null) {
        records[_editingIndex!] = _diseaseNameController.text;
        _editingIndex = null;
      } else {
        records.add(_diseaseNameController.text);
      }
      _diseaseNameController.clear();
      _diseaseHistoryController.clear();
      _specialConsiderations = List.generate(6, (_) => false);
    });
  }

  void _addNewRecord() {
    setState(() {
      records.add(_diseaseNameController.text);
      _diseaseNameController.clear();
      _diseaseHistoryController.clear();
      _specialConsiderations = List.generate(6, (_) => false);
      _isAddingNewRecord = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Medical Records',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: records.length + (_isAddingNewRecord ? 1 : 0),
        itemBuilder: (context, index) {
          if (_isAddingNewRecord && index == records.length) {
            return _buildForm();
          }
          int recordIndex = index;
          return Card(
            elevation: 4,
            shadowColor: Colors.black,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(records[recordIndex]),
              subtitle: const Text('Last updated: 08-09-2024'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MedicalRecordDetailPage(
                      title: records[recordIndex],
                      diseaseName: records[recordIndex],
                      diseaseHistory:
                          'Sample disease history for ${records[recordIndex]}',
                      symptoms: const [
                        'Symptom 1',
                        'Symptom 2',
                        'Symptom 3',
                        'Symptom 4',
                      ],
                    ),
                  ),
                );
              },
              trailing: PopupMenuButton<String>(
                onSelected: (String value) {
                  if (value == 'Modify') {
                    _modifyRecord(recordIndex);
                  } else if (value == 'Remove') {
                    _removeRecord(recordIndex);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Modify', 'Remove'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isAddingNewRecord = true;
          });
        },
        backgroundColor: Const.tosca,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: _isAddingNewRecord
          ? BottomAppBar(
              child: ElevatedButton(
                onPressed: _addNewRecord,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Const.tosca, // Warna tosca
                ),
                child:
                    const Text('Submit', style: TextStyle(color: Colors.white)),
              ),
            )
          : null,
    );
  }

  Widget _buildForm() {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Patient Information',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),
            TextField(
              controller: _diseaseNameController,
              decoration: const InputDecoration(labelText: 'Disease Name'),
            ),
            const SizedBox(height: 8),
            const Text('Disease History Description'),
            TextField(
              controller: _diseaseHistoryController,
              maxLines: 4,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            const Text('Patient with Special Consideration'),
            Wrap(
              spacing: 8.0,
              children: List.generate(6, (index) {
                return FilterChip(
                  label: Text('Consideration ${index + 1}'),
                  selected: _specialConsiderations[index],
                  onSelected: (bool selected) {
                    setState(() {
                      _specialConsiderations[index] = selected;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Treatment Information'),
                ElevatedButton(
                  onPressed: () {
                    // Handle add treatment information
                  },
                  child: const Text('+ Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MedicalRecordDetailPage extends StatelessWidget {
  final String title;
  final String diseaseName;
  final String diseaseHistory;
  final List<String> symptoms;

  const MedicalRecordDetailPage({
    Key? key,
    required this.title,
    required this.diseaseName,
    required this.diseaseHistory,
    required this.symptoms,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Patient Current Status',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Disease name: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Expanded(
                    child: Text(
                      diseaseName,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Disease history: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Expanded(
                    child: Text(
                      diseaseHistory,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'My Symptoms of $diseaseName include:',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              ...symptoms.map((symptom) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(fontSize: 16),
                        ),
                        Expanded(
                          child: Text(
                            symptom,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 20),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Patient With\nSpecial\nConsideration: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Expanded(
                    child: Text(
                      'Kidney Disease',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Treatment Information',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              ..._buildTreatmentList(context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTreatmentList(BuildContext context) {
    final treatments = [
      'Lenvatinib (Lenvima)',
      'Sorafenib (Nexavar)',
      'Sunitinib (Sutent)',
      'Pazopanib (Votrient)',
      'Cabozantinib (Cabometyx)',
    ];

    return treatments.map((treatment) {
      return GestureDetector(
        onTap: () {
          _showTreatmentDetail(context, treatment);
        },
        child: Container(
          width: 355,
          height: 65,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            treatment,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }).toList();
  }

  void _showTreatmentDetail(BuildContext context, String treatment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TreatmentDetailPage(treatmentName: treatment),
      ),
    );
  }
}

class TreatmentDetailPage extends StatelessWidget {
  final String treatmentName;

  const TreatmentDetailPage({Key? key, required this.treatmentName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          treatmentName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Treatment Information',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              _buildInfoRow('Therapeutic Drugs:', 'Lenvatinib (Lenvima)'),
              _buildInfoRow('Dosage:', '24 mg'),
              _buildInfoRow('Frequency:', 'Once daily'),
              _buildInfoRow('Treatment Start:', '01-01-2022'),
              _buildInfoRow('Treatment End:', '01-01-2023'),
              _buildInfoRow('Disease Status before treatment:', 'Stable'),
              _buildInfoRow('Current disease status:', 'Improving'),
              const SizedBox(height: 20),
              const Text(
                'Description of treatment efficacy:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                'The treatment has shown significant improvement in reducing tumor size and alleviating symptoms.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Description of side effect:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                'Mild nausea and fatigue observed during the first few weeks of treatment.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Problem to be addressed:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                'Monitor for potential liver toxicity and adjust dosage if necessary.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
