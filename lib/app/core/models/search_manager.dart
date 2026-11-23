import 'dart:async';
import 'package:flutter/material.dart';

class SearchManager {
  final Duration debounceDuration;
  Timer? _timer;

  SearchManager({this.debounceDuration = const Duration(milliseconds: 400)});

  void onQueryChanged(String query, ValueChanged<String> onSearch) {
    _timer?.cancel();
    _timer = Timer(debounceDuration, () {
      onSearch(query.trim());
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}
