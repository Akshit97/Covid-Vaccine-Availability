//import 'dart:ffi';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'checkbox.dart';
import 'data.dart';
import 'information.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/':(context) => Info(),
      '/home':(context) => Home(),
      '/checkbox':(context) =>Checkbox1(),
    },
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map date = {};
  String pincode;
  String day;
  String month;
  String year;
  List<Data> _data = List<Data>();
  List<Data> _data1 = List<Data>();
  Future fetch() async{
     //var url="https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=243001&date=15-05-2021.json";
     var url="https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=${pincode}&date=${day}-${month}-${year}.json";
     //print(day);
     //print(month);
     var response = await get(url);
     var lists=List<List<Data>>();
     var data= List<Data>();
     var data1=List<Data>();
     if(response.statusCode==400)
       {
         print(response.statusCode);
         //print(response.body.toString());
         Map err=json.decode(response.body);
         print(err['error']);
         Fluttertoast.showToast(
             msg: err['error']+" \n Please try again",
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.CENTER,
             timeInSecForIosWeb: 1,
             backgroundColor: Colors.grey,
             textColor: Colors.white,
             fontSize: 16.0
         );
         Navigator.pop(context);
       }

     if(response.statusCode == 200)
       {
         Map dataJson = json.decode(response.body);
         dataJson.forEach((key, value) {
           //print(sessions.runtimeType);
           value.forEach((s) {
             //print(s['name']);
             //print(s.runtimeType);
             //print(s['sessions']);
             //print(s['sessions'].runtimeType);
             s['sessions'].forEach((sess){
               //print(sess);
               // I am ussing only 1 session is there in each center
             });
             if(s['sessions'][0]["min_age_limit"]==18)
                data.add(Data.fromJson(s));
             else
                data1.add(Data.fromJson(s));
           });

         });
       }
     lists.add(data);
     lists.add(data1);
     return lists;
  }

  @override
  void initState() {
    // TODO: implement initState


    //date=ModalRoute.of(context).settings.arguments;
    Future.delayed(Duration.zero, () {
      setState(() {
        date = ModalRoute.of(context).settings.arguments;
      });
      //_yourFunction(args);
      day=date['day'];
      month=date['month'];
      year=date['year'];
      pincode=date['pincode'];
      fetch().then((value){
        setState(() {
          _data.addAll(value[0]);
          _data1.addAll(value[1]);
        });
      });

    });

    super.initState();
  }

  bool valuefirst = true;
  bool valuesecond = true;

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
    //print("Akshit2");
    //date=ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton.icon(onPressed: (){
            return _showMyDialog();
          }, icon: Icon(Icons.person,color: Colors.white,), label: Text("About",style: TextStyle(color: Colors.white),))
        ],
        title: Text("Covid Vaccine Availability"),
      ),
      body:
      ListView(
        children: [
          Column(
            children: [
              Container(
                  padding: new EdgeInsets.all(22.0),
                  child: Column(
                    children: <Widget>[
                      CheckboxListTile(
                        //secondary: const Icon(Icons.alarm),
                        title: const Text('18-44',style: TextStyle(fontSize:18,fontWeight: FontWeight.bold),),
                        //subtitle: Text('Ringing after 12 hours'),
                        value: this.valuefirst,
                        onChanged: (bool value) {
                          setState(() {
                            this.valuefirst = value;
                          });
                        },
                      ),
                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.trailing,
                        //secondary: const Icon(Icons.alarm),
                        title: const Text('45+',style: TextStyle(fontSize:18,fontWeight: FontWeight.bold),),
                        //subtitle: Text('Ringing after 12 hours'),
                        value: this.valuesecond,
                        onChanged: (bool value) {
                          setState(() {
                            this.valuesecond = value;
                          });
                        },
                      ),

                    ],
                  )
              ),
            ],
          ),
          Visibility(
              visible: (valuefirst==false && valuesecond==false)?true:false,
              child: Text("No Results Found",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),)
          ),
          Visibility(
            visible: valuefirst,
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index)
              {
                return Card(
                    color:_data[index].available_capacity>0?Colors.green:Colors.redAccent,
                    child:Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Text(_data[index].name,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),),
                          Text("Minimum Age: " + _data[index].min_age_limit.toString(),
                            style: TextStyle(
                              fontSize: 16,
                            ),),
                          Text("Date: " + _data[index].date.toString(),
                            style: TextStyle(
                              fontSize: 16,
                            ),),
                          Text("Available Capacity: " + _data[index].available_capacity.toString(),
                            style: TextStyle(
                              fontSize: 16,
                            ),)
                        ],
                      ),
                    )
                );
              },
              itemCount: _data.length,
            ),
          ),
          Visibility(
            visible: valuesecond,
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index)
              {
                return Card(
                    color:_data1[index].available_capacity>0?Colors.greenAccent:Colors.redAccent,
                    child:Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Text(_data1[index].name,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),),
                          Text("Minimum Age: " + _data1[index].min_age_limit.toString(),
                            style: TextStyle(
                              fontSize: 16,
                            ),),
                          Text("Date: " + _data1[index].date.toString(),
                            style: TextStyle(
                              fontSize: 16,
                            ),),
                          Text("Available Capacity: " + _data1[index].available_capacity.toString(),
                            style: TextStyle(
                              fontSize: 16,
                            ),)
                        ],
                      ),
                    )
                );
              },
              itemCount: _data1.length,
            ),
          ),
        ],
      ),
    /*

      */
    );
  }
}
