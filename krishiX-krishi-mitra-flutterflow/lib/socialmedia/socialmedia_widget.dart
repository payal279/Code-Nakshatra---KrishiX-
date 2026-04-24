import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'socialmedia_model.dart';
export 'socialmedia_model.dart';

class SocialmediaWidget extends StatefulWidget {
  const SocialmediaWidget({super.key});

  static String routeName = 'socialmedia';
  static String routePath = '/socialmedia';

  @override
  State<SocialmediaWidget> createState() => _SocialmediaWidgetState();
}

class _SocialmediaWidgetState extends State<SocialmediaWidget> {
  late SocialmediaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SocialmediaModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'socialmedia'});
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 0.9,
                child: custom_widgets.FarmerSocialFeed(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 0.9,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
