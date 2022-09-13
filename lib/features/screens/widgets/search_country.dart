import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:poetic_app/core/utils/overlay.dart';

class ShearchCountry extends StatefulWidget {
  const ShearchCountry({Key? key, required this.onTap}) : super(key: key);
  final Function(String code, String name) onTap;
  @override
  State<ShearchCountry> createState() => _ShearchCountryState();
}

class _ShearchCountryState extends State<ShearchCountry> {
  final _searchController = TextEditingController();
  List<dynamic>? dataRetrieved; // data decoded from the json file
  List<dynamic>? data; // data to display on the screen

  var searchValue = "";
  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    final String response =
        await rootBundle.loadString('assets/CountryCodes.json');
    dataRetrieved = await json.decode(response) as List<dynamic>;
    setState(() {
      data = dataRetrieved;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );
    return Dialog(
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() => searchValue = value);
            },
            decoration: InputDecoration(
              hintText: 'Search Country',
              border: inputBorder,
              focusedBorder: inputBorder,
              enabledBorder: inputBorder,
              filled: true,
              contentPadding: const EdgeInsets.all(8),
            ),
            keyboardType: TextInputType.name,
          ),
          Expanded(
            child: RemoveOverlay(
              child: ListView(
                children: data != null
                    ? data!
                        .where((e) => e['name']
                            .toString()
                            .toLowerCase()
                            .contains(searchValue.toLowerCase()))
                        .map((e) => ListTile(
                              onTap: () {
                                widget.onTap(e['dial_code'], e['name']);
                                Navigator.pop(
                                  context,
                                );
                              },
                              title: Text(e['name']),
                              trailing: Text(e['dial_code']),
                            ))
                        .toList()
                    : [
                        const Center(
                          child: Text("Loading"),
                        ),
                      ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
