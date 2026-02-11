import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String? highlightedText;
  final TextStyle? style;
  final TextStyle? highlightedStyle;
  final TextOverflow overflow;

  HighlightedText({
    required this.text,
    this.highlightedText,
    this.style,
    this.highlightedStyle,
    this.overflow = TextOverflow.clip,
  });

  @override
  Widget build(BuildContext context) {
    // If highlightedText is null or empty, return the normal text with the provided style
    if (highlightedText == null || highlightedText!.isEmpty) {
      return Text(
        text,
        style: style,
      );
    }

    List<TextSpan> spans = [];
    int start = 0;

    while (true) {
      int index =
          text.toLowerCase().indexOf(highlightedText!.toLowerCase(), start);

      if (index == -1) {
        // No more occurrences, add the remaining text
        spans.add(TextSpan(text: text.substring(start), style: style));
        break;
      }

      // Add the text before the highlighted part
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index), style: style));
      }

      // Add the highlighted text
      spans.add(TextSpan(
        text: text.substring(index, index + highlightedText!.length),
        style: highlightedStyle ??
            style?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.blue,
            ),
      ));

      // Move the start index past the highlighted text
      start = index + highlightedText!.length;
    }

    return RichText(
      overflow: overflow,
      text: TextSpan(
        style: style, // Default text style
        children: spans,
      ),
    );
  }
}
