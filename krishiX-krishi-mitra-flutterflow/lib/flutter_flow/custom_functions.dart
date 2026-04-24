import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

String? dailyMotivationEnglish() {
  // daily motivational and possitive Quate generator
  List<String> quotes = [
    "Believe you can and you're halfway there.",
    "The only way to do great work is to love what you do.",
    "Success is not the key to happiness. Happiness is the key to success.",
    "You are never too old to set another goal or to dream a new dream.",
    "Act as if what you do makes a difference. It does."
  ];

  // Generate a random index to select a quote
  int index = math.Random().nextInt(quotes.length);
  return quotes[index];
}

String? greetings() {
  // give greetings according to time
  DateTime now = DateTime.now();
  int hour = now.hour;

  if (hour < 12) {
    return "Good Morning!";
  } else if (hour < 17) {
    return "Good Afternoon!";
  } else {
    return "Good Evening!";
  }
}
