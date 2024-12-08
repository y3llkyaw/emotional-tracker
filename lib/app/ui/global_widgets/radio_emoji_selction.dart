import 'package:flutter/material.dart';
import 'package:animated_emoji/animated_emoji.dart';

class RadioEmojiSelection extends StatefulWidget {
  final AnimatedEmojiData selectedEmoji;
  final Function(AnimatedEmojiData) onEmojiSelected;

  const RadioEmojiSelection({
    Key? key,
    required this.selectedEmoji,
    required this.onEmojiSelected,
  }) : super(key: key);

  @override
  State<RadioEmojiSelection> createState() => _RadioEmojiSelectionState();
}

class _RadioEmojiSelectionState extends State<RadioEmojiSelection> {
  late AnimatedEmojiData _currentSelection;
  final int _emojisPerPage = 10; // Number of emojis to load per page
  int _currentPage = 0; // Current page index
  List<AnimatedEmojiData> _visibleEmojis = []; // Emojis to display

  @override
  void initState() {
    super.initState();
    _currentSelection = widget.selectedEmoji;
    _loadNextPage();
  }

  void _onSelect(AnimatedEmojiData emoji) {
    setState(() => _currentSelection = emoji);
    widget.onEmojiSelected(emoji); // Notify parent
  }

  void _loadNextPage() {
    final allEmojis = AnimatedEmojis.values; // Get all emojis
    final startIndex = _currentPage * _emojisPerPage;
    final endIndex = (_currentPage + 1) * _emojisPerPage > allEmojis.length
        ? allEmojis.length
        : (_currentPage + 1) * _emojisPerPage;

    if (startIndex < allEmojis.length) {
      setState(() {
        _visibleEmojis.addAll(allEmojis.sublist(startIndex, endIndex));
        _currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                  _buildEmojiButton(
                      AnimatedEmojis.angry, Colors.redAccent, "😠"),
                  _buildEmojiButton(
                      AnimatedEmojis.sad, Colors.blueAccent, "😢"),
                  _buildEmojiButton(
                      AnimatedEmojis.neutralFace, Colors.grey, "😐"),
                  _buildEmojiButton(AnimatedEmojis.smile, Colors.amber, "😀"),
                  _buildEmojiButton(AnimatedEmojis.joy, Colors.orange, "😂"),
                ] +
                _visibleEmojis
                    .map(
                      (emoji) => _buildEmojiButton(
                        emoji,
                        Colors.grey,
                        null,
                      ),
                    )
                    .toList(),
          ),
          if (_currentPage * _emojisPerPage < AnimatedEmojis.values.length)
            TextButton(
              onPressed: _loadNextPage,
              child: const Text(
                "Load More",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmojiButton(
      AnimatedEmojiData emoji, Color highlightColor, String? errorText) {
    return GestureDetector(
      onTap: () => _onSelect(emoji),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentSelection == emoji
              ? highlightColor.withOpacity(0.5)
              : Colors.transparent,
        ),
        child: AnimatedEmoji(
          emoji,
          size: 40,
          errorWidget: Center(
            child: Text(
              errorText ?? "Emoji",
              style: const TextStyle(color: Colors.black, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
