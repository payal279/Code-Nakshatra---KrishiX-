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

class FarmerAiSuggester extends StatefulWidget {
  const FarmerAiSuggester({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _FarmerAiSuggesterState createState() => _FarmerAiSuggesterState();
}

class _FarmerAiSuggesterState extends State<FarmerAiSuggester> {
  // Form data
  int selectedCropIndex = 0;
  int selectedFarmSizeIndex = 0;
  int selectedBudgetIndex = 0;
  int selectedSeasonIndex = 0;
  int selectedSoilIndex = 0;
  int selectedExperienceIndex = 0;
  String farmerName = '';
  String location = '';

  // UI State
  bool showRecommendations = false;
  List<Map<String, dynamic>> recommendations = [];
  String analysisResult = "";

  // Dropdown options
  final List<String> cropTypes = [
    'Select Crop',
    'Rice',
    'Wheat',
    'Corn',
    'Vegetables',
    'Cotton',
    'Fruits',
    'Mixed'
  ];
  final List<String> farmSizes = [
    'Select Size',
    'Small (1-5 acres)',
    'Medium (6-25 acres)',
    'Large (25+ acres)',
    'Very Large (50+ acres)'
  ];
  final List<String> budgets = [
    'Select Budget',
    'Low (Under \$5K)',
    'Medium (\$5K-\$25K)',
    'High (\$25K-\$100K)',
    'Premium (\$100K+)'
  ];
  final List<String> seasons = [
    'Select Season',
    'Spring',
    'Summer',
    'Fall',
    'Winter'
  ];
  final List<String> soilTypes = [
    'Select Soil',
    'Loamy',
    'Sandy',
    'Clay',
    'Silty',
    'Rocky',
    'Mixed'
  ];
  final List<String> experienceLevels = [
    'Select Experience',
    'Beginner (0-2 years)',
    'Intermediate (3-10 years)',
    'Expert (10+ years)'
  ];

  // Comprehensive farming knowledge database
  Map<String, dynamic> farmingKnowledge = {
    'equipment_database': {
      // Power Equipment
      'Walk-behind Tractor': {
        'price': 3000,
        'category': 'Power',
        'size': 'Small',
        'priority': 'High',
        'desc': 'Perfect for small plots and gardens'
      },
      'Compact Tractor (25-45 HP)': {
        'price': 20000,
        'category': 'Power',
        'size': 'Medium',
        'priority': 'High',
        'desc': 'Versatile for medium farms'
      },
      'Farm Tractor (60+ HP)': {
        'price': 60000,
        'category': 'Power',
        'size': 'Large',
        'priority': 'High',
        'desc': 'Heavy-duty for large operations'
      },
      'Power Tiller': {
        'price': 1500,
        'category': 'Power',
        'size': 'Small',
        'priority': 'High',
        'desc': 'Motorized soil cultivation'
      },

      // Tillage Equipment
      'Hand Hoe': {
        'price': 25,
        'category': 'Tillage',
        'size': 'Small',
        'priority': 'High',
        'desc': 'Essential hand tool for cultivation'
      },
      'Rotary Tiller': {
        'price': 1200,
        'category': 'Tillage',
        'size': 'Small',
        'priority': 'High',
        'desc': 'Soil preparation and weed control'
      },
      'Disc Harrow': {
        'price': 4000,
        'category': 'Tillage',
        'size': 'Medium',
        'priority': 'Medium',
        'desc': 'Breaking up soil clods'
      },
      'Cultivator': {
        'price': 2500,
        'category': 'Tillage',
        'size': 'Medium',
        'priority': 'Medium',
        'desc': 'Secondary tillage operations'
      },
      'Field Cultivator': {
        'price': 15000,
        'category': 'Tillage',
        'size': 'Large',
        'priority': 'Medium',
        'desc': 'Large field preparation'
      },

      // Planting Equipment
      'Hand Seeder': {
        'price': 50,
        'category': 'Planting',
        'size': 'Small',
        'priority': 'High',
        'desc': 'Manual seed planting tool'
      },
      'Seed Drill': {
        'price': 5000,
        'category': 'Planting',
        'size': 'Medium',
        'priority': 'High',
        'desc': 'Precision seed placement'
      },
      'Planter': {
        'price': 12000,
        'category': 'Planting',
        'size': 'Medium',
        'priority': 'High',
        'desc': 'Row crop planting'
      },
      'Transplanter': {
        'price': 8000,
        'category': 'Planting',
        'size': 'Medium',
        'priority': 'Medium',
        'desc': 'Seedling transplantation'
      },
      'Broadcast Seeder': {
        'price': 800,
        'category': 'Planting',
        'size': 'Small',
        'priority': 'Medium',
        'desc': 'Wide area seeding'
      },

      // Harvesting Equipment
      'Sickle': {
        'price': 15,
        'category': 'Harvesting',
        'size': 'Small',
        'priority': 'High',
        'desc': 'Manual harvesting tool'
      },
      'Reaper': {
        'price': 10000,
        'category': 'Harvesting',
        'size': 'Medium',
        'priority': 'Medium',
        'desc': 'Cutting crops efficiently'
      },
      'Combine Harvester': {
        'price': 400000,
        'category': 'Harvesting',
        'size': 'Large',
        'priority': 'Low',
        'desc': 'Complete harvesting solution'
      },
      'Thresher': {
        'price': 8000,
        'category': 'Harvesting',
        'size': 'Medium',
        'priority': 'Medium',
        'desc': 'Separating grain from stalks'
      },
      'Cotton Picker': {
        'price': 500000,
        'category': 'Harvesting',
        'size': 'Large',
        'priority': 'Low',
        'desc': 'Cotton harvesting machine'
      },

      // Irrigation Equipment
      'Watering Can': {
        'price': 20,
        'category': 'Irrigation',
        'size': 'Small',
        'priority': 'High',
        'desc': 'Basic watering tool'
      },
      'Garden Hose': {
        'price': 50,
        'category': 'Irrigation',
        'size': 'Small',
        'priority': 'High',
        'desc': 'Flexible water delivery'
      },
      'Drip Irrigation Kit': {
        'price': 600,
        'category': 'Irrigation',
        'size': 'Small',
        'priority': 'High',
        'desc': 'Water-efficient irrigation'
      },
      'Sprinkler System': {
        'price': 3000,
        'category': 'Irrigation',
        'size': 'Medium',
        'priority': 'High',
        'desc': 'Automated watering system'
      },
      'Center Pivot System': {
        'price': 100000,
        'category': 'Irrigation',
        'size': 'Large',
        'priority': 'Medium',
        'desc': 'Large field irrigation'
      },
      'Water Pump': {
        'price': 800,
        'category': 'Irrigation',
        'size': 'Medium',
        'priority': 'High',
        'desc': 'Water source management'
      },

      // General Tools
      'Wheelbarrow': {
        'price': 120,
        'category': 'General',
        'size': 'Small',
        'priority': 'Medium',
        'desc': 'Material transportation'
      },
      'Pruning Shears': {
        'price': 40,
        'category': 'General',
        'size': 'Small',
        'priority': 'Medium',
        'desc': 'Plant maintenance'
      },
      'Shovel': {
        'price': 30,
        'category': 'General',
        'size': 'Small',
        'priority': 'High',
        'desc': 'Digging and soil work'
      },
      'Rake': {
        'price': 25,
        'category': 'General',
        'size': 'Small',
        'priority': 'Medium',
        'desc': 'Soil leveling and cleanup'
      },
      'Fertilizer Spreader': {
        'price': 300,
        'category': 'General',
        'size': 'Small',
        'priority': 'Medium',
        'desc': 'Even fertilizer distribution'
      },
      'Spray Equipment': {
        'price': 500,
        'category': 'General',
        'size': 'Medium',
        'priority': 'Medium',
        'desc': 'Pesticide application'
      },

      // Storage Equipment
      'Storage Bins': {
        'price': 200,
        'category': 'Storage',
        'size': 'Small',
        'priority': 'Medium',
        'desc': 'Grain and produce storage'
      },
      'Weighing Scale': {
        'price': 150,
        'category': 'Storage',
        'size': 'Small',
        'priority': 'Medium',
        'desc': 'Accurate produce measurement'
      },
    },
    'materials_database': {
      // Seeds
      'Rice Seeds (Hybrid)': {
        'price': 80,
        'category': 'Seeds',
        'crops': [1],
        'season': [1, 2]
      },
      'Wheat Seeds (Certified)': {
        'price': 60,
        'category': 'Seeds',
        'crops': [2],
        'season': [3, 4]
      },
      'Corn Seeds (High Yield)': {
        'price': 120,
        'category': 'Seeds',
        'crops': [3],
        'season': [1, 2]
      },
      'Vegetable Seeds Mix': {
        'price': 40,
        'category': 'Seeds',
        'crops': [4],
        'season': [1, 2, 3]
      },
      'Cotton Seeds (BT)': {
        'price': 150,
        'category': 'Seeds',
        'crops': [5],
        'season': [1]
      },
      'Fruit Saplings': {
        'price': 25,
        'category': 'Seeds',
        'crops': [6],
        'season': [1, 3]
      },

      // Fertilizers
      'NPK Fertilizer (20-20-20)': {
        'price': 45,
        'category': 'Fertilizer',
        'crops': [7],
        'desc': 'Balanced nutrition'
      },
      'Urea (46-0-0)': {
        'price': 35,
        'category': 'Fertilizer',
        'crops': [1, 2, 3],
        'desc': 'Nitrogen source'
      },
      'Organic Compost': {
        'price': 25,
        'category': 'Fertilizer',
        'crops': [4, 6],
        'desc': 'Natural soil enhancer'
      },
      'Potash Fertilizer': {
        'price': 40,
        'category': 'Fertilizer',
        'crops': [5, 6],
        'desc': 'Potassium source'
      },
      'Phosphate Fertilizer': {
        'price': 38,
        'category': 'Fertilizer',
        'crops': [2, 3],
        'desc': 'Phosphorus source'
      },

      // Protection Products
      'Bio-Pesticide': {
        'price': 30,
        'category': 'Protection',
        'crops': [4, 6],
        'desc': 'Organic pest control'
      },
      'Herbicide (Glyphosate)': {
        'price': 25,
        'category': 'Protection',
        'crops': [3, 5],
        'desc': 'Weed control'
      },
      'Fungicide': {
        'price': 35,
        'category': 'Protection',
        'crops': [2, 1],
        'desc': 'Disease prevention'
      },
      'Insecticide': {
        'price': 40,
        'category': 'Protection',
        'crops': [5, 1],
        'desc': 'Insect control'
      },
      'Neem Oil': {
        'price': 20,
        'category': 'Protection',
        'crops': [4, 6],
        'desc': 'Natural pest deterrent'
      },

      // Materials
      'Plastic Mulch': {
        'price': 100,
        'category': 'Materials',
        'crops': [4],
        'desc': 'Weed suppression'
      },
      'Irrigation Pipes': {
        'price': 200,
        'category': 'Materials',
        'crops': [7],
        'desc': 'Water distribution'
      },
      'Support Stakes': {
        'price': 50,
        'category': 'Materials',
        'crops': [4, 6],
        'desc': 'Plant support'
      },
    }
  };

  void generateRecommendations() {
    if (!_validateInputs()) return;

    List<Map<String, dynamic>> equipmentRecs = [];
    List<Map<String, dynamic>> materialRecs = [];

    // Determine farm size category
    String sizeCategory = 'Small';
    if (selectedFarmSizeIndex == 2) {
      sizeCategory = 'Medium';
    } else if (selectedFarmSizeIndex >= 3) {
      sizeCategory = 'Large';
    }

    // Determine budget constraints
    int maxBudgetPerItem = 2000;
    if (selectedBudgetIndex == 2) {
      maxBudgetPerItem = 15000;
    } else if (selectedBudgetIndex == 3) {
      maxBudgetPerItem = 75000;
    } else if (selectedBudgetIndex == 4) {
      maxBudgetPerItem = 1000000;
    }

    // Experience level considerations
    bool isBeginnerFarmer = selectedExperienceIndex == 1;

    // Equipment recommendations
    farmingKnowledge['equipment_database'].forEach((name, details) {
      bool shouldInclude = false;

      // Check size compatibility
      if ((sizeCategory == 'Small' && details['size'] == 'Small') ||
          (sizeCategory == 'Medium' &&
              (details['size'] == 'Small' || details['size'] == 'Medium')) ||
          (sizeCategory == 'Large')) {
        shouldInclude = true;
      }

      // Check budget
      if (details['price'] > maxBudgetPerItem) {
        shouldInclude = false;
      }

      // Experience level adjustments
      if (isBeginnerFarmer && details['price'] > 5000) {
        shouldInclude = false;
      }

      // Crop-specific filtering
      if (selectedCropIndex == 5 && name.contains('Cotton')) {
        // Cotton
        shouldInclude = true;
      } else if (selectedCropIndex == 6 &&
          (name.contains('Fruit') || name.contains('Pruning'))) {
        // Fruits
        shouldInclude = true;
      }

      if (shouldInclude) {
        equipmentRecs.add({
          'name': name,
          'price': '\$${_formatPrice(details['price'])}',
          'category': details['category'],
          'priority': details['priority'],
          'description': details['desc'],
          'type': 'equipment'
        });
      }
    });

    // Material recommendations
    farmingKnowledge['materials_database'].forEach((name, details) {
      bool shouldInclude = false;

      // Check crop compatibility
      List<int> compatibleCrops = List<int>.from(details['crops']);
      if (compatibleCrops.contains(selectedCropIndex) ||
          compatibleCrops.contains(7)) {
        // 7 = Mixed
        shouldInclude = true;
      }

      // Check seasonal relevance for seeds
      if (details['category'] == 'Seeds' && details.containsKey('season')) {
        List<int> compatibleSeasons = List<int>.from(details['season']);
        if (!compatibleSeasons.contains(selectedSeasonIndex)) {
          shouldInclude = false;
        }
      }

      if (shouldInclude) {
        materialRecs.add({
          'name': name,
          'price': '\$${details['price']}/unit',
          'category': details['category'],
          'priority': _determinePriority(details['category']),
          'description': details.containsKey('desc')
              ? details['desc']
              : 'Essential farming material',
          'type': 'material'
        });
      }
    });

    // Sort by priority and combine
    equipmentRecs.sort((a, b) =>
        _priorityValue(a['priority']).compareTo(_priorityValue(b['priority'])));
    materialRecs.sort((a, b) =>
        _priorityValue(a['priority']).compareTo(_priorityValue(b['priority'])));

    // Limit recommendations based on experience
    int maxItems = isBeginnerFarmer
        ? 10
        : selectedExperienceIndex == 2
            ? 15
            : 20;

    List<Map<String, dynamic>> allRecs = [...equipmentRecs, ...materialRecs];
    recommendations = allRecs.take(maxItems).toList();

    // Generate analysis
    analysisResult = _generateAnalysis();

    setState(() {
      showRecommendations = true;
    });
  }

  bool _validateInputs() {
    return selectedCropIndex > 0 &&
        selectedFarmSizeIndex > 0 &&
        selectedBudgetIndex > 0 &&
        selectedSeasonIndex > 0 &&
        selectedSoilIndex > 0 &&
        selectedExperienceIndex > 0;
  }

  String _formatPrice(int price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(price % 1000 == 0 ? 0 : 1)}K';
    }
    return price.toString();
  }

  String _determinePriority(String category) {
    Map<String, String> categoryPriority = {
      'Seeds': 'High',
      'Fertilizer': 'High',
      'Protection': 'Medium',
      'Materials': 'Medium',
    };
    return categoryPriority[category] ?? 'Medium';
  }

  int _priorityValue(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return 1;
      case 'medium':
        return 2;
      case 'low':
        return 3;
      default:
        return 2;
    }
  }

  String _generateAnalysis() {
    String cropType =
        selectedCropIndex > 0 ? cropTypes[selectedCropIndex] : 'Unknown';
    String farmSize = selectedFarmSizeIndex > 0
        ? farmSizes[selectedFarmSizeIndex]
        : 'Unknown';
    String budget =
        selectedBudgetIndex > 0 ? budgets[selectedBudgetIndex] : 'Unknown';
    String season =
        selectedSeasonIndex > 0 ? seasons[selectedSeasonIndex] : 'Unknown';

    String seasonalAdvice = '';
    switch (selectedSeasonIndex) {
      case 1: // Spring
        seasonalAdvice = 'Focus on soil preparation and planting equipment.';
        break;
      case 2: // Summer
        seasonalAdvice = 'Prioritize irrigation and pest control equipment.';
        break;
      case 3: // Fall
        seasonalAdvice = 'Prepare harvesting and storage equipment.';
        break;
      case 4: // Winter
        seasonalAdvice = 'Plan maintenance and next season preparation.';
        break;
    }

    return 'Smart Analysis: $cropType farming on $farmSize with $budget budget during $season. $seasonalAdvice Total recommendations: ${recommendations.length} items.';
  }

  Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFE53E3E);
      case 'medium':
        return const Color(0xFFFF8C00);
      case 'low':
        return const Color(0xFF3182CE);
      default:
        return const Color(0xFF718096);
    }
  }

  IconData getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Icons.priority_high;
      case 'medium':
        return Icons.remove;
      case 'low':
        return Icons.low_priority;
      default:
        return Icons.help;
    }
  }

  IconData getCategoryIcon(String category, String type) {
    if (type == 'equipment') {
      switch (category) {
        case 'Power':
          return Icons.settings;
        case 'Tillage':
          return Icons.agriculture;
        case 'Planting':
          return Icons.eco;
        case 'Harvesting':
          return Icons.grass;
        case 'Irrigation':
          return Icons.water_drop;
        case 'General':
          return Icons.build;
        case 'Storage':
          return Icons.storage;
        default:
          return Icons.build;
      }
    } else {
      switch (category) {
        case 'Seeds':
          return Icons.eco;
        case 'Fertilizer':
          return Icons.scatter_plot;
        case 'Protection':
          return Icons.shield;
        case 'Materials':
          return Icons.category;
        default:
          return Icons.category;
      }
    }
  }

  Widget buildDropdown(String label, List<String> items, int selectedIndex,
      Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(8),
            color: FlutterFlowTheme.of(context).primaryBackground,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedIndex,
              isExpanded: true,
              items: items.asMap().entries.map((entry) {
                int index = entry.key;
                String value = entry.value;
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 13,
                      color: index == 0
                          ? const Color(0xFF9CA3AF)
                          : FlutterFlowTheme.of(context).primaryText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTextField(String label, String hint, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(8),
            color: FlutterFlowTheme.of(context).primaryBackground,
          ),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            color: Color(0x1A000000),
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFF4CAF50)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                if (showRecommendations)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showRecommendations = false;
                      });
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                if (showRecommendations) const SizedBox(width: 12),
                const Icon(Icons.agriculture, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        showRecommendations
                            ? 'Smart Recommendations${farmerName.isNotEmpty ? ' for $farmerName' : ''}'
                            : 'Smart Farm Equipment Advisor',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        showRecommendations
                            ? '${recommendations.length} personalized recommendations'
                            : 'Get personalized equipment suggestions',
                        style: const TextStyle(
                          color: Color(0xFFE3F2FD),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child:
                showRecommendations ? buildRecommendations() : buildInputForm(),
          ),
        ],
      ),
    );
  }

  Widget buildInputForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Personal Info Section
          const Text(
            '👨‍🌾 Farmer Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          buildTextField(
            'Farmer Name',
            'Enter your name',
            (value) => setState(() => farmerName = value),
          ),
          const SizedBox(height: 16),

          buildTextField(
            'Location',
            'Enter your farm location',
            (value) => setState(() => location = value),
          ),

          const SizedBox(height: 24),

          // Farm Details Section
          const Text(
            '🚜 Farm Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // First Row
          Row(
            children: [
              Expanded(
                child: buildDropdown(
                  'Crop Type',
                  cropTypes,
                  selectedCropIndex,
                  (value) => setState(() => selectedCropIndex = value),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildDropdown(
                  'Farm Size',
                  farmSizes,
                  selectedFarmSizeIndex,
                  (value) => setState(() => selectedFarmSizeIndex = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Second Row
          Row(
            children: [
              Expanded(
                child: buildDropdown(
                  'Budget Range',
                  budgets,
                  selectedBudgetIndex,
                  (value) => setState(() => selectedBudgetIndex = value),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildDropdown(
                  'Season',
                  seasons,
                  selectedSeasonIndex,
                  (value) => setState(() => selectedSeasonIndex = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Third Row
          Row(
            children: [
              Expanded(
                child: buildDropdown(
                  'Soil Type',
                  soilTypes,
                  selectedSoilIndex,
                  (value) => setState(() => selectedSoilIndex = value),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildDropdown(
                  'Experience',
                  experienceLevels,
                  selectedExperienceIndex,
                  (value) => setState(() => selectedExperienceIndex = value),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Generate Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _validateInputs() ? generateRecommendations : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _validateInputs()
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFFE0E0E0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: _validateInputs() ? 2 : 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.psychology,
                    color: _validateInputs()
                        ? Colors.white
                        : const Color(0xFF9E9E9E),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Generate Smart Recommendations',
                    style: TextStyle(
                      color: _validateInputs()
                          ? Colors.white
                          : const Color(0xFF9E9E9E),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (!_validateInputs())
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                '⚠️ Please fill all fields to generate recommendations',
                style: TextStyle(
                  color: Color(0xFFE53E3E),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildRecommendations() {
    return Column(
      children: [
        // Analysis Section
        if (analysisResult.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              border: Border(
                bottom: BorderSide(color: const Color(0xFFE2E8F0)),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.analytics,
                  color: Color(0xFF1976D2),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    analysisResult,
                    style: const TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Recommendations List
        Expanded(
          child: recommendations.isEmpty
              ? const Center(
                  child: Text(
                    'No recommendations available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: recommendations.length,
                  itemBuilder: (context, index) {
                    final item = recommendations[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: getPriorityColor(item['priority'])
                              .withOpacity(0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            color: getPriorityColor(item['priority'])
                                .withOpacity(0.1),
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // Icon Container
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: getPriorityColor(item['priority'])
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Icon(
                                getCategoryIcon(item['category'], item['type']),
                                color: getPriorityColor(item['priority']),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Name and Priority
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 3),
                                        decoration: BoxDecoration(
                                          color:
                                              getPriorityColor(item['priority'])
                                                  .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          item['priority'],
                                          style: TextStyle(
                                            color: getPriorityColor(
                                                item['priority']),
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),

                                  // Price and Category
                                  Row(
                                    children: [
                                      Text(
                                        item['price'],
                                        style: const TextStyle(
                                          color: Color(0xFF1976D2),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF5F5F5),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          item['category'],
                                          style: const TextStyle(
                                            color: Color(0xFF6B7280),
                                            fontSize: 9,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        item['type'] == 'equipment'
                                            ? Icons.build
                                            : Icons.category,
                                        size: 12,
                                        color: const Color(0xFF6B7280),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),

                                  // Description
                                  Text(
                                    item['description'],
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
