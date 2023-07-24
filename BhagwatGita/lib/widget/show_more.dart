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
      secondHalf = widget.text!.substring(150, widget.text!.length);
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
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    child: Text(
                      flag ? "show more" : "show less",
                      style: const TextStyle(color: Colors.orange),
                    ),
                    onTap: () {
                      setState(() {
                        flag = !flag;
                      });
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
