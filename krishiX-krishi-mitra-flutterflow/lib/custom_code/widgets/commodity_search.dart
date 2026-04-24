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

class CommoditySearch extends StatefulWidget {
  const CommoditySearch({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _CommoditySearchState createState() => _CommoditySearchState();
}

class _CommoditySearchState extends State<CommoditySearch> {
  Map<String, String>? _selectedCrop;

  // --- 100-Crop Dataset ---
  final List<Map<String, String>> _allCrops = [
    {
      'name': 'Aloe Vera',
      'price': '₹10–20/kg',
      'season': 'Annual',
      'nutrients': 'Gel nutrients'
    },
    {
      'name': 'Almond',
      'price': '₹600–800',
      'season': 'Rabi',
      'nutrients': 'Vitamin E'
    },
    {
      'name': 'Apple',
      'price': '₹80–150',
      'season': 'Rabi',
      'nutrients': 'Fiber'
    },
    {
      'name': 'Apricot',
      'price': '₹120–180',
      'season': 'Rabi',
      'nutrients': 'Vitamins'
    },
    {
      'name': 'Areca Nut',
      'price': '₹150–200',
      'season': 'Annual',
      'nutrients': '—'
    },
    {
      'name': 'Asparagus',
      'price': '₹200–250',
      'season': 'Temperate',
      'nutrients': 'Folate'
    },
    {
      'name': 'Avocado',
      'price': '₹150–250',
      'season': 'Annual',
      'nutrients': 'Healthy fats'
    },
    {
      'name': 'Bajra (Pearl Millet)',
      'price': '₹20–28',
      'season': 'Kharif',
      'nutrients': 'Protein, iron'
    },
    {
      'name': 'Bamboo Shoots',
      'price': '₹70–100',
      'season': 'Annual',
      'nutrients': 'Fiber'
    },
    {
      'name': 'Banana',
      'price': '₹20–40',
      'season': 'Annual',
      'nutrients': 'Potassium'
    },
    {
      'name': 'Barley',
      'price': '₹25–35',
      'season': 'Rabi',
      'nutrients': 'Fiber, minerals'
    },
    {
      'name': 'Beetroot',
      'price': '₹20–35',
      'season': 'Rabi',
      'nutrients': 'Iron'
    },
    {
      'name': 'Bitter Gourd',
      'price': '₹25–40',
      'season': 'Kharif',
      'nutrients': 'Vitamins A & C'
    },
    {
      'name': 'Black Gram (Urad)',
      'price': '₹80–120',
      'season': 'Kharif',
      'nutrients': 'Protein'
    },
    {
      'name': 'Black Pepper',
      'price': '₹450–550',
      'season': 'Perennial',
      'nutrients': 'Piperine'
    },
    {
      'name': 'Black Rice',
      'price': '₹120–180',
      'season': 'Kharif',
      'nutrients': 'Anthocyanins'
    },
    {
      'name': 'Blueberry',
      'price': '₹600–800',
      'season': 'Temperate',
      'nutrients': 'Antioxidants'
    },
    {
      'name': 'Bottle Gourd',
      'price': '₹15–25',
      'season': 'Kharif',
      'nutrients': 'Hydration'
    },
    {
      'name': 'Brinjal',
      'price': '₹20–35',
      'season': 'Kharif',
      'nutrients': 'Antioxidants'
    },
    {
      'name': 'Broccoli',
      'price': '₹60–100',
      'season': 'Rabi',
      'nutrients': 'Vitamin C'
    },
    {
      'name': 'Cabbage',
      'price': '₹10–25',
      'season': 'Rabi',
      'nutrients': 'Vitamin K'
    },
    {
      'name': 'Capsicum',
      'price': '₹30–60',
      'season': 'Kharif',
      'nutrients': 'Vitamin C'
    },
    {
      'name': 'Cardamom',
      'price': '₹1500–1800',
      'season': 'Kharif',
      'nutrients': 'Antioxidants'
    },
    {
      'name': 'Carrot',
      'price': '₹20–30',
      'season': 'Rabi',
      'nutrients': 'Vitamin A'
    },
    {
      'name': 'Cashew',
      'price': '₹400–600',
      'season': 'Annual',
      'nutrients': 'Healthy fats'
    },
    {
      'name': 'Cauliflower',
      'price': '₹15–30',
      'season': 'Rabi',
      'nutrients': 'Vitamin C'
    },
    {
      'name': 'Chickpea (Chana)',
      'price': '₹55–70',
      'season': 'Rabi',
      'nutrients': 'Protein, fiber'
    },
    {
      'name': 'Chili',
      'price': '₹40–80',
      'season': 'Kharif',
      'nutrients': 'Capsaicin'
    },
    {
      'name': 'Cloves',
      'price': '₹800–1000',
      'season': 'Annual',
      'nutrients': 'Antioxidants'
    },
    {
      'name': 'Coconut',
      'price': '₹30–40',
      'season': 'Annual',
      'nutrients': 'Healthy fats'
    },
    {
      'name': 'Coffee',
      'price': '₹250–350',
      'season': 'Perennial',
      'nutrients': 'Caffeine'
    },
    {
      'name': 'Coriander',
      'price': '₹30–50',
      'season': 'Rabi',
      'nutrients': 'Antioxidants'
    },
    {
      'name': 'Cotton',
      'price': '₹65–75/kg lint',
      'season': 'Kharif',
      'nutrients': '—'
    },
    {
      'name': 'Cowpea',
      'price': '₹60–90',
      'season': 'Kharif',
      'nutrients': 'Protein'
    },
    {
      'name': 'Cucumber',
      'price': '₹15–25',
      'season': 'Kharif',
      'nutrients': 'Electrolytes'
    },
    {
      'name': 'Cumin (Jeera)',
      'price': '₹200–250',
      'season': 'Rabi',
      'nutrients': 'Iron'
    },
    {
      'name': 'Dragon Fruit',
      'price': '₹120–180',
      'season': 'Annual',
      'nutrients': 'Antioxidants'
    },
    {
      'name': 'Drumstick',
      'price': '₹20–40',
      'season': 'Annual',
      'nutrients': 'Iron'
    },
    {
      'name': 'Fennel',
      'price': '₹80–120',
      'season': 'Rabi',
      'nutrients': 'Fiber'
    },
    {
      'name': 'Fenugreek',
      'price': '₹10–20',
      'season': 'Rabi',
      'nutrients': 'Fiber'
    },
    {
      'name': 'Flaxseed',
      'price': '₹70–110',
      'season': 'Rabi',
      'nutrients': 'Omega-3'
    },
    {
      'name': 'Foxtail Millet',
      'price': '₹40–55',
      'season': 'Kharif',
      'nutrients': 'Protein'
    },
    {
      'name': 'Garlic',
      'price': '₹100–160',
      'season': 'Rabi',
      'nutrients': 'Sulphur compounds'
    },
    {
      'name': 'Ginger',
      'price': '₹120–180',
      'season': 'Kharif',
      'nutrients': 'Anti-inflammatory'
    },
    {
      'name': 'Grapes',
      'price': '₹60–120',
      'season': 'Rabi',
      'nutrients': 'Resveratrol'
    },
    {
      'name': 'Green Gram (Moong)',
      'price': '₹85–110',
      'season': 'Kharif',
      'nutrients': 'Protein'
    },
    {
      'name': 'Green Peas',
      'price': '₹40–60',
      'season': 'Rabi',
      'nutrients': 'Protein'
    },
    {
      'name': 'Groundnut',
      'price': '₹50–70',
      'season': 'Kharif',
      'nutrients': 'Healthy fats, protein'
    },
    {
      'name': 'Groundnut (Dry)',
      'price': '₹60–80',
      'season': 'Kharif',
      'nutrients': 'Protein'
    },
    {
      'name': 'Guava',
      'price': '₹25–40',
      'season': 'Rabi',
      'nutrients': 'Vitamin C'
    },
    {
      'name': 'Horse Gram',
      'price': '₹60–80',
      'season': 'Kharif',
      'nutrients': 'Protein'
    },
    {
      'name': 'Jackfruit',
      'price': '₹20–40',
      'season': 'Summer',
      'nutrients': 'Fiber'
    },
    {
      'name': 'Jaggery',
      'price': '₹40–60',
      'season': 'Annual',
      'nutrients': 'Minerals'
    },
    {
      'name': 'Kiwi',
      'price': '₹200–300',
      'season': 'Temperate',
      'nutrients': 'Vitamin C'
    },
    {
      'name': 'Lemon',
      'price': '₹40–80',
      'season': 'Annual',
      'nutrients': 'Vitamin C'
    },
    {
      'name': 'Lettuce',
      'price': '₹60–100',
      'season': 'Winter',
      'nutrients': 'Fiber'
    },
    {
      'name': 'Lotus Stem',
      'price': '₹30–45',
      'season': 'Annual',
      'nutrients': 'Fiber'
    },
    {
      'name': 'Lychee',
      'price': '₹60–100',
      'season': 'Summer',
      'nutrients': 'Vitamin C'
    },
    {
      'name': 'Maize',
      'price': '₹20–30',
      'season': 'Kharif',
      'nutrients': 'Carbs, fiber'
    },
    {
      'name': 'Mango',
      'price': '₹50–120',
      'season': 'Summer',
      'nutrients': 'Vitamin A'
    },
    {
      'name': 'Millet (Ragi)',
      'price': '₹25–35',
      'season': 'Kharif',
      'nutrients': 'Calcium'
    },
    {
      'name': 'Mint',
      'price': '₹10–20',
      'season': 'Rabi',
      'nutrients': 'Menthol'
    },
    {
      'name': 'Mushroom',
      'price': '₹120–200',
      'season': 'Indoor',
      'nutrients': 'Protein'
    },
    {
      'name': 'Muskmelon',
      'price': '₹20–35',
      'season': 'Summer',
      'nutrients': 'Vitamin A'
    },
    {
      'name': 'Mustard',
      'price': '₹45–65',
      'season': 'Rabi',
      'nutrients': 'Omega fats'
    },
    {'name': 'Oats', 'price': '₹30–40', 'season': 'Rabi', 'nutrients': 'Fiber'},
    {
      'name': 'Okra (Bhindi)',
      'price': '₹30–50',
      'season': 'Kharif',
      'nutrients': 'Fiber'
    },
    {
      'name': 'Onion',
      'price': '₹20–40',
      'season': 'Kharif/Rabi',
      'nutrients': 'Sulphur compounds'
    },
    {
      'name': 'Orange',
      'price': '₹40–80',
      'season': 'Winter',
      'nutrients': 'Vitamin C'
    },
    {
      'name': 'Papaya',
      'price': '₹20–35',
      'season': 'Annual',
      'nutrients': 'Vitamin C'
    },
    {
      'name': 'Peach',
      'price': '₹80–120',
      'season': 'Rabi',
      'nutrients': 'Vitamin C'
    },
    {'name': 'Pear', 'price': '₹60–90', 'season': 'Rabi', 'nutrients': 'Fiber'},
    {
      'name': 'Pigeon Pea (Arhar)',
      'price': '₹90–120',
      'season': 'Kharif',
      'nutrients': 'Protein'
    },
    {
      'name': 'Pineapple',
      'price': '₹30–50',
      'season': 'Annual',
      'nutrients': 'Bromelain'
    },
    {
      'name': 'Plum',
      'price': '₹80–130',
      'season': 'Rabi',
      'nutrients': 'Antioxidants'
    },
    {
      'name': 'Pomegranate',
      'price': '₹80–120',
      'season': 'Annual',
      'nutrients': 'Antioxidants'
    },
    {
      'name': 'Potato',
      'price': '₹15–30',
      'season': 'Rabi',
      'nutrients': 'Carbs, potassium'
    },
    {
      'name': 'Pumpkin',
      'price': '₹15–25',
      'season': 'Kharif',
      'nutrients': 'Vitamin A'
    },
    {
      'name': 'Quinoa',
      'price': '₹120–150',
      'season': 'Rabi',
      'nutrients': 'Protein'
    },
    {
      'name': 'Radish',
      'price': '₹8–15',
      'season': 'Rabi',
      'nutrients': 'Vitamin C'
    },
    {
      'name': 'Rajma',
      'price': '₹80–120',
      'season': 'Rabi',
      'nutrients': 'Protein'
    },
    {
      'name': 'Red Lentil (Masoor)',
      'price': '₹60–80',
      'season': 'Rabi',
      'nutrients': 'Iron'
    },
    {
      'name': 'Rice (Paddy)',
      'price': '₹30–45',
      'season': 'Kharif',
      'nutrients': 'Carbs, B vitamins'
    },
    {
      'name': 'Sapota (Chiku)',
      'price': '₹40–70',
      'season': 'Annual',
      'nutrients': 'Carbs'
    },
    {
      'name': 'Sesame (Til)',
      'price': '₹90–110',
      'season': 'Kharif',
      'nutrients': 'Calcium, fat'
    },
    {
      'name': 'Sorghum (Jowar)',
      'price': '₹24–32',
      'season': 'Kharif',
      'nutrients': 'Iron, fiber'
    },
    {
      'name': 'Soybean',
      'price': '₹35–50',
      'season': 'Kharif',
      'nutrients': 'Protein, fat'
    },
    {
      'name': 'Spinach',
      'price': '₹10–20',
      'season': 'Rabi',
      'nutrients': 'Iron'
    },
    {
      'name': 'Strawberry',
      'price': '₹80–120',
      'season': 'Winter',
      'nutrients': 'Vitamin C'
    },
    {
      'name': 'Sugar',
      'price': '₹40–50',
      'season': 'Annual',
      'nutrients': 'Carbs'
    },
    {
      'name': 'Sugarcane',
      'price': '₹4–6/kg',
      'season': 'Annual',
      'nutrients': 'Carbs'
    },
    {
      'name': 'Sunflower',
      'price': '₹40–55',
      'season': 'Kharif',
      'nutrients': 'Vitamin E'
    },
    {
      'name': 'Sweet Potato',
      'price': '₹15–30',
      'season': 'Rabi',
      'nutrients': 'Vitamin A'
    },
    {
      'name': 'Tea',
      'price': '₹180–250/kg',
      'season': 'Perennial',
      'nutrients': 'Polyphenols'
    },
    {
      'name': 'Tomato',
      'price': '₹10–30',
      'season': 'Kharif/Rabi',
      'nutrients': 'Vitamin C'
    },
    {
      'name': 'Turmeric',
      'price': '₹70–110',
      'season': 'Kharif',
      'nutrients': 'Curcumin'
    },
    {
      'name': 'Water Chestnut',
      'price': '₹20–35',
      'season': 'Winter',
      'nutrients': 'Iron'
    },
    {
      'name': 'Watermelon',
      'price': '₹10–20',
      'season': 'Summer',
      'nutrients': 'Hydration'
    },
    {
      'name': 'Wheat',
      'price': '₹25–35',
      'season': 'Rabi',
      'nutrients': 'Carbs, protein'
    },
    {
      'name': 'Yam',
      'price': '₹25–40',
      'season': 'Kharif',
      'nutrients': 'Carbs'
    },
    {
      'name': 'Zucchini',
      'price': '₹40–60',
      'season': 'Kharif',
      'nutrients': 'Vitamin A'
    },
  ];

  @override
  void initState() {
    super.initState();
    _allCrops.sort((a, b) => a['name']!.compareTo(b['name']!));
  }

  // --- Helper: Guess Category based on name ---
  String _getCategory(String name) {
    name = name.toLowerCase();
    if (name.contains('apple') ||
        name.contains('banana') ||
        name.contains('mango') ||
        name.contains('grape') ||
        name.contains('berry') ||
        name.contains('fruit') ||
        name.contains('melon') ||
        name.contains('pear') ||
        name.contains('plum') ||
        name.contains('peach') ||
        name.contains('lemon') ||
        name.contains('orange') ||
        name.contains('papaya') ||
        name.contains('pine')) return 'Fruit';
    if (name.contains('potato') ||
        name.contains('onion') ||
        name.contains('tomato') ||
        name.contains('gourd') ||
        name.contains('brinjal') ||
        name.contains('cabbage') ||
        name.contains('cauli') ||
        name.contains('spinach') ||
        name.contains('carrot') ||
        name.contains('radish') ||
        name.contains('okra') ||
        name.contains('pea') ||
        name.contains('bean') ||
        name.contains('lettuce') ||
        name.contains('zucchini') ||
        name.contains('cucumber')) return 'Vegetable';
    if (name.contains('wheat') ||
        name.contains('rice') ||
        name.contains('maize') ||
        name.contains('millet') ||
        name.contains('barley') ||
        name.contains('sorghum') ||
        name.contains('oat') ||
        name.contains('quinoa')) return 'Grain/Cereal';
    if (name.contains('gram') ||
        name.contains('lentil') ||
        name.contains('chickpea') ||
        name.contains('dal') ||
        name.contains('rajma') ||
        name.contains('soy')) return 'Pulse/Legume';
    if (name.contains('pepper') ||
        name.contains('chili') ||
        name.contains('ginger') ||
        name.contains('garlic') ||
        name.contains('turmeric') ||
        name.contains('cumin') ||
        name.contains('cardamom') ||
        name.contains('clove') ||
        name.contains('coriander') ||
        name.contains('fennel')) return 'Spice';
    if (name.contains('nut') ||
        name.contains('almond') ||
        name.contains('cashew')) return 'Nut/Dry Fruit';
    if (name.contains('cotton') || name.contains('jute')) return 'Fiber';
    return 'Commodity';
  }

  // --- Helper: Get Color based on Category ---
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Fruit':
        return Colors.orange;
      case 'Vegetable':
        return Colors.green;
      case 'Grain/Cereal':
        return Colors.amber;
      case 'Pulse/Legume':
        return Colors.brown;
      case 'Spice':
        return Colors.redAccent;
      case 'Fiber':
        return Colors.blueGrey;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final crop = _selectedCrop;
    final category = crop != null ? _getCategory(crop['name']!) : '';

    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 420,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header Row ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Market Insights',
                style: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Outfit',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Icon(Icons.analytics_outlined,
                  color: FlutterFlowTheme.of(context).primary, size: 20),
            ],
          ),
          SizedBox(height: 12),

          // --- Dropdown ---
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: FlutterFlowTheme.of(context).alternate,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCrop?['name'],
                hint: Text(
                  'Select a Crop...',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down_rounded,
                    color: FlutterFlowTheme.of(context).primary),
                items: _allCrops.map((c) {
                  return DropdownMenuItem<String>(
                    value: c['name'],
                    child: Text(
                      c['name']!,
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedCrop =
                        _allCrops.firstWhere((c) => c['name'] == val);
                  });
                },
              ),
            ),
          ),

          SizedBox(height: 16),

          // --- Main Content Area ---
          Expanded(
            child: crop == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: 0.3,
                          child: Icon(Icons.shopping_basket_outlined,
                              size: 60,
                              color: FlutterFlowTheme.of(context).primaryText),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Select a crop above to view\nmarket rates and details.',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Readex Pro',
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Title & Category Badge ---
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                crop['name']!,
                                style: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .override(
                                      fontFamily: 'Outfit',
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(category)
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _getCategoryColor(category)
                                      .withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                category,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: _getCategoryColor(category),
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // --- Data Grid ---
                        Row(
                          children: [
                            // Price Box (Large)
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF1F8E9), // Light Green
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.green.shade200),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.sell,
                                            size: 16, color: Colors.green[800]),
                                        SizedBox(width: 4),
                                        Text('Market Rate',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.green[800])),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      crop['price']!,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.green[900]),
                                    ),
                                    Text('per unit (est)',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.green[700])),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            // Season Box
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFF3E0), // Light Orange
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.orange.shade200),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.wb_sunny,
                                            size: 16,
                                            color: Colors.orange[800]),
                                        SizedBox(width: 4),
                                        Text('Season',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.orange[800])),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      crop['season']!,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange[900]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10),

                        // Nutrient/Info Box
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0xFFE3F2FD), // Light Blue
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.health_and_safety,
                                    color: Colors.blue, size: 20),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Key Nutrients',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue[800]),
                                    ),
                                    Text(
                                      crop['nutrients'] ?? '—',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue[900]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16),

                        // --- Farmer's Note (Filling Space) ---
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.lightbulb_outline,
                                  size: 18, color: Colors.amber[700]),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Did you know? ${crop['name']} prices often fluctuate during the ${crop['season']} harvest. Monitor local mandi rates for the best selling time.",
                                  style: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        lineHeight:
                                            1.4, // Replaced height with lineHeight
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
