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

class KeralaPlantingCalendar extends StatefulWidget {
  const KeralaPlantingCalendar({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _KeralaPlantingCalendarState createState() => _KeralaPlantingCalendarState();
}

class _KeralaPlantingCalendarState extends State<KeralaPlantingCalendar> {
  String selectedView = 'month'; // month, season, crop, region
  int currentMonth = DateTime.now().month;
  String selectedSeason = 'all';
  String selectedCrop = 'all';
  String selectedRegion = 'all';

  // Kerala regions
  final List<String> keralaRegions = [
    'all',
    'coastal',
    'midland',
    'highland',
  ];

  final Map<String, String> regionNames = {
    'all': 'All Regions',
    'coastal': 'Coastal Plains',
    'midland': 'Midlands',
    'highland': 'Highlands',
  };

  // Kerala seasons based on monsoons
  final Map<String, SeasonData> keralaSeasons = {
    'pre_monsoon': SeasonData(
      name: 'Pre-Monsoon',
      malayalamName: 'ഗ്രീഷ്മകാലം',
      months: [3, 4, 5],
      description: 'Hot and humid, prepare for monsoon crops',
      color: Colors.orange,
      icon: Icons.wb_sunny,
    ),
    'sw_monsoon': SeasonData(
      name: 'Southwest Monsoon',
      malayalamName: 'തെക്കൻ പടിഞ്ഞാറൻ കാലവർഷം',
      months: [6, 7, 8, 9],
      description: 'Main rainy season, ideal for rice and vegetables',
      color: Colors.blue,
      icon: Icons.thunderstorm,
    ),
    'post_monsoon': SeasonData(
      name: 'Post-Monsoon',
      malayalamName: 'ശരത്കാലം',
      months: [10, 11],
      description: 'Retreating monsoon, second crop season',
      color: Colors.green,
      icon: Icons.cloud,
    ),
    'winter': SeasonData(
      name: 'Winter/Dry Season',
      malayalamName: 'ശൈത്യകാലം',
      months: [12, 1, 2],
      description: 'Cool and dry, harvest season',
      color: Colors.purple,
      icon: Icons.ac_unit,
    ),
  };

  // Comprehensive Kerala crop database
  final Map<String, CropData> keralaCrops = {
    // Rice varieties
    'rice_viruppu': CropData(
      name: 'Rice (Viruppu)',
      malayalamName: 'നെൽ (വിറുപ്പ്)',
      category: 'cereals',
      plantingMonths: [6, 7],
      harvestMonths: [11, 12],
      duration: '120-150 days',
      regions: ['coastal', 'midland'],
      season: 'sw_monsoon',
      tips: 'Main crop, plant with onset of SW monsoon. Prepare fields in May.',
      varieties: ['Jyothi', 'Pavizham', 'Swetha', 'IR 64'],
    ),
    'rice_mundakan': CropData(
      name: 'Rice (Mundakan)',
      malayalamName: 'നെൽ (മുണ്ടകൻ)',
      category: 'cereals',
      plantingMonths: [12, 1],
      harvestMonths: [4, 5],
      duration: '105-120 days',
      regions: ['coastal', 'midland'],
      season: 'winter',
      tips: 'Second crop, requires irrigation. Plant in well-prepared fields.',
      varieties: ['Jaya', 'IR 36', 'Bhadra'],
    ),
    'tomato': CropData(
      name: 'Tomato',
      malayalamName: 'തക്കാളി',
      category: 'vegetables',
      plantingMonths: [10, 11, 12, 1],
      harvestMonths: [1, 2, 3, 4],
      duration: '90-120 days',
      regions: ['midland', 'highland'],
      season: 'post_monsoon',
      tips:
          'Plant after monsoon, needs well-drained soil. Stake plants for support.',
      varieties: ['Pusa Ruby', 'Arka Vikas', 'Hisar Arun'],
    ),
    'okra': CropData(
      name: 'Okra (Ladies Finger)',
      malayalamName: 'വെണ്ടക്ക',
      category: 'vegetables',
      plantingMonths: [3, 4, 10, 11],
      harvestMonths: [5, 6, 12, 1],
      duration: '60-70 days',
      regions: ['coastal', 'midland', 'highland'],
      season: 'pre_monsoon',
      tips: 'Heat tolerant crop. Plant in raised beds during monsoon season.',
      varieties: ['Pusa Sawani', 'Arka Anamika', 'CO 4'],
    ),
    'pepper': CropData(
      name: 'Black Pepper',
      malayalamName: 'കുരുമുളക്',
      category: 'spices',
      plantingMonths: [5, 6],
      harvestMonths: [12, 1, 2],
      duration: '3-4 years to bear',
      regions: ['midland', 'highland'],
      season: 'pre_monsoon',
      tips: 'Plant before monsoon. Needs support tree. Perennial crop.',
      varieties: ['Panniyur 1', 'Karimunda', 'Subhakara'],
    ),
    'coconut': CropData(
      name: 'Coconut',
      malayalamName: 'തേങ്ങ',
      category: 'plantation',
      plantingMonths: [5, 6, 9, 10],
      harvestMonths: [60], // After 5+ years
      duration: '5-6 years to bear',
      regions: ['coastal', 'midland'],
      season: 'pre_monsoon',
      tips: 'State crop of Kerala. Plant with onset of rains.',
      varieties: ['West Coast Tall', 'Laccadive Ordinary', 'Dwarf varieties'],
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 700,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildViewSelector(),
          _buildFilters(),
          Expanded(child: _buildContent()),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.green.shade800],
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.calendar_month,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kerala Planting Calendar',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        fontFamily: 'Outfit',
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  'കേരള കൃഷി കലണ്ടർ',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Readex Pro',
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getCurrentMonthName(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildViewButton('month', 'Monthly', Icons.calendar_view_month),
            const SizedBox(width: 8),
            _buildViewButton('season', 'Seasonal', Icons.wb_sunny),
            const SizedBox(width: 8),
            _buildViewButton('crop', 'By Crop', Icons.agriculture),
            const SizedBox(width: 8),
            _buildViewButton('region', 'By Region', Icons.location_on),
          ],
        ),
      ),
    );
  }

  Widget _buildViewButton(String viewKey, String label, IconData icon) {
    bool isSelected = selectedView == viewKey;
    return InkWell(
      onTap: () => setState(() => selectedView = viewKey),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context).secondaryBackground,
          border: Border.all(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? Colors.white
                  : FlutterFlowTheme.of(context).primaryText,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    fontFamily: 'Readex Pro',
                    color: isSelected
                        ? Colors.white
                        : FlutterFlowTheme.of(context).primaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (selectedView == 'month') _buildMonthSelector(),
          if (selectedView != 'month') ...[
            Row(
              children: [
                Expanded(child: _buildRegionFilter()),
                const SizedBox(width: 8),
                if (selectedView == 'crop')
                  Expanded(child: _buildCropCategoryFilter()),
              ],
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(12, (index) {
          int month = index + 1;
          bool isSelected = currentMonth == month;
          bool isCurrentMonth = DateTime.now().month == month;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () => setState(() => currentMonth = month),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? FlutterFlowTheme.of(context).primary
                      : (isCurrentMonth
                          ? FlutterFlowTheme.of(context).accent1
                          : FlutterFlowTheme.of(context).secondaryBackground),
                  border: Border.all(
                    color: isCurrentMonth
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).alternate,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _getMonthName(month).substring(0, 3),
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : FlutterFlowTheme.of(context).primaryText,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRegionFilter() {
    return DropdownButtonFormField<String>(
      value: selectedRegion,
      decoration: InputDecoration(
        labelText: 'Region',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: keralaRegions.map((region) {
        return DropdownMenuItem(
          value: region,
          child: Text(
            regionNames[region] ?? region,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (value) => setState(() => selectedRegion = value!),
    );
  }

  Widget _buildCropCategoryFilter() {
    List<String> categories = [
      'all',
      'cereals',
      'vegetables',
      'spices',
      'plantation',
    ];

    return DropdownButtonFormField<String>(
      value: selectedCrop,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: categories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(
            category == 'all' ? 'All Categories' : category.toUpperCase(),
            style: const TextStyle(fontSize: 12),
          ),
        );
      }).toList(),
      onChanged: (value) => setState(() => selectedCrop = value!),
    );
  }

  Widget _buildContent() {
    switch (selectedView) {
      case 'month':
        return _buildMonthlyView();
      case 'season':
        return _buildSeasonalView();
      case 'crop':
        return _buildCropView();
      case 'region':
        return _buildRegionalView();
      default:
        return _buildMonthlyView();
    }
  }

  Widget _buildMonthlyView() {
    List<CropData> currentMonthCrops = keralaCrops.values.where((crop) {
      bool matchesMonth = crop.plantingMonths.contains(currentMonth);
      bool matchesRegion =
          selectedRegion == 'all' || crop.regions.contains(selectedRegion);
      return matchesMonth && matchesRegion;
    }).toList();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.calendar_today,
                  color: FlutterFlowTheme.of(context).primary),
              const SizedBox(width: 8),
              Text(
                '${_getMonthName(currentMonth)} Planting Guide',
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
        Expanded(
          child: currentMonthCrops.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info_outline,
                          size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'No major planting activities\nrecommended for ${_getMonthName(currentMonth)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: currentMonthCrops.length,
                  itemBuilder: (context, index) {
                    return _buildCropCard(currentMonthCrops[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSeasonalView() {
    List<MapEntry<String, SeasonData>> seasonEntries =
        keralaSeasons.entries.toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: seasonEntries.length,
      itemBuilder: (context, index) {
        MapEntry<String, SeasonData> entry = seasonEntries[index];
        String seasonKey = entry.key;
        SeasonData season = entry.value;

        List<CropData> seasonCrops = keralaCrops.values.where((crop) {
          return crop.season == seasonKey &&
              (selectedRegion == 'all' ||
                  crop.regions.contains(selectedRegion));
        }).toList();

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            leading: Icon(season.icon, color: season.color),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  season.name,
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Readex Pro',
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  season.malayalamName,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
              ],
            ),
            subtitle: Text(
              '${_getMonthNames(season.months)} • ${seasonCrops.length} crops',
              style: FlutterFlowTheme.of(context).bodySmall,
            ),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      season.description,
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    ...seasonCrops
                        .map((crop) => _buildCompactCropCard(crop))
                        .toList(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCropView() {
    List<CropData> filteredCrops = keralaCrops.values.where((crop) {
      bool matchesCategory =
          selectedCrop == 'all' || crop.category == selectedCrop;
      bool matchesRegion =
          selectedRegion == 'all' || crop.regions.contains(selectedRegion);
      return matchesCategory && matchesRegion;
    }).toList();

    // Group by category
    Map<String, List<CropData>> groupedCrops = {};
    for (CropData crop in filteredCrops) {
      groupedCrops.putIfAbsent(crop.category, () => []).add(crop);
    }

    List<MapEntry<String, List<CropData>>> groupEntries =
        groupedCrops.entries.toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groupEntries.length,
      itemBuilder: (context, index) {
        MapEntry<String, List<CropData>> entry = groupEntries[index];
        String category = entry.key;
        List<CropData> crops = entry.value;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            leading: Icon(_getCategoryIcon(category),
                color: _getCategoryColor(category)),
            title: Text(
              category.toUpperCase(),
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'Readex Pro',
                    fontWeight: FontWeight.w600,
                  ),
            ),
            subtitle: Text('${crops.length} crops'),
            children:
                crops.map((crop) => _buildDetailedCropCard(crop)).toList(),
          ),
        );
      },
    );
  }

  Widget _buildRegionalView() {
    Map<String, List<CropData>> regionalCrops = {};

    for (String region in keralaRegions.skip(1)) {
      regionalCrops[region] = keralaCrops.values.where((crop) {
        return crop.regions.contains(region);
      }).toList();
    }

    List<MapEntry<String, List<CropData>>> regionalEntries =
        regionalCrops.entries.toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: regionalEntries.length,
      itemBuilder: (context, index) {
        MapEntry<String, List<CropData>> entry = regionalEntries[index];
        String region = entry.key;
        List<CropData> crops = entry.value;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            leading: Icon(Icons.location_on, color: _getRegionColor(region)),
            title: Text(
              regionNames[region] ?? region,
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    fontFamily: 'Readex Pro',
                    fontWeight: FontWeight.w600,
                  ),
            ),
            subtitle: Text('${crops.length} suitable crops'),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getRegionDescription(region),
                      style: FlutterFlowTheme.of(context).bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    ...crops
                        .map((crop) => _buildCompactCropCard(crop))
                        .toList(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCropCard(CropData crop) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(crop.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(crop.category),
                    color: _getCategoryColor(crop.category),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crop.name,
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  fontFamily: 'Readex Pro',
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      Text(
                        crop.malayalamName,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Readex Pro',
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).accent1,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    crop.category.toUpperCase(),
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildInfoChip(
                    icon: Icons.schedule,
                    label: 'Duration',
                    value: crop.duration,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInfoChip(
                    icon: Icons.location_on,
                    label: 'Regions',
                    value: '${crop.regions.length} zones',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInfoChip(
                    icon: Icons.calendar_today,
                    label: 'Plant',
                    value: _getMonthNames(crop.plantingMonths),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInfoChip(
                    icon: Icons.agriculture,
                    label: 'Harvest',
                    value: _getMonthNames(crop.harvestMonths),
                  ),
                ),
              ],
            ),
            if (crop.tips.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).accent4.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).accent4,
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color: FlutterFlowTheme.of(context).warning,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        crop.tips,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Readex Pro',
                              fontSize: 12,
                              lineHeight: 1.4,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCropCard(CropData crop) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Row(
        children: [
          Icon(
            _getCategoryIcon(crop.category),
            color: _getCategoryColor(crop.category),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${crop.name} (${crop.malayalamName})',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                ),
                Text(
                  'Plant: ${_getMonthNames(crop.plantingMonths)} • ${crop.duration}',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Readex Pro',
                        fontSize: 10,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedCropCard(CropData crop) {
    return ExpansionTile(
      leading: Icon(
        _getCategoryIcon(crop.category),
        color: _getCategoryColor(crop.category),
        size: 20,
      ),
      title: Text(
        crop.name,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Readex Pro',
              fontWeight: FontWeight.w500,
            ),
      ),
      subtitle: Text(
        '${crop.malayalamName} • ${_getMonthNames(crop.plantingMonths)}',
        style: FlutterFlowTheme.of(context).bodySmall,
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildDetailInfo(
                        'Duration', crop.duration, Icons.schedule),
                  ),
                  Expanded(
                    child: _buildDetailInfo(
                        'Season', _getSeasonName(crop.season), Icons.wb_sunny),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailInfo('Plant',
                        _getMonthNames(crop.plantingMonths), Icons.eco),
                  ),
                  Expanded(
                    child: _buildDetailInfo('Harvest',
                        _getMonthNames(crop.harvestMonths), Icons.agriculture),
                  ),
                ],
              ),
              if (crop.tips.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Tips:',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  crop.tips,
                  style: FlutterFlowTheme.of(context).bodySmall,
                ),
              ],
              if (crop.varieties.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Varieties: ${crop.varieties.join(", ")}',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Readex Pro',
                        fontSize: 11,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: FlutterFlowTheme.of(context).alternate),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 16,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: FlutterFlowTheme.of(context).secondaryText,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 10,
              color: FlutterFlowTheme.of(context).primaryText,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailInfo(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: FlutterFlowTheme.of(context).secondaryText),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: FlutterFlowTheme.of(context).secondaryText,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        border: Border(
          top: BorderSide(
            color: FlutterFlowTheme.of(context).alternate,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            color: FlutterFlowTheme.of(context).secondaryText,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            'Kerala Agricultural Calendar • Based on traditional farming practices',
            style: TextStyle(
              fontSize: 10,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _getCurrentMonthName() {
    return _getMonthName(DateTime.now().month);
  }

  String _getMonthName(int month) {
    if (month < 1 || month > 12) return 'Invalid';
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  String _getMonthNames(List<int> months) {
    if (months.isEmpty) return 'N/A';
    if (months.length == 1) {
      return _getMonthName(months[0]).substring(0, 3);
    }
    return months.map((m) => _getMonthName(m).substring(0, 3)).join(', ');
  }

  String _getSeasonName(String seasonKey) {
    return keralaSeasons[seasonKey]?.name ?? seasonKey;
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'cereals':
        return Icons.grain;
      case 'vegetables':
        return Icons.eco;
      case 'spices':
        return Icons.local_florist;
      case 'plantation':
        return Icons.forest;
      case 'fruits':
        return Icons.apple;
      case 'pulses':
        return Icons.feed;
      default:
        return Icons.agriculture;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'cereals':
        return Colors.amber;
      case 'vegetables':
        return Colors.green;
      case 'spices':
        return Colors.orange;
      case 'plantation':
        return Colors.brown;
      case 'fruits':
        return Colors.red;
      case 'pulses':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getRegionColor(String region) {
    switch (region) {
      case 'coastal':
        return Colors.blue;
      case 'midland':
        return Colors.green;
      case 'highland':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  String _getRegionDescription(String region) {
    switch (region) {
      case 'coastal':
        return 'Low-lying areas near the coast. Suitable for paddy cultivation, coconut, and aquaculture.';
      case 'midland':
        return 'Rolling hills and valleys. Mixed farming with rubber, pepper, vegetables, and rice.';
      case 'highland':
        return 'Western Ghats region. Cool climate suitable for spices and hill vegetables.';
      default:
        return '';
    }
  }
}

// Data classes
class SeasonData {
  final String name;
  final String malayalamName;
  final List<int> months;
  final String description;
  final Color color;
  final IconData icon;

  SeasonData({
    required this.name,
    required this.malayalamName,
    required this.months,
    required this.description,
    required this.color,
    required this.icon,
  });
}

class CropData {
  final String name;
  final String malayalamName;
  final String category;
  final List<int> plantingMonths;
  final List<int> harvestMonths;
  final String duration;
  final List<String> regions;
  final String season;
  final String tips;
  final List<String> varieties;

  CropData({
    required this.name,
    required this.malayalamName,
    required this.category,
    required this.plantingMonths,
    required this.harvestMonths,
    required this.duration,
    required this.regions,
    required this.season,
    required this.tips,
    required this.varieties,
  });
}
