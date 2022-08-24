// ignore_for_file: deprecated_member_use

import 'package:testing_flutter_for_real_now/core/error/exceptions.dart';
import 'package:testing_flutter_for_real_now/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }
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
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                if (state is Empty) {
                  return const MessageDisplay(
                    message: 'Start searching!',
                  );
                } else if (state is Loading) {
                  return const LoadingWidget();
                } else if (state is Loaded) {
                  return TriviaDisplay(numberTrivia: state.trivia);
                } else if (state is Error) {
                  return MessageDisplay(
                    message: state.message,
                  );
                } else {
                  throw UnknownStateException(
                      "Unknown state in NumberTriviaBloc");
                }
              },
            ),
            const SizedBox(height: 20),
            //Bottom half
            const TriviaControls(),
          ],
        ),
      ),
    ),
  );
}
