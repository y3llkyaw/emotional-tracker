import 'package:emotion_tracker/app/ui/global_widgets/search_widget.dart';
import 'package:flutter/material.dart';

class FriendsAddPage extends StatefulWidget {
  const FriendsAddPage({Key? key}) : super(key: key);

  @override
  State<FriendsAddPage> createState() => _FriendsAddPageState();
}

class _FriendsAddPageState extends State<FriendsAddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Add Friends'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchWidget(controller: TextEditingController()),
            ],
          )),
    );
  }
}
