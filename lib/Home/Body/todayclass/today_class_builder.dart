import 'package:amihub/Home/Body/todayclass/today_class_seamer.dart';
import 'package:amihub/Repository/amizone_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TodayClassBuilder extends StatefulWidget {

  @override
  _TodayClassBuilderState createState() => _TodayClassBuilderState();
}

class _TodayClassBuilderState extends State<TodayClassBuilder> {
  AmizoneRepository amizoneRepository = AmizoneRepository();
  DateTime selectDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future:
      amizoneRepository.fetchTodayClassWithDate("${selectDate.month}/${selectDate.day}/${selectDate.year}","${selectDate.month}/${selectDate.day}/${selectDate.year}"),
//          amizoneRepository.fetchTodayClassWithDate("8/2/2019","9/2/2019"),
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return TodayClassSeamer();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Today's Classes",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(32),
                              child: Icon(
                                Icons.cloud_off, color: Colors.white, size: 108,),
                              decoration: BoxDecoration(color: Colors.grey[400],
                                  borderRadius: BorderRadius.circular(999)),),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text('Could not fetch Class',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18,),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                'Please Check Your internet and try again',),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );}
            //Wtf??
            if (snapshot.data == "No Class") return  Center(child: Text('No classes for today'));


            return Padding(
              padding: const EdgeInsets.only(top: 4,left: 4,right: 4),
              child: ListView(scrollDirection: Axis.vertical,shrinkWrap: true,
                  children: [Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 32,left: 32),
                        child: Text("Today's Classes",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 32,right: 32),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
                          Text("Pick Date",style: TextStyle(fontSize: 18),),
                          FlatButton(onPressed: () {DatePicker.showDatePicker(context,showTitleActions: true,minTime: DateTime(2018, 3, 5),maxTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),onConfirm: (date) {setState(() {selectDate = date;});},currentTime: selectDate,locale: LocaleType.en);},child: Text('${selectDate.day}/${selectDate.month}/${selectDate.year}',style: TextStyle(color: Colors.blue),),),
                        ],),
                      ),

                      Column(
                        children: List.generate(snapshot.data.length, (int index){
                          return Column(
                            children: <Widget>[
                              Divider(),
                              ListTile(title: Text(snapshot.data[index]['title']),  subtitle: Text(snapshot.data[index]['courseCode']), leading: Container(color: (snapshot.data[index]['color'] == "#f00")? Colors.red: (snapshot.data[index]['color'] == "#4FCC4F")? Colors.green: Colors.transparent,width: 8,),contentPadding: EdgeInsets.only(left: 0,right: 8),),
                            ],
                          );
                        }),),
                      Divider(),
                    ],

                  ),]
              ),
            );


          case ConnectionState.none:
            break;
          case ConnectionState.active:
            break;
        }
        return Text(" "); // unreachable
      },
    );
  }
}












































