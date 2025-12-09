import 'package:flutter/material.dart';
import 'package:red_balloon_app/custom_widgets/custom_container.dart';

import '../../../../../../utils/colors.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController? controller;
  final VoidCallback? onSend;

  const ChatInputBar({super.key, this.controller, this.onSend});

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final ValueNotifier<bool> _hasText = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    // Listen to text changes
    widget.controller?.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onTextChanged);
    _hasText.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = widget.controller?.text.trim() ?? '';
    _hasText.value = text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      conColor: whiteColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            child: Image.asset(
              'assets/icons/attach-btn1.png',
              height: 22,
              width: 19,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: CustomContainer(
              height: 46,
              conColor: whiteColor,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color(0xffE0E0E0), width: 1),
              child: TextField(
                controller: widget.controller,
                decoration: const InputDecoration(
                  hintText: "Message...",
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => widget.onSend?.call(),
              ),
            ),
          ),

          const SizedBox(width: 12),

          ValueListenableBuilder<bool>(
            valueListenable: _hasText,
            builder: (context, hasText, child) {
              return InkWell(
                onTap: widget.onSend,
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: hasText ? redColor : const Color(0xffE0E0E0),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    _hasText.value
                        ? 'assets/icons/iconchat2.png'
                        : 'assets/icons/iconchat.png',
                    height: 45,
                    width: 45,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
