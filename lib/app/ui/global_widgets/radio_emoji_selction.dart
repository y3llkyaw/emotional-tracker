import 'package:flutter/material.dart';
import 'package:animated_emoji/animated_emoji.dart';

class RadioEmojiSelection extends StatefulWidget {
  final AnimatedEmojiData selectedEmoji;
  final Function(AnimatedEmojiData) onEmojiSelected;
  final bool? isVertical; // Flag for vertical display

  const RadioEmojiSelection({
    Key? key,
    required this.selectedEmoji,
    required this.onEmojiSelected,
    this.isVertical = false, // Default is horizontal
  }) : super(key: key);

  @override
  State<RadioEmojiSelection> createState() => _RadioEmojiSelectionState();
}

class _RadioEmojiSelectionState extends State<RadioEmojiSelection> {
  late AnimatedEmojiData _currentSelection;
  final int _emojisPerPage = 40; // Number of emojis to load per page
  int _currentPage = 0; // Current page index
  List<AnimatedEmojiData> _visibleEmojis = []; // Emojis to display
  final ScrollController _scrollController =
      ScrollController(); // Scroll controller

  // Static cache for all emojis
  static List<AnimatedEmojiData>? _allEmojisCache;

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

    // Initialize cache if not already cached
    _allEmojisCache ??= AnimatedEmojis.values;

    _loadNextPage();

    // Listen to scroll events
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 10) {
        _loadNextPage();
      }
    });
  }

  void _onSelect(AnimatedEmojiData emoji) {
    setState(() => _currentSelection = emoji);
    widget.onEmojiSelected(emoji); // Notify parent
  }

  void _loadNextPage() {
    if (_allEmojisCache == null) return;

    final startIndex = _currentPage * _emojisPerPage;
    final endIndex =
        (_currentPage + 1) * _emojisPerPage > _allEmojisCache!.length
            ? _allEmojisCache!.length
            : (_currentPage + 1) * _emojisPerPage;

    if (startIndex < _allEmojisCache!.length) {
      setState(() {
        _visibleEmojis.addAll(_allEmojisCache!.sublist(startIndex, endIndex));
        _currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: widget.isVertical! ? Axis.vertical : Axis.horizontal,
        child: widget.isVertical!
            ? Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                direction: Axis.horizontal, // Use vertical layout for Wrap
                children: [
                  ..._buildEmojiButtons(),
                ],
              )
            : Row(
                children: [
                  ..._buildEmojiButtons(),
                ],
              ),
      ),
    );
  }

  List<Widget> _buildEmojiButtons() {
    return [
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
    ];
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
          source: AnimatedEmojiSource.asset,
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
