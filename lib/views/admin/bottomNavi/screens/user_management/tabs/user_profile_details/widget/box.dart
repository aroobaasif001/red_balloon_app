import 'package:flutter/material.dart';

import '../../../../../../../../utils/colors.dart';

BoxDecoration box() => BoxDecoration(
  color: whiteColor,
  borderRadius: BorderRadius.circular(16),
  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
);
