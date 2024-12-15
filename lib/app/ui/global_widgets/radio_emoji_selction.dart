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
  final ScrollController _scrollController =
      ScrollController(); // Scroll controller

  final List<AnimatedEmojiData> _baseEmojis = [
    AnimatedEmojis.angry,
    AnimatedEmojis.sad,
    AnimatedEmojis.neutralFace,
    AnimatedEmojis.smile,
    AnimatedEmojis.joy,
  ];

  @override
  void initState() {
    super.initState();
    _currentSelection = widget.selectedEmoji;
    _loadNextPage();

    // Listen to scroll events
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 50) {
        _loadNextPage();
      }
    });
  }

  void _onSelect(AnimatedEmojiData emoji) {
    setState(() => _currentSelection = emoji);
    widget.onEmojiSelected(emoji); // Notify parent
  }

  void _loadNextPage() {
    const allEmojis = AnimatedEmojis.values; // Get all emojis
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
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Base Emojis
          ..._baseEmojis.map(
            (emoji) => _buildEmojiButton(emoji, Colors.grey, null),
          ),
          // Visible Emojis
          ..._visibleEmojis.map(
            (emoji) => !_baseEmojis.contains(emoji)
                ? _buildEmojiButton(emoji, Colors.grey, null)
                : Container(),
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
              emoji.toUnicodeEmoji(),
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
          ),
          onLoaded: (duration) {
            if (duration.inMilliseconds > 1000) {
              _onSelect(emoji);
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
