import 'package:flutter/material.dart';

class EditStatusScreen extends StatefulWidget {
  final String currentStatus;
  final Function(String)? onStatusChanged;

  const EditStatusScreen({
    super.key,
    required this.currentStatus,
    this.onStatusChanged,
  });

  @override
  State<EditStatusScreen> createState() => _EditStatusScreenState();
}

class _EditStatusScreenState extends State<EditStatusScreen> {
  late String _selectedStatus;
  final List<String> _statusOptions = [
    'Actively searching conferences',
    'Open to conference opportunities',
    'Not currently searching',
    'Only interested in specific conferences',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Conference Search Status'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveChanges),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Status:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _selectedStatus,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select New Status:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _statusOptions.length,
                itemBuilder: (context, index) {
                  final status = _statusOptions[index];
                  return RadioListTile<String>(
                    title: Text(status),
                    value: status,
                    groupValue: _selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _saveChanges,
                child: const Text('SAVE CHANGES'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    if (widget.onStatusChanged != null) {
      widget.onStatusChanged!(_selectedStatus);
    }
    Navigator.pop(context, _selectedStatus);
  }
}
