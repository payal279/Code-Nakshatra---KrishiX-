import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '/components/guide1_widget.dart';

// Focus widget keys for this walkthrough
final containerSp8ujcnd = GlobalKey();
final containerRgven7df = GlobalKey();
final containerTmvtbkeq = GlobalKey();

/// guide
///
///
List<TargetFocus> createWalkthroughTargets(BuildContext context) => [
      /// crop check
      TargetFocus(
        keyTarget: containerSp8ujcnd,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, __) => Guide1Widget(
              title: 'AI Crop Doctor:',
              description:
                  'This feature provides a real-time health check for crops, likely using AI to diagnose problems.',
            ),
          ),
        ],
      ),

      /// crop stage
      TargetFocus(
        keyTarget: containerRgven7df,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.Circle,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, __) => Guide1Widget(
              title: 'Crop Stage Explorer',
              description:
                  'This tool helps users understand crop stages and provides information about available subsidies and benefits.',
            ),
          ),
        ],
      ),

      /// market
      TargetFocus(
        keyTarget: containerTmvtbkeq,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.Circle,
        color: Colors.black,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, __) => Guide1Widget(
              title: 'Market Price',
              description:
                  ' This feature gives users access to live commodity rates.',
            ),
          ),
        ],
      ),
    ];
