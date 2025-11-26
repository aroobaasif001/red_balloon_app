import 'package:flutter/material.dart';

import '../../../../../../custom_widgets/custom_dotted_border.dart';
import '../../../../../../custom_widgets/custom_textfield.dart';
import '../../../../../../utils/colors.dart';
import '../controller/upload_proof_controller.dart';

/// Optional note field
Widget buildNoteField(UploadProofController controller) {
  return DottedBorderContainer(
    strokeWidth: 2,
    borderRadius: 15,
    color: borderColor,
    dashSpace: 0,
    child: CustomTextField(
      maxLines: 3,
      controller: controller.noteController,
      hintText: 'Add any additional comments about the completed task...',
    ),
  );
}
