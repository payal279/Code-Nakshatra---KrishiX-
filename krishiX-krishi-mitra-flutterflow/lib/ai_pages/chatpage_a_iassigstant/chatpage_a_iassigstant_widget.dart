import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'chatpage_a_iassigstant_model.dart';
export 'chatpage_a_iassigstant_model.dart';

class ChatpageAIassigstantWidget extends StatefulWidget {
  const ChatpageAIassigstantWidget({super.key});

  static String routeName = 'chatpageAIassigstant';
  static String routePath = '/chatpageAIassigstant';

  @override
  State<ChatpageAIassigstantWidget> createState() =>
      _ChatpageAIassigstantWidgetState();
}

class _ChatpageAIassigstantWidgetState
    extends State<ChatpageAIassigstantWidget> {
  late ChatpageAIassigstantModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatpageAIassigstantModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'chatpageAIassigstant'});
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ApisRecord>>(
      stream: queryApisRecord(
        singleRecord: true,
      ),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        List<ApisRecord> chatpageAIassigstantApisRecordList = snapshot.data!;
        // Return an empty Container when the item does not exist.
        if (snapshot.data!.isEmpty) {
          return Container();
        }
        final chatpageAIassigstantApisRecord =
            chatpageAIassigstantApisRecordList.isNotEmpty
                ? chatpageAIassigstantApisRecordList.first
                : null;

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
              child: Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 0.9,
                child: custom_widgets.GeminiChatbotWidget(
                  width: MediaQuery.sizeOf(context).width * 1.0,
                  height: MediaQuery.sizeOf(context).height * 0.9,
                  geminiApiKey: chatpageAIassigstantApisRecord!.chatbotAPI,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
