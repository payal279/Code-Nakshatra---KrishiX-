import '/components/guide1_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'guide_model.dart';
export 'guide_model.dart';

/// Create a component thats help me to create a app walkthrough
///
class GuideWidget extends StatefulWidget {
  const GuideWidget({super.key});

  @override
  State<GuideWidget> createState() => _GuideWidgetState();
}

class _GuideWidgetState extends State<GuideWidget> {
  late GuideModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GuideModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return wrapWithModel(
      model: _model.guide1Model,
      updateCallback: () => safeSetState(() {}),
      child: Guide1Widget(),
    );
  }
}
