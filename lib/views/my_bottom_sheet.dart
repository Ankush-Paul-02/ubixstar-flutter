import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

class MyBottomSheet extends StatefulWidget {
  final List<String> selectedOptions;
  final ValueChanged<List<String>> onChanged;
  final VoidCallback onImportPressed;

  const MyBottomSheet({
    Key? key,
    required this.selectedOptions,
    required this.onChanged,
    required this.onImportPressed,
  }) : super(key: key);

  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  List<String> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    selectedOptions = widget.selectedOptions ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        10.heightBox,
        CheckboxListTile(
          title: 'Text Field'.text.semiBold.make(),
          value: selectedOptions.contains('Text Field'),
          onChanged: (value) {
            setState(() {
              if (value != null) {
                if (value) {
                  selectedOptions.add('Text Field');
                } else {
                  selectedOptions.remove('Text Field');
                }
              }
              widget.onChanged(selectedOptions);
            });
          },
        ),
        CheckboxListTile(
          title: 'Image'.text.semiBold.make(),
          value: selectedOptions.contains('Image'),
          onChanged: (value) {
            setState(() {
              if (value != null) {
                if (value) {
                  selectedOptions.add('Image');
                } else {
                  selectedOptions.remove('Image');
                }
              }
              widget.onChanged(selectedOptions);
            });
          },
        ),
        CheckboxListTile(
          title: 'Save'.text.semiBold.make(),
          value: selectedOptions.contains('Save'),
          onChanged: (value) {
            setState(() {
              if (value != null) {
                if (value) {
                  selectedOptions.add('Save');
                } else {
                  selectedOptions.remove('Save');
                }
              }
              widget.onChanged(selectedOptions);
            });
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
          ),
          onPressed: () {
            widget.onImportPressed();
            Navigator.of(context).pop();
          },
          child: 'Import'.text.black.make(),
        ).box.size(100.w, 8.h).make().pSymmetric(h: 3.w),
        10.heightBox,
      ],
    );
  }
}
