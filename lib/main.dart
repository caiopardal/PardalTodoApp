import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:PardalTodo/blocs/authentication_bloc/bloc.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:PardalTodo/blocs/blocs.dart';
import 'package:PardalTodo/screens/screens.dart';
import 'package:user_repository/user_repository.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(TodosApp());
}

class TodosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (context) {
            return AuthenticationBloc(
              userRepository: FirebaseUserRepository(),
            )..add(AppStarted());
          },
        ),
        BlocProvider<TodosBloc>(
          create: (context) {
            return TodosBloc(
              todosRepository: FirebaseTodosRepository(),
            )..add(LoadTodos());
          },
        )
      ],
      child: MaterialApp(
        title: 'PardalTodos',
        routes: {
          '/': (context) {
            return BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state is Unauthenticated) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<TabBloc>(
                        create: (context) => TabBloc(),
                      ),
                      BlocProvider<FilteredTodosBloc>(
                        create: (context) => FilteredTodosBloc(
                          todosBloc: BlocProvider.of<TodosBloc>(context),
                        ),
                      ),
                      BlocProvider<StatsBloc>(
                        create: (context) => StatsBloc(
                          todosBloc: BlocProvider.of<TodosBloc>(context),
                        ),
                      ),
                    ],
                    child: HomeScreen(),
                  );
                }
                if (state is Authenticated) {
                  return Center(
                    child: Text('Could not authenticate with Firestore'),
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            );
          },
          '/addTodo': (context) {
            return AddEditScreen(
              onSave: (task, note) {
                BlocProvider.of<TodosBloc>(context).add(
                  AddTodo(Todo(task, note: note)),
                );
              },
              isEditing: false,
            );
          },
        },
      ),
    );
  }
}
