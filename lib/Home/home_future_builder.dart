import 'package:amihub/Components/random_color.dart';
import 'package:amihub/Home/today_class_card.dart';
import 'package:amihub/Repository/amizone_repository.dart';
import 'package:amihub/Theme/theme.dart';
import 'package:amihub/ViewModels/today_class_model.dart';
import 'package:flutter/material.dart';

class TodayClassBuilder extends StatefulWidget {
  @override
  _TodayClassBuilderState createState() => _TodayClassBuilderState();
}

class _TodayClassBuilderState extends State<TodayClassBuilder> {
  AmizoneRepository amizoneRepository = AmizoneRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TodayClass>>(
      future: amizoneRepository.fetchTodayClass(),
      builder:
          (BuildContext context, AsyncSnapshot<List<TodayClass>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
                child: Text(
              'Awaiting result...',
              style: headingStyle,
            ));
          case ConnectionState.done:
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            return Column(
              children: List.generate(
                  snapshot.data==null?1:snapshot.data.length,
                  (index) {
                    if(snapshot.data==null){return TodayClassCard(TodayClass(Color(0xff),"","No Classes Today","","","",""),createRandomColor());}
                    return TodayClassCard(
                      snapshot.data.elementAt(index), createRandomColor());}),
            );
          case ConnectionState.none:
            // TODO: Handle this case.
            break;
          case ConnectionState.active:
            // TODO: Handle this case.
            break;
        }
        return Text("End"); // unreachable
      },
    );
  }
}
