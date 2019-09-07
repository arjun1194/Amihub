import 'package:amihub/Home/Body/today_class_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class HomeTodayClass extends StatefulWidget {
  @override
  _HomeTodayClassState createState() => _HomeTodayClassState();
}

class _HomeTodayClassState extends State<HomeTodayClass> {
  DateTime selectDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            "Today's Classes",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Pick Date",
              style: TextStyle(fontSize: 18),
            ),
            FlatButton(
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2018, 3, 5),
                      maxTime: DateTime(
                          DateTime
                              .now()
                              .year,
                          DateTime
                              .now()
                              .month,
                          DateTime
                              .now()
                              .day),
                      onConfirm: (date) {
                        setState(() {
                          selectDate = date;
                        });
                      },
                      currentTime: selectDate,
                      locale: LocaleType.en);
                },
                child: Text(
                  '${selectDate.day}/${selectDate.month}/${selectDate.year}',
                  style: TextStyle(color: Colors.blue),
                ))
            //add date picker here
          ],
        ),
        Expanded(
            child: Container(
              child: TodayClassBuilder(
                  "${selectDate.month}/${selectDate.day}/${selectDate.year}",
                  "${selectDate.month}/${selectDate.day}/${selectDate.year}"),
            )),
      ],
    );
  }
}
