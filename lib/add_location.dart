import 'package:flutter/material.dart';
import 'network/flutterfire.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({Key? key}) : super(key: key);
  static const id = '/add_location';

  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  List<String> locations = [
    //Need to replace this with city names from weather API
    "Dallas",
    "San Antonio",
    "College Station",
  ];

  String dropdownValue = "Dallas";
  TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          DropdownButton<String>(
            //Drop down menu
            value: dropdownValue,
            onChanged: (String? value) {
              setState(() {
                dropdownValue = value!;
              });
            },
            items: locations.map<DropdownMenuItem<String>>((String value) {
              //for each item we create a dropdownmenu item
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Coin Amount',
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 45,
            width: MediaQuery.of(context).size.width / 1.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.blueAccent,
            ),
            child: MaterialButton(
              onPressed: () async {
                await addAmount(dropdownValue, _amountController.text);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ),
        ],
      ),
    );
  }
}
