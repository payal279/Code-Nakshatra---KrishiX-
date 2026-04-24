import '/components/guide1_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'guide_widget.dart' show GuideWidget;
import 'package:flutter/material.dart';

class GuideModel extends FlutterFlowModel<GuideWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for guide1 component.
  late Guide1Model guide1Model;

  @override
  void initState(BuildContext context) {
    guide1Model = createModel(context, () => Guide1Model());
  }

  @override
  void dispose() {
    guide1Model.dispose();
  }
}
