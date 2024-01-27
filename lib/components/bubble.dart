import 'package:flutter/material.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class MultiSelectBubbleList extends StatefulWidget {
  final List<String> options;
  final Function(List<String> selectedItems) onSelectionChanged;

  const MultiSelectBubbleList({
    Key? key,
    required this.options,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _MultiSelectBubbleListState createState() => _MultiSelectBubbleListState();
}

class _MultiSelectBubbleListState extends State<MultiSelectBubbleList> {
  List<String> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Wrap(
      alignment: WrapAlignment.center,
      spacing: 10.0,
      children: List.generate(
        widget.options.length,
        (index) => BubbleElement(
          buttonText: widget.options[index],
          onPressed: () {
            setState(() {
              if (selectedItems.contains(widget.options[index])) {
                selectedItems.remove(widget.options[index]);
              } else {
                selectedItems.add(widget.options[index]);
              }
            });
            widget.onSelectionChanged(
                selectedItems); // Notify parent about the selected items
          },
          isSelected: selectedItems.contains(widget.options[index]),
        ),
      ),
    ));
  }
}

class BubbleElement extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  final bool isSelected;
  final double? width; // Optional width parameter

  const BubbleElement({
    Key? key,
    required this.buttonText,
    required this.onPressed,
    required this.isSelected,
    this.width, // Optional width parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      width: width,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0.0),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (isSelected) {
                return AppColors.accentColor1;
              } else {
                return AppColors.cardColor;
              }
            },
          ),
          overlayColor: MaterialStateProperty.all(
              Colors.transparent), // Set overlay color to transparent
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 8.0, bottom: 8.0), // Adjust the padding as needed
          child: Text(
            buttonText,
            style: GoogleFonts.roboto(
              color: isSelected ? AppColors.white : AppColors.textColorGray,
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
