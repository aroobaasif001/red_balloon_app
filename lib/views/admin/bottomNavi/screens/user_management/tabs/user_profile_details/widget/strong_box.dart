import 'package:flutter/material.dart';

import '../../../../../../../../utils/colors.dart';

BoxDecoration strongBox() => BoxDecoration(
  color: white2Color,
  borderRadius: BorderRadius.circular(20),
  boxShadow: [
    BoxShadow(
      color: blackColor.withOpacity(0.25),
      blurRadius: 4,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ],
);
