import 'package:flutter/material.dart';

class DescriptionTextWidget extends StatefulWidget {
  final String? text;

  const DescriptionTextWidget({super.key, required this.text});

  @override
  State<DescriptionTextWidget> createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  late  Text firstHalf;
  late  Text secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text!.length >150) {
       firstHalf = Text(widget.text!);
      secondHalf = Text(widget.text!);
    } else {
      firstHalf = Text(widget.text!);
      secondHalf = const Text("");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: secondHalf.data!.isEmpty
          ? firstHalf
          : Column(
              children: <Widget>[
                Container( child: flag ? Text((firstHalf.data!),maxLines:3,textAlign: TextAlign.justify,overflow: TextOverflow.ellipsis,) : Text(secondHalf.data!,textAlign: TextAlign.justify,)),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
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



