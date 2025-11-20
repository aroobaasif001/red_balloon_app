import 'package:flutter/material.dart';
import 'package:red_balloon_app/utils/colors.dart';

Widget buildHeading(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: redColor,
      ),
    ),
  );
}

Widget buildSubHeading(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 4),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: textColor2,
      ),
    ),
  );
}

Widget buildBodyText(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        height: 1.5,
        color: grey5Color,
      ),
    ),
  );
}

Widget buildBodyRichText(
  String startText, {
  String? boldWord,
  String? endText,
  String? boldWord2,
  String? endText2,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
          color: grey5Color,
        ),
        children: [
          TextSpan(text: startText),
          if (boldWord != null)
            TextSpan(
              text: boldWord,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor2,
              ),
            ),
          if (endText != null) TextSpan(text: endText),
          if (boldWord2 != null)
            TextSpan(
              text: boldWord2,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor2,
              ),
            ),
          if (endText2 != null) TextSpan(text: endText2),
        ],
      ),
    ),
  );
}

Widget buildBulletPoints(List<String> items) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: items.map((item) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "•  ",
              style: TextStyle(
                fontSize: 16,
                color: textColor2,
              ),
            ),
            Expanded(
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: grey5Color,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList(),
  );
}
