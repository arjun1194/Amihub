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
            if (snapshot.hasError) {print(snapshot.data);return Column(crossAxisAlignment: CrossAxisAlignment.start,
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
                Padding(
                  padding: const EdgeInsets.only(top: 64),
                  child: Center(child:Text("No classes to show")),
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











































class TodayClassSeamer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            ListTile(
              title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.grey,
                    width: 200,
                    height: 20,
                  )),
              subtitle: Text(" "),
              leading: Container(
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(999)),
                height: 32,
                width: 32,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[Text(" "), Text(" ")],
              ),
              onTap: () {},
            ),
            Divider(),
          ],
        );
      },
    );
  }
}
