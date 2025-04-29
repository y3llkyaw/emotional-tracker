import 'package:flutter/material.dart';

class TempChatPage extends StatefulWidget {
  const TempChatPage({Key? key}) : super(key: key);

  @override
  State<TempChatPage> createState() => _TempChatPageState();
}

class _TempChatPageState extends State<TempChatPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Page"),
      ),
    );
  }
}
