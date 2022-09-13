import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:poetic_app/core/size/size_config.dart';
import 'package:poetic_app/core/theme/app_theme.dart';
import 'package:poetic_app/core/utils/overlay.dart';

class Interests extends StatefulWidget {
  const Interests({Key? key, required this.onTap, required this.onRemove})
      : super(key: key);
  final Function(String value) onTap;
  final Function(String value) onRemove;
  @override
  State<Interests> createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  List<dynamic>? dataRetrieved; // data decoded from the json file
  List<dynamic>? data; // data to display on the screen

  int searchValue = 0;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    final String response =
        await rootBundle.loadString('assets/Interests.json');
    dataRetrieved = await json.decode(response) as List<dynamic>;
    setState(() {
      data = dataRetrieved;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SizedBox(
      height: 25 * SizeOF.height!,
      child: RemoveOverlay(
        child: AlignedGridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 5,
          crossAxisSpacing: 10,
          itemCount: data != null ? data!.length : 0,
          itemBuilder: (context, index) {
            return OutlinedButton(
              onPressed: () {
                if (!data![index]['isClick']) {
                  setState(() {
                    widget.onTap(data![index]['name']);
                    data![index]['isClick'] = true;
                  });
                } else {
                  setState(() {
                    widget.onRemove(data![index]['name']);
                    data![index]['isClick'] = false;
                  });
                }
              },
              style: OutlinedButton.styleFrom(
                shape: const StadiumBorder(),
                backgroundColor:
                    data![index]['isClick'] ? theme.btnSelectColor : null,
                side: BorderSide(
                  width: 1.0,
                  color: theme.btnSelectColor,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: Text(
                  data![index]['name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 2 * SizeOF.text!,
                      // fontWeight: FontWeight.w600,
                      color: data![index]['isClick']
                          ? Colors.white
                          : theme.textColor),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
