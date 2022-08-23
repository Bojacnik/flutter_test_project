import 'package:testing_flutter_for_real_now/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: BlocProvider(
        create: (_) => sl<NumberTriviaBloc>(),
        child: Container(),
      ),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              //Top half
              // ignore: sized_box_for_whitespace
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: const Placeholder(),
              ),
              const SizedBox(height: 20),
              //Bottom half
              Column(
                children: <Widget>[
                  const Placeholder(
                    fallbackHeight: 40,
                  ),
                  const SizedBox(height: 10),
                  // ignore: prefer_const_literals_to_create_immutables
                  Row(
                    children: const <Widget>[
                      // ignore: prefer_const_constructors
                      Expanded(
                        child: Placeholder(
                          fallbackHeight: 30,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Placeholder(
                          fallbackHeight: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
