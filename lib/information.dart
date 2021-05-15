import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  final myController = TextEditingController();
  DateTime selectedDate = DateTime.now().add(Duration(days: 1));
  String selectedDatestr="${DateTime.now().add(Duration(days: 1)).toLocal()}".split(' ')[0];
  String year="${DateTime.now().add(Duration(days: 1)).toLocal()}".split(' ')[0].split('-')[0];
  String month="${DateTime.now().add(Duration(days: 1)).toLocal()}".split(' ')[0].split('-')[1];
  String day="${DateTime.now().add(Duration(days: 1)).toLocal()}".split(' ')[0].split('-')[2];
  String pincode="243001";

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          title: Text('About'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Made by Akshit Agarwal'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        FlatButton.icon(onPressed: (){
          return _showMyDialog();
        }, icon: Icon(Icons.person,color: Colors.white,), label: Text("About",style: TextStyle(color: Colors.white),))
      ],
        title: Text("Covid Vaccine Availability"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
              color:Colors.blue,
              child:Text(selectedDatestr),
              onPressed: (){
                showDatePicker(
                    context: context,
                    initialDate: selectedDate == null ? DateTime.now().add(Duration(days:1)) : selectedDate,
                    firstDate: DateTime(2001),
                    lastDate: DateTime(2022)
                ).then((date) {
                  setState(() {
                    selectedDate = date;
                    selectedDatestr="${selectedDate.toLocal()}".split(' ')[0];
                    year="${selectedDate.toLocal()}".split(' ')[0].split('-')[0];
                    month="${selectedDate.toLocal()}".split(' ')[0].split('-')[1];
                    day="${selectedDate.toLocal()}".split(' ')[0].split('-')[2];
                    /*print(year);
                    print(month);
                    print(day);*/
                  });
                });
              }),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: myController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Pin Code',
              ),
            ),
          ),
          FlatButton(onPressed: (){
            pincode=myController.text;
            Navigator.pushNamed(context, '/home',
                arguments: {
                  'day':day,
                  'month':month,
                  'year':year,
                  'pincode':pincode
            });
          },
              color:Colors.blue,
              child: Text("Show"))
        ],
      ),
    );
  }
}
