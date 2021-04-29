import 'package:drivers_app/AllWidgets/HistoryItem.dart';
import 'package:drivers_app/DataHandler/appData.dart';
import 'package:drivers_app/Models/history.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_restart/flutter_restart.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();

}

class _HistoryScreenState extends State<HistoryScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Trip History'),
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          onPressed: (){
            makeHistoryDelete();
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left),
        ),
      ),

      body: ListView.separated(
        padding: EdgeInsets.all(0),
        itemBuilder: (context, index)
        {
          return HistoryItem(
            history: Provider.of<AppData>(context, listen: false).tripHistoryDataList[index],
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(thickness: 3.0, height: 3.0,),
        itemCount: Provider.of<AppData>(context, listen: false).tripHistoryDataList.length,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
      ),

    );
  }
  void makeHistoryDelete()
  {
    //_restartApp();
    int len = Provider.of<AppData>(context, listen: false).tripHistoryDataList.length;
    Provider.of<AppData>(context, listen: false).tripHistoryDataList.removeRange(0,len);

  }
  void _restartApp() async
  {
    FlutterRestart.restartApp();
  }

}
