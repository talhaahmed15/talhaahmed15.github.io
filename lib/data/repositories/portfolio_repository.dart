import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/portfolio_data.dart';

class PortfolioRepository {
  const PortfolioRepository();

  Future<PortfolioData> load() async {
    final text = await rootBundle.loadString('assets/data/site.json');
    final map = jsonDecode(text) as Map<String, dynamic>;
    return PortfolioData.fromMap(map);
  }
}
