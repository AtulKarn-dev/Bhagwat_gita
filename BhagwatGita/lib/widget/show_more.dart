import 'package:flutter/material.dart';

class DescriptionTextWidget extends StatefulWidget {
  final String? text;

  const DescriptionTextWidget({super.key, required this.text});

  @override
  State<DescriptionTextWidget> createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String? firstHalf;
  String? secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text!.length > 150) {
      firstHalf = widget.text!.substring(0, 150);
      secondHalf = widget.text!.substring(100, widget.text!.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: secondHalf!.isEmpty
          ? Text(firstHalf!)
          : Column(
              children: <Widget>[
                Text(flag ? ("${firstHalf!}...") : (firstHalf! + secondHalf!),textAlign: TextAlign.justify,),
                InkWell(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      flag ? "show more" : "show less",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag;
                    });
                  },
                ),
              ],
            ),
    );
  }
}
