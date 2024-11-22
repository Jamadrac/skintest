import 'package:flutter/material.dart';
import 'package:skintest/models/screens/personal_info_page.dart';

class Form3Screen extends StatefulWidget {
  const Form3Screen({super.key});

  @override
  State<Form3Screen> createState() => _Form3ScreenState();
}

class _Form3ScreenState extends State<Form3Screen> {
  String? selectedLocation;
  String? selectedDuration;
  Map<String, bool> changeOverTime = {
    'size': false,
    'colour': false,
    'shape': false,
    'similar_before': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Body Location Section
            const Text(
              'Body Location',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: [
                'Arm',
                'Face',
                'Leg',
                'Other part',
              ]
                  .map((location) => ChoiceChip(
                        label: Text(location),
                        selected: selectedLocation == location,
                        onSelected: (selected) {
                          setState(() {
                            selectedLocation = selected ? location : null;
                          });
                        },
                      ))
                  .toList(),
            ),

            const SizedBox(height: 24),

            // Duration Section
            const Text(
              'Duration',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: [
                'Days',
                'Weeks',
                'Month',
                'Year',
              ]
                  .map((duration) => ChoiceChip(
                        label: Text(duration),
                        selected: selectedDuration == duration,
                        onSelected: (selected) {
                          setState(() {
                            selectedDuration = selected ? duration : null;
                          });
                        },
                      ))
                  .toList(),
            ),

            const SizedBox(height: 24),

            // Change Over Time Section
            const Text(
              'Change Over Time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...changeOverTime.entries
                .map((entry) => CheckboxListTile(
                      title: Text(entry.key.replaceAll('_', ' ').capitalize()),
                      value: entry.value,
                      onChanged: (bool? value) {
                        setState(() {
                          changeOverTime[entry.key] = value ?? false;
                        });
                      },
                    ))
                .toList(),

            const SizedBox(height: 24),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to next screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PersonalInfoPage(),
                    ),
                  );
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension to capitalize strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
