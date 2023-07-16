import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 'Widgets'.text.make().centered(),
      ),
      body: const Column(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => const MyBottomSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({super.key});

  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  List<String> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: [
          CheckboxListTile(
            title: const Text('Option 1'),
            value: selectedOptions.contains('option1'),
            onChanged: (value) {
              setState(() {
                if (value != null) {
                  if (value) {
                    selectedOptions.add('option1');
                  } else {
                    selectedOptions.remove('option1');
                  }
                }
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Option 2'),
            value: selectedOptions.contains('option2'),
            onChanged: (value) {
              setState(() {
                if (value != null) {
                  if (value) {
                    selectedOptions.add('option2');
                  } else {
                    selectedOptions.remove('option2');
                  }
                }
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Option 3'),
            value: selectedOptions.contains('option3'),
            onChanged: (value) {
              setState(() {
                if (value != null) {
                  if (value) {
                    selectedOptions.add('option3');
                  } else {
                    selectedOptions.remove('option3');
                  }
                }
              });
            },
          ),
          ElevatedButton(
            child: const Text('Confirm'),
            onPressed: () {
              // Perform any action or handle the selected options here
              print(selectedOptions);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
