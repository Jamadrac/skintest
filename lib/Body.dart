import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String? selectedSkinType;
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController ethnicityController = TextEditingController();

  @override
  void dispose() {
    ageController.dispose();
    genderController.dispose();
    ethnicityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demographics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Age Field
            TextField(
              controller: ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 16),

            // Gender Field
            TextField(
              controller: genderController,
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // Skin Type Section
            const Text(
              'Skin Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: [
                'Fair',
                'Medium',
                'Dark',
              ]
                  .map((type) => ChoiceChip(
                        label: Text(type),
                        selected: selectedSkinType == type,
                        onSelected: (selected) {
                          setState(() {
                            selectedSkinType = selected ? type : null;
                          });
                        },
                      ))
                  .toList(),
            ),

            const SizedBox(height: 16),

            // Ethnicity Field
            TextField(
              controller: ethnicityController,
              decoration: const InputDecoration(
                labelText: 'Ethnicity',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle form submission
                  // You can add validation and data processing here
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
