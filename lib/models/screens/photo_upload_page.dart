import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:io';

class PhotoUploadPage extends StatefulWidget {
  const PhotoUploadPage({super.key});

  @override
  State<PhotoUploadPage> createState() => _PhotoUploadPageState();
}

class _PhotoUploadPageState extends State<PhotoUploadPage> {
  final List<File?> _images = List.generate(3, (_) => null);
  final List<String> _imageAnalyses = List.generate(3, (_) => '');
  final ImagePicker _picker = ImagePicker();

  // Initialize Gemini AI model
  final model = GenerativeModel(
    model: 'gemini-pro-vision',
    apiKey: 'YOUR_API_KEY', // Replace with your API key
  );

  Future<void> _analyzeImage(int index) async {
    if (_images[index] == null) return;

    try {
      setState(() {
        _imageAnalyses[index] = 'Analyzing...';
      });

      final bytes = await _images[index]!.readAsBytes();
      final prompt =
          TextPart('Please analyze this image and describe what you see.');
      final imagePart = BytesPart(bytes);

      final response = await model.generateContent([prompt, imagePart]);

      setState(() {
        _imageAnalyses[index] = response.text ?? 'No analysis available';
      });
    } catch (e) {
      setState(() {
        _imageAnalyses[index] = 'Analysis failed';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to analyze image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showImageSourceDialog(int index) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _getImage(ImageSource.camera, index);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _getImage(ImageSource.gallery, index);
                  },
                ),
                if (_images[index] != null) ...[
                  ListTile(
                    leading: const Icon(Icons.analytics),
                    title: const Text('Analyze Photo'),
                    onTap: () {
                      Navigator.pop(context);
                      _analyzeImage(index);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text('Remove Photo',
                        style: TextStyle(color: Colors.red)),
                    onTap: () {
                      Navigator.pop(context);
                      _removeImage(index);
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source, int index) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _images[index] = File(pickedFile.path);
          _imageAnalyses[index] = ''; // Clear previous analysis
        });
        // Automatically analyze new image
        await _analyzeImage(index);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick image'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images[index] = null;
      _imageAnalyses[index] = '';
    });
  }

  Widget _buildImageContainer(int index) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _showImageSourceDialog(index),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _images[index] == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap to add',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _images[index]!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () =>
                                      _showImageSourceDialog(index),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        if (_imageAnalyses[index].isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              _imageAnalyses[index],
              style: const TextStyle(fontSize: 12),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Photos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Upload your photos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: List.generate(
                  3,
                  (index) => _buildImageContainer(index),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: _images.any((image) => image != null)
                      ? () {
                          // TODO: Implement form submission with images and analyses
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Form submitted successfully!'),
                            ),
                          );
                        }
                      : null,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
