// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// ADD THESE DEPENDENCIES to your pubspec.yaml file:
//   image_picker: ^1.0.7
//   http: ^1.2.1
//   mime: ^1.0.4

import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class AICropDiseaseDetector extends StatefulWidget {
  const AICropDiseaseDetector({
    Key? key,
    this.width,
    this.height,
    required this.geminiApiKey,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String geminiApiKey;

  @override
  _AICropDiseaseDetectorState createState() => _AICropDiseaseDetectorState();
}

class _AICropDiseaseDetectorState extends State<AICropDiseaseDetector> {
  XFile? _imageFile;
  Uint8List? _imageBytes;
  bool _isAnalyzing = false;
  String? _detectedDisease;
  String? _recommendations;
  String? _confidence;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 600,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2E7D32),
            Color(0xFF4CAF50),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: _imageBytes == null
                    ? _buildImageInput()
                    : _buildAnalysisView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.eco,
              color: Colors.white,
              size: 28,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Crop Disease Detector',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Use your camera for an instant analysis',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageInput() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          GestureDetector(
            onTap: () => _showImageSourceActionSheet(context),
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Color(0xFFF1F8E9),
                borderRadius: BorderRadius.circular(75),
                border: Border.all(
                  color: Color(0xFF4CAF50),
                  width: 3,
                ),
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                size: 60,
                color: Color(0xFF4CAF50),
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Add Crop Image',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Take a photo or select one from your gallery for the AI to analyze.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: _buildImageSourceButton(
                  context,
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onPressed: () => _getImage(ImageSource.camera),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildImageSourceButton(
                  context,
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onPressed: () => _getImage(ImageSource.gallery),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildImageSourceButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Gallery'),
                    onTap: () {
                      _getImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _imageFile = pickedFile;
          _imageBytes = bytes;
          _detectedDisease = null;
          _recommendations = null;
          _confidence = null;
        });
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  Widget _buildAnalysisView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImagePreview(),
          SizedBox(height: 20),
          _buildAnalysisButton(),
          if (_isAnalyzing) _buildLoadingIndicator(),
          if (_detectedDisease != null && !_isAnalyzing) _buildResults(),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: _imageBytes != null
            ? Image.memory(
                _imageBytes!,
                fit: BoxFit.cover,
              )
            : Container(
                color: Colors.grey[200],
                child: Center(
                  child: Text('No Image Selected'),
                ),
              ),
      ),
    );
  }

  Widget _buildAnalysisButton() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _isAnalyzing ? null : _analyzeImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.analytics, size: 20),
                SizedBox(width: 8),
                Text(
                  'Analyze Disease',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12),
        ElevatedButton(
          onPressed: _resetAnalysis,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[100],
            foregroundColor: Colors.grey[700],
            padding: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      margin: EdgeInsets.only(top: 24),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Color(0xFFF1F8E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
          ),
          SizedBox(height: 16),
          Text(
            'AI is analyzing your crop...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'This may take a few seconds',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResultCard(
            'Disease Detected',
            _detectedDisease!,
            Icons.bug_report,
            Colors.orange,
          ),
          if (_confidence != null)
            _buildResultCard(
              'Confidence',
              _confidence!,
              Icons.analytics,
              Colors.blue,
            ),
          if (_recommendations != null) _buildRecommendationCard(),
        ],
      ),
    );
  }

  Widget _buildResultCard(
      String title, String content, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF1F8E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF4CAF50).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF4CAF50).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    Icon(Icons.lightbulb, color: Color(0xFF4CAF50), size: 20),
              ),
              SizedBox(width: 12),
              Text(
                'Recommendations',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            _recommendations!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Extract JSON from response text that might contain markdown or extra formatting
  String _extractJsonFromResponse(String response) {
    // Remove markdown formatting
    String cleaned = response.replaceAll('```json', '').replaceAll('```', '');

    // Find JSON object boundaries
    int startIndex = cleaned.indexOf('{');
    int endIndex = cleaned.lastIndexOf('}');

    if (startIndex != -1 && endIndex != -1 && startIndex < endIndex) {
      return cleaned.substring(startIndex, endIndex + 1);
    }

    return cleaned.trim();
  }

  // Parse response with fallback for non-JSON responses
  Map<String, dynamic> _parseAIResponse(String content) {
    try {
      // First, try to extract and parse JSON
      String cleanedContent = _extractJsonFromResponse(content);
      return jsonDecode(cleanedContent);
    } catch (e) {
      // If JSON parsing fails, try to extract information manually
      print('JSON parsing failed, attempting manual extraction: $e');

      // Fallback: Parse the response manually for key information
      String disease = 'Unknown';
      String confidence = 'N/A';
      String recommendations = content; // Use full content as recommendations

      // Try to identify common disease patterns
      content = content.toLowerCase();

      if (content.contains('healthy') || content.contains('no disease')) {
        disease = 'Healthy';
        confidence = 'High';
        recommendations =
            'The plant appears to be healthy. Continue with regular care and monitoring.';
      } else if (content.contains('blight')) {
        disease = 'Blight';
        confidence = 'Medium';
      } else if (content.contains('rust')) {
        disease = 'Rust';
        confidence = 'Medium';
      } else if (content.contains('mildew')) {
        disease = 'Mildew';
        confidence = 'Medium';
      } else if (content.contains('spot')) {
        disease = 'Leaf Spot';
        confidence = 'Medium';
      } else if (content.contains('wilt')) {
        disease = 'Wilt Disease';
        confidence = 'Medium';
      }

      return {
        'disease': disease,
        'confidence': confidence,
        'recommendations': recommendations.length > 500
            ? recommendations.substring(0, 500) + '...'
            : recommendations
      };
    }
  }

  Future<void> _analyzeImage() async {
    if (_imageBytes == null || widget.geminiApiKey.isEmpty) {
      _showError('Please select an image and ensure the API key is provided.');
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _detectedDisease = null;
      _recommendations = null;
      _confidence = null;
    });

    try {
      String base64Image = base64Encode(_imageBytes!);
      final mimeType =
          lookupMimeType(_imageFile!.path, headerBytes: _imageBytes) ??
              'image/jpeg';

      final url = Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${widget.geminiApiKey}');

      // Improved prompt with stricter JSON format requirements
      final prompt = '''
You are an agricultural expert specializing in crop disease identification. Analyze this plant image and provide your assessment.

Your response MUST be a valid JSON object with exactly these three keys:
- "disease": The name of the disease or "Healthy" if no disease is detected
- "confidence": Your confidence level as "High", "Medium", or "Low"  
- "recommendations": Treatment recommendations or care instructions

Example format:
{"disease": "Early Blight", "confidence": "High", "recommendations": "Apply copper-based fungicide weekly. Remove affected leaves. Ensure proper spacing for air circulation."}

Do not include any other text, explanations, or markdown formatting. Respond only with the JSON object.
''';

      final body = jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt},
              {
                "inline_data": {"mime_type": mimeType, "data": base64Image}
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.1,
          "topK": 1,
          "topP": 1,
          "maxOutputTokens": 1024,
        }
      });

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (responseBody['candidates'] != null &&
            responseBody['candidates'].isNotEmpty &&
            responseBody['candidates'][0]['content'] != null &&
            responseBody['candidates'][0]['content']['parts'] != null &&
            responseBody['candidates'][0]['content']['parts'].isNotEmpty) {
          final content =
              responseBody['candidates'][0]['content']['parts'][0]['text'];
          print('AI Response: $content'); // Debug logging

          final result = _parseAIResponse(content);

          setState(() {
            _detectedDisease = result['disease'] ?? 'Analysis incomplete';
            _confidence = result['confidence'] ?? 'N/A';
            _recommendations =
                result['recommendations'] ?? 'No recommendations provided.';
          });
        } else {
          _showError('Invalid response structure from API');
        }
      } else {
        final errorBody = response.body;
        print('API Error: ${response.statusCode} - $errorBody');
        _showError(
            'API Error: ${response.statusCode}. Please check your API key and try again.');
      }
    } catch (e) {
      print('Analysis error: $e');
      _showError('Analysis failed: ${e.toString()}. Please try again.');
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  void _resetAnalysis() {
    setState(() {
      _imageFile = null;
      _imageBytes = null;
      _detectedDisease = null;
      _recommendations = null;
      _confidence = null;
      _isAnalyzing = false;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }
}
