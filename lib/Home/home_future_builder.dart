import 'package:amihub/Components/today_class_seamer.dart';
import 'package:amihub/Home/today_class_card_builder.dart';
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
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: TodayClassSeamer(),
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            return Row(
              children: List.generate(
                  snapshot.data == null ? 1 : snapshot.data.length, (index) {
                if (snapshot.data == null) {
                  return Center(child: Text("No Classes Today"));
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TodayClassCard(
                      snapshot.data.elementAt(index), [
                    lightColors[(index > snapshot.data.length ? index %
                        snapshot.data.length : index)],
                    darkColors[(index > snapshot.data.length ? index %
                        snapshot.data.length : index)]
                  ]),
                );
              }),
            );
          case ConnectionState.none:
            break;
          case ConnectionState.active:
            break;
        }
        return Text("End"); // unreachable
      },
    );
  }
}
