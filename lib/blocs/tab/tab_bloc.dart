import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:PardalTodo/blocs/tab/tab.dart';
import 'package:PardalTodo/models/models.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  @override
  AppTab get initialState => AppTab.todos;

  @override
  Stream<AppTab> mapEventToState(TabEvent event) async* {
    if (event is UpdateTab) {
      yield event.tab;
    }
  }
}
