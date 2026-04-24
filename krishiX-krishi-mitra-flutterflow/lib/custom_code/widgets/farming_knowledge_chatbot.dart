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

import 'package:flutter/services.dart';

class FarmingKnowledgeChatbot extends StatefulWidget {
  const FarmingKnowledgeChatbot({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _FarmingKnowledgeChatbotState createState() =>
      _FarmingKnowledgeChatbotState();
}

class _FarmingKnowledgeChatbotState extends State<FarmingKnowledgeChatbot> {
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> messages = [];
  String currentMenu = 'main';

  // Define all menu options and responses
  final Map<String, MenuData> menus = {
    'main': MenuData(
      title: '🌾 Welcome to Farming Assistant Help!',
      subtitle: 'Choose a category to get help:',
      options: [
        ChatOption(
            '📞 Contact & Support', 'contact_menu', Icons.contact_support),
        ChatOption('📱 App Features', 'features_menu', Icons.apps),
        ChatOption('🌱 Farming Tips', 'farming_menu', Icons.agriculture),
        ChatOption('🔧 Troubleshooting', 'troubleshoot_menu', Icons.build),
        ChatOption('❓ General Help', 'general_help', Icons.help),
      ],
    ),
    'contact_menu': MenuData(
      title: '📞 Contact & Support',
      subtitle: 'How can we assist you?',
      options: [
        ChatOption('📧 Get Contact Email', 'contact_email', Icons.email),
        ChatOption('🏢 Company Information', 'company_info', Icons.business),
        ChatOption('🎯 Technical Support', 'tech_support', Icons.support_agent),
        ChatOption('⏰ Response Times', 'response_times', Icons.schedule),
        ChatOption('🔙 Back to Main Menu', 'main', Icons.arrow_back),
      ],
    ),
    'features_menu': MenuData(
      title: '📱 App Features',
      subtitle: 'Learn about our app capabilities:',
      options: [
        ChatOption('🌟 All Features Overview', 'all_features', Icons.star),
        ChatOption('🌤️ Weather & Climate', 'weather_info', Icons.wb_sunny),
        ChatOption('🌾 Crop Management', 'crop_management', Icons.grass),
        ChatOption(
            '💧 Irrigation System', 'irrigation_system', Icons.water_drop),
        ChatOption('📊 Market Prices', 'market_prices', Icons.trending_up),
        ChatOption('🔙 Back to Main Menu', 'main', Icons.arrow_back),
      ],
    ),
    'farming_menu': MenuData(
      title: '🌱 Farming Tips & Guidance',
      subtitle: 'Get expert farming advice:',
      options: [
        ChatOption('💧 Irrigation Best Practices', 'irrigation_tips',
            Icons.water_drop),
        ChatOption('🧪 Fertilizer Guidance', 'fertilizer_tips', Icons.science),
        ChatOption(
            '🐛 Pest & Disease Control', 'pest_control', Icons.bug_report),
        ChatOption('🌱 Crop Selection Guide', 'crop_selection', Icons.eco),
        ChatOption('🌾 Harvesting Tips', 'harvesting_tips', Icons.agriculture),
        ChatOption(
            '📅 Seasonal Planning', 'seasonal_planning', Icons.calendar_today),
        ChatOption('🔙 Back to Main Menu', 'main', Icons.arrow_back),
      ],
    ),
    'troubleshoot_menu': MenuData(
      title: '🔧 Troubleshooting',
      subtitle: 'Solve common issues:',
      options: [
        ChatOption('🔐 Login Problems', 'login_help', Icons.login),
        ChatOption('📱 App Not Working', 'app_issues', Icons.smartphone),
        ChatOption('🌐 Connection Issues', 'connection_help', Icons.wifi_off),
        ChatOption('🔄 Update Problems', 'update_help', Icons.system_update),
        ChatOption('💾 Data Sync Issues', 'sync_help', Icons.sync_problem),
        ChatOption('🔙 Back to Main Menu', 'main', Icons.arrow_back),
      ],
    ),
  };

  // Define all responses
  final Map<String, String> responses = {
    'contact_email': '''📧 **Contact Information**

**Primary Contact:**
• Email: shaswat.developer@gmail.com
• Subject: [Farming App] - Your Query

**Best Times to Contact:**
• Monday - Friday: 9 AM - 6 PM IST
• Response within 24 hours

**What to Include:**
• Your app version
• Device information
• Detailed description of issue/query

We're here to help you succeed in farming! 🌾''',
    'company_info': '''🏢 **About Farming Assistant**

**Our Mission:**
Empowering farmers with technology for better yields and sustainable farming practices.

**What We Offer:**
• Smart farming solutions
• Weather-based recommendations
• Crop management tools
• Market insights
• Expert guidance

**Contact Details:**
📧 shaswat.developer@gmail.com
🌐 Serving farmers across India

**Founded:** To bridge the gap between traditional farming and modern technology.''',
    'tech_support': '''🎯 **Technical Support**

**For App Issues:**
📧 Email: shaswat.developer@gmail.com
📋 Subject: [URGENT] Technical Issue

**Before Contacting:**
✅ Try restarting the app
✅ Check internet connection
✅ Update to latest version
✅ Clear app cache

**Include in Your Email:**
• Phone model & OS version
• App version number
• Screenshots of the issue
• Steps that caused the problem

**Response Time:** Within 24 hours for technical issues.''',
    'response_times': '''⏰ **Our Response Times**

**Technical Issues:** 6-12 hours
**General Queries:** 12-24 hours
**Feature Requests:** 2-3 days
**Bug Reports:** 4-6 hours

**Priority Support:**
🔴 Critical bugs: Immediate
🟡 App crashes: Within 2 hours
🟢 Feature questions: Next business day

**Best Response Times:**
Monday - Friday, 9 AM - 6 PM IST

📧 shaswat.developer@gmail.com''',
    'all_features': '''🌟 **Complete App Features**

**🌤️ Weather Intelligence:**
• 7-day detailed forecasts
• Rainfall predictions
• Temperature alerts
• Humidity & wind data

**🌾 Crop Management:**
• Growth stage tracking
• Disease identification
• Yield predictions
• Harvest timing

**💧 Smart Irrigation:**
• Soil moisture monitoring
• Automated scheduling
• Water usage optimization

**🐛 Pest Control:**
• Early detection alerts
• Treatment recommendations
• Organic solutions

**📊 Market Insights:**
• Real-time crop prices
• Demand forecasting
• Best selling locations

**📱 More Features:**
• Offline access
• Multi-language support
• Expert consultation booking''',
    'weather_info': '''🌤️ **Weather & Climate Features**

**Daily Forecasts:**
🌡️ Temperature (Min/Max)
🌧️ Rainfall probability & amount
💨 Wind speed & direction
💧 Humidity levels
🌅 Sunrise/Sunset times

**Weekly Predictions:**
📅 7-day outlook
⛈️ Storm warnings
🌡️ Temperature trends
☔ Rainfall patterns

**Farming-Specific Alerts:**
🚨 Frost warnings
⚡ Lightning alerts
💨 High wind advisories
🌧️ Heavy rain predictions

**How It Helps:**
• Plan irrigation schedules
• Protect crops from weather damage
• Optimize planting times
• Schedule harvesting

**Data Sources:** Multiple meteorological services for accuracy.''',
    'crop_management': '''🌾 **Crop Management System**

**Crop Monitoring:**
📊 Growth stage tracking
📈 Health assessments
🔍 Disease early detection
📸 Photo-based analysis

**Supported Crops:**
🌾 Cereals: Rice, Wheat, Corn, Barley
🥬 Vegetables: Tomato, Potato, Onion, Cabbage
🍎 Fruits: Mango, Apple, Citrus, Banana
🌿 Cash Crops: Cotton, Sugarcane, Tea
🫛 Pulses: Lentils, Chickpeas, Beans

**Management Tools:**
📅 Planting calendars
💧 Watering schedules
🧪 Fertilizer recommendations
🐛 Pest control timing
📊 Yield predictions

**Smart Notifications:**
• Critical growth stages
• Disease outbreak alerts
• Optimal harvest timing
• Market price updates''',
    'irrigation_system': '''💧 **Smart Irrigation System**

**Soil Monitoring:**
🌱 Moisture level tracking
🌡️ Soil temperature
🧪 pH level monitoring
💧 Water retention analysis

**Automated Scheduling:**
⏰ Optimal watering times
💧 Precise water amounts
🌤️ Weather-based adjustments
📅 Seasonal modifications

**Water Management:**
💰 Usage tracking & costs
🔧 Efficiency optimization
🚰 Leak detection
📊 Performance analytics

**Irrigation Methods:**
🚿 Drip irrigation timing
💨 Sprinkler scheduling
🌊 Flood irrigation planning

**Benefits:**
• Save 30-40% water
• Improve crop yield
• Reduce labor costs
• Prevent over/under watering''',
    'market_prices': '''📊 **Market Price Intelligence**

**Real-Time Prices:**
💰 Current market rates
📈 Price trends (daily/weekly)
🏪 Local market comparison
🚚 Transportation costs

**Market Analytics:**
📊 Demand forecasting
🎯 Best selling locations
💹 Seasonal price patterns
📈 Profit margin calculations

**Supported Markets:**
🏪 Local mandis
🏢 Wholesale markets
🌐 Online platforms
🚚 Direct buyer connections

**Price Alerts:**
🔔 Target price notifications
📈 Sudden price changes
💰 Profit opportunity alerts
📅 Best selling time suggestions

**Crop Categories:**
All major crops with daily price updates from verified sources.

**Planning Benefits:**
• Maximize selling profits
• Plan crop selection
• Timing market entry''',
    'irrigation_tips': '''💧 **Irrigation Best Practices**

**Timing is Everything:**
🌅 Early morning (5-7 AM) - Best time
🌅 Evening (6-8 PM) - Second choice
❌ Avoid midday watering (water loss)

**Water Amount Guidelines:**
🌾 Cereals: 2-3 inches per week
🥬 Vegetables: 1-2 inches per week
🌿 Cash crops: Varies by growth stage
🍎 Fruit trees: Deep, less frequent

**Soil Moisture Check:**
✋ Finger test: 2-3 inches deep
🔧 Use moisture meters
👀 Visual plant stress signs

**Efficient Methods:**
💧 Drip irrigation: 90% efficiency
💨 Sprinklers: 75% efficiency
🌊 Flood irrigation: 60% efficiency

**Water Conservation:**
🍃 Mulching reduces evaporation
🌱 Choose drought-resistant varieties
🔄 Rainwater harvesting
⏰ Smart scheduling with our app!''',
    'fertilizer_tips': '''🧪 **Fertilizer Guidance**

**Soil Testing First:**
🔬 NPK levels check
🧪 pH level testing (6.0-7.5 ideal)
🌱 Organic matter content
💧 Nutrient availability

**NPK Ratios by Crop:**
🌾 Rice: 4-2-1 (N-P-K)
🌽 Corn: 3-1-2
🍅 Tomato: 2-3-1
🥔 Potato: 1-2-2

**Organic Options:**
🍂 Compost: Slow-release nutrients
🐄 Manure: Rich in nitrogen
🌿 Green manure: Nitrogen fixing
🦴 Bone meal: Phosphorus source

**Application Timing:**
🌱 Base: Before planting
📈 Top dressing: During growth
🌾 Foliar: Quick nutrient boost

**Signs of Deficiency:**
💛 Yellow leaves: Nitrogen
🟣 Purple stems: Phosphorus
🤎 Brown edges: Potassium

**Safety Tips:**
🧤 Use protective gear
💧 Don't over-fertilize
🌧️ Avoid before heavy rain''',
    'pest_control': '''🐛 **Integrated Pest Management**

**Early Detection:**
🔍 Daily crop inspection
📸 Photo documentation
🕒 Early morning checks
👀 Look for eggs, larvae, damage

**Common Pests by Crop:**
🌾 Rice: Stem borer, leaf folder
🌽 Corn: Armyworm, corn borer
🍅 Tomato: Whitefly, aphids
🥔 Potato: Colorado beetle

**Natural Predators:**
🐞 Ladybugs vs aphids
🕷️ Spiders vs small insects
🦅 Birds vs caterpillars
🐸 Frogs vs mosquitoes

**Organic Solutions:**
🌿 Neem oil spray
🧄 Garlic-chili solution
🧼 Soap water spray
🌸 Marigold companion planting

**Chemical Control (Last Resort):**
⚖️ Follow label instructions
🥽 Use protective equipment
⏰ Apply at right time
🌧️ Check weather conditions

**Prevention:**
✂️ Crop rotation
🚿 Clean irrigation
🍃 Remove crop debris
🌱 Resistant varieties''',
    'crop_selection': '''🌱 **Smart Crop Selection Guide**

**Consider Your Region:**
🌡️ Climate compatibility
🌧️ Rainfall requirements
🌍 Soil type suitability
📍 Local market demand

**Seasonal Crops:**
🌸 **Kharif** (June-Oct): Rice, Cotton, Sugarcane
❄️ **Rabi** (Nov-April): Wheat, Mustard, Gram
☀️ **Zaid** (March-June): Watermelon, Fodder

**High-Profit Crops:**
💰 Vegetables: Quick returns
🌿 Herbs: High value per acre
🍓 Berries: Premium prices
🌺 Flowers: Steady demand

**Low-Risk Crops:**
🌾 Cereals: Stable market
🫛 Pulses: Government support
🥬 Local vegetables: Sure sale

**Factors to Consider:**
💧 Water availability
👨‍🌾 Labor requirements
💰 Investment capacity
📊 Market accessibility
🚜 Machinery needs

**Our App Helps:**
📊 Profitability calculator
🌤️ Climate matching
📈 Market price trends''',
    'harvesting_tips': '''🌾 **Harvesting Best Practices**

**Timing Indicators:**
🌾 Grain crops: Moisture content 18-20%
🍅 Vegetables: Color, firmness
🍎 Fruits: Sugar content, aroma
🌿 Leafy: Before flowering

**Optimal Harvest Times:**
🌅 Early morning: Cool temperatures
☁️ Cloudy days: Reduced stress
❌ Avoid: After rain, hot afternoons

**Tools & Equipment:**
🔪 Sharp, clean cutting tools
🧤 Protective gloves
🧺 Proper containers
🚜 Mechanical harvesters for large farms

**Quality Preservation:**
❄️ Quick cooling for perishables
🧊 Cold chain maintenance
📦 Proper packaging
🚚 Fast transportation

**Post-Harvest Care:**
🧹 Clean harvested area
🔄 Prepare for next crop
📊 Record yield data
💰 Calculate profitability

**Storage Tips:**
🌡️ Right temperature
💧 Proper humidity
🌬️ Good ventilation
🐭 Pest protection

**Market Preparation:**
📏 Grading & sorting
🏷️ Proper labeling
📊 Quality certificates''',
    'seasonal_planning': '''📅 **Seasonal Farming Calendar**

**🌸 SUMMER (March-May):**
🌱 Plant: Watermelon, Cucumber, Fodder
🌾 Harvest: Rabi crops (Wheat, Mustard)
💧 Focus: Irrigation management
🔧 Prepare: Monsoon preparations

**🌧️ MONSOON (June-September):**
🌱 Plant: Rice, Cotton, Sugarcane, Pulses
🌿 Manage: Drainage, pest control
🌧️ Monitor: Rainfall, flooding
💊 Apply: Monsoon fertilizers

**🍂 POST-MONSOON (October-November):**
🌾 Harvest: Kharif crops
🌱 Plant: Rabi crops (Wheat, Gram)
🍃 Prepare: Soil for winter crops
📊 Plan: Marketing strategy

**❄️ WINTER (December-February):**
🌿 Manage: Rabi crops
💧 Irrigation: Moderate watering
🥶 Protect: Frost protection
🌾 Prepare: Summer crop planning

**Year-Round Activities:**
🔍 Regular monitoring
🧪 Soil health management
📚 Knowledge updating
📊 Record keeping

**Our App Features:**
📅 Automated reminders
🌤️ Weather-based suggestions
📊 Seasonal analytics''',
    'login_help': '''🔐 **Login Problem Solutions**

**Step-by-Step Troubleshooting:**

**1. Check Credentials:**
✅ Verify email address (no typos)
✅ Check password (case sensitive)
✅ Ensure caps lock is off

**2. Password Reset:**
🔄 Tap "Forgot Password"
📧 Check email (including spam)
🔗 Click reset link
🆕 Create strong new password

**3. Clear App Data:**
📱 Go to phone Settings
🔧 Find Farming Assistant app
🗑️ Clear Cache & Data
🔄 Restart app

**4. Update App:**
🏪 Check Google Play Store
⬇️ Update to latest version
🔄 Try logging in again

**5. Network Check:**
📶 Ensure stable internet
📡 Try different WiFi/mobile data
🌐 Test other apps

**Still Having Issues?**
📧 Email: shaswat.developer@gmail.com
📝 Include: Phone model, OS version, error message

**Account Security:**
🔐 Use strong passwords
📱 Enable 2-factor authentication
🚫 Don't share login details''',
    'app_issues': '''📱 **App Troubleshooting Guide**

**Common Issues & Solutions:**

**🔄 App Crashes:**
1. Force close and restart app
2. Restart your phone
3. Clear app cache
4. Update to latest version
5. Free up phone memory

**📶 Slow Performance:**
1. Close other running apps
2. Clear app cache
3. Check internet speed
4. Restart phone
5. Update app

**🔄 Features Not Loading:**
1. Check internet connection
2. Refresh the screen (pull down)
3. Log out and log back in
4. Clear app data
5. Reinstall app

**📊 Data Not Syncing:**
1. Ensure stable internet
2. Check account login status
3. Force sync in settings
4. Wait for automatic sync
5. Contact support

**📱 App Won't Open:**
1. Restart your phone
2. Check available storage
3. Update app from store
4. Reinstall the app
5. Check phone compatibility

**Need More Help?**
📧 shaswat.developer@gmail.com
📝 Include: Error details, phone model, what you were doing when issue occurred''',
    'connection_help': '''🌐 **Internet Connection Issues**

**Check Your Connection:**

**📱 Mobile Data:**
✅ Check data balance
📶 Ensure good signal strength
🔄 Turn airplane mode on/off
📍 Move to better coverage area

**📡 WiFi Connection:**
✅ Verify WiFi password
🔄 Restart WiFi router
📶 Check signal strength
🌐 Test other websites/apps

**🔧 Network Troubleshooting:**
1. Restart your phone
2. Forget and reconnect WiFi
3. Clear network settings cache
4. Try different network
5. Contact internet provider

**🔍 App-Specific Issues:**
• Close and restart app
• Check app permissions
• Clear app cache
• Update app version
• Try different network

**📊 Data Usage Optimization:**
• Enable data saver mode
• Use WiFi when possible
• Download offline content
• Compress data in settings

**Speed Requirements:**
• Minimum: 1 Mbps
• Recommended: 5+ Mbps
• For video features: 10+ Mbps

**Still No Connection?**
📧 Contact us: shaswat.developer@gmail.com''',
    'update_help': '''🔄 **App Update Issues**

**Automatic Updates:**

**📲 Google Play Store:**
1. Open Play Store
2. Search "Farming Assistant"
3. Tap "Update" if available
4. Wait for download completion
5. Open updated app

**⚙️ Enable Auto-Updates:**
1. Open Play Store
2. Go to Settings
3. Select "Auto-update apps"
4. Choose "Over Wi-Fi only"

**🚨 Update Problems:**

**❌ Update Failed:**
• Clear Play Store cache
• Check available storage
• Restart phone
• Try using WiFi
• Uninstall & reinstall

**⏳ Update Stuck:**
• Pause and resume download
• Clear Play Store data
• Restart phone
• Check internet speed

**💾 Storage Issues:**
• Delete unnecessary files
• Move photos to cloud
• Clear app caches
• Remove unused apps

**🔍 Can't Find Update:**
• Refresh Play Store
• Check if auto-update is on
• Manually search for app
• Check compatibility

**📱 Version Compatibility:**
• Android 6.0 or higher
• 2GB RAM minimum
• 500MB storage space

**Need Help?**
📧 shaswat.developer@gmail.com''',
    'sync_help': '''💾 **Data Sync Issues**

**Understanding Sync:**
🔄 Sync keeps your data updated across devices
☁️ Data is stored securely in cloud
📊 Includes crops, weather, market data

**Manual Sync:**
1. Open app settings
2. Find "Sync Data" option
3. Tap to force sync
4. Wait for completion
5. Check if data updated

**Auto-Sync Settings:**
⚙️ Go to app settings
🔄 Enable "Auto Sync"
📶 Choose WiFi only or mobile data
⏰ Set sync frequency (hourly/daily)

**Common Sync Problems:**

**📶 Network Issues:**
• Check internet connection
• Switch between WiFi/mobile
• Move to better signal area

**🔐 Account Issues:**
• Verify login status
• Re-login to account
• Check account permissions

**📊 Data Conflicts:**
• Choose which data to keep
• Resolve conflicts manually
• Contact support for help

**💾 Storage Full:**
• Free up device storage
• Clear old cache data
• Delete unnecessary files

**⏰ Last Sync Status:**
Check settings to see when last sync occurred

**Backup Your Data:**
📤 Regular manual backups
☁️ Cloud storage enabled
📋 Export important records

**Emergency Contact:**
📧 shaswat.developer@gmail.com''',
    'general_help': '''❓ **General Help & Support**

**🎯 How Can We Assist You?**

**📚 Getting Started:**
• Download and install app
• Create your farmer profile
• Add your crops and fields
• Set up notifications
• Explore all features

**🌟 Popular Features:**
• Weather forecasts
• Crop management
• Market prices
• Irrigation scheduling
• Pest identification

**📱 Using the App:**
• Navigate through menus
• Add/edit crop information
• Set up alerts and reminders
• Access offline features
• Sync data across devices

**🤝 Community Support:**
• Connect with other farmers
• Share farming experiences
• Get expert advice
• Access video tutorials
• Join webinars and workshops

**📧 Contact Methods:**
**Primary:** shaswat.developer@gmail.com
**Response Time:** 24 hours
**Best Time:** Monday-Friday, 9 AM-6 PM IST

**🆘 Emergency Support:**
For critical farming emergencies, mark email as [URGENT]

**📖 Additional Resources:**
• In-app help sections
• Video tutorials
• Farming best practices
• Seasonal guides
• Market insights

**🔄 Stay Updated:**
• Enable app notifications
• Follow our updates
• Subscribe to newsletters
• Join farmer communities

We're here to make your farming journey successful! 🌾''',
  };

  @override
  void initState() {
    super.initState();
    _showWelcomeMessage();
  }

  void _showWelcomeMessage() {
    final welcomeMenu = menus[currentMenu]!;
    messages.add(ChatMessage(
      text: '${welcomeMenu.title}\n\n${welcomeMenu.subtitle}',
      isUser: false,
      timestamp: DateTime.now(),
      showOptions: true,
      options: welcomeMenu.options,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 600,
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
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  FlutterFlowTheme.of(context).primary,
                  FlutterFlowTheme.of(context).secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.support_agent,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Farming Assistant Help',
                        style:
                            FlutterFlowTheme.of(context).headlineSmall.override(
                                  fontFamily: 'Outfit',
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      Text(
                        'Choose options to get help',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Readex Pro',
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                ),
                if (currentMenu != 'main')
                  IconButton(
                    onPressed: () => _selectOption('main'),
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),

          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(
                  message: messages[index],
                  onOptionSelected: _selectOption,
                  onCopy: _copyToClipboard,
                );
              },
            ),
          ),

          // Footer
          Container(
            padding: EdgeInsets.all(12),
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
                  Icons.email,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  'Contact: shaswat.developer@gmail.com',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Readex Pro',
                        fontSize: 11,
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

  void _selectOption(String optionKey) {
    // Add user selection message
    final selectedOption = _findOptionByKey(optionKey);
    if (selectedOption != null) {
      setState(() {
        messages.add(ChatMessage(
          text: selectedOption.text,
          isUser: true,
          timestamp: DateTime.now(),
        ));
      });
    }

    // Handle the selection
    Future.delayed(Duration(milliseconds: 300), () {
      if (menus.containsKey(optionKey)) {
        // Show new menu
        _showMenu(optionKey);
      } else if (responses.containsKey(optionKey)) {
        // Show response
        _showResponse(optionKey);
      }
      _scrollToBottom();
    });
  }

  ChatOption? _findOptionByKey(String key) {
    for (MenuData menu in menus.values) {
      for (ChatOption option in menu.options) {
        if (option.key == key) {
          return option;
        }
      }
    }
    return null;
  }

  void _showMenu(String menuKey) {
    currentMenu = menuKey;
    final menu = menus[menuKey]!;

    setState(() {
      messages.add(ChatMessage(
        text: '${menu.title}\n\n${menu.subtitle}',
        isUser: false,
        timestamp: DateTime.now(),
        showOptions: true,
        options: menu.options,
      ));
    });
  }

  void _showResponse(String responseKey) {
    final response = responses[responseKey]!;

    setState(() {
      messages.add(ChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
        showOptions: true,
        options: [
          ChatOption('🔙 Back to Main Menu', 'main', Icons.home),
          ChatOption('📧 Contact Support', 'contact_email', Icons.email),
        ],
      ));
    });
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _copyToClipboard(String text) {
    // Remove markdown formatting for clipboard
    String cleanText = text
        .replaceAll(RegExp(r'\*\*([^*]+)\*\*'), r'$1')
        .replaceAll(RegExp(r'#{1,6}\s'), '')
        .replaceAll(RegExp(r'[•✅❌🔴🟡🟢📧📱🌾💧🐛🔧⏰📊🌟]'), '')
        .trim();

    Clipboard.setData(ClipboardData(text: cleanText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Copied to clipboard!'),
          ],
        ),
        backgroundColor: FlutterFlowTheme.of(context).success,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class MenuData {
  final String title;
  final String subtitle;
  final List<ChatOption> options;

  MenuData({
    required this.title,
    required this.subtitle,
    required this.options,
  });
}

class ChatOption {
  final String text;
  final String key;
  final IconData icon;

  ChatOption(this.text, this.key, this.icon);
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool showOptions;
  final List<ChatOption>? options;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.showOptions = false,
    this.options,
  });
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final Function(String) onOptionSelected;
  final Function(String) onCopy;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.onOptionSelected,
    required this.onCopy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chat bubble
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!message.isUser) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        FlutterFlowTheme.of(context).primary,
                        FlutterFlowTheme.of(context).secondary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.support_agent,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                SizedBox(width: 8),
              ],
              Flexible(
                child: GestureDetector(
                  onLongPress: () => onCopy(message.text),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? FlutterFlowTheme.of(context).primary
                          : FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: message.isUser
                          ? null
                          : Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Readex Pro',
                                color: message.isUser
                                    ? Colors.white
                                    : FlutterFlowTheme.of(context).primaryText,
                                lineHeight: 1.4,
                              ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          DateFormat('HH:mm').format(message.timestamp),
                          style:
                              FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'Readex Pro',
                                    color: message.isUser
                                        ? Colors.white70
                                        : FlutterFlowTheme.of(context)
                                            .secondaryText,
                                    fontSize: 10,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (message.isUser) ...[
                SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).accent1,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.person,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 18,
                  ),
                ),
              ],
            ],
          ),

          // Option buttons
          if (message.showOptions && message.options != null) ...[
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.only(left: message.isUser ? 0 : 40),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: message.options!.map((option) {
                  return InkWell(
                    onTap: () => onOptionSelected(option.key),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).primary,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            option.icon,
                            size: 16,
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                          SizedBox(width: 6),
                          Text(
                            option.text,
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color: FlutterFlowTheme.of(context).primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
