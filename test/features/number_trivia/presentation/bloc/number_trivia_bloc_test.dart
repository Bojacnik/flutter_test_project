import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testing_flutter_for_real_now/core/error/failures.dart';
import 'package:testing_flutter_for_real_now/core/usecases/usecase.dart';
import 'package:testing_flutter_for_real_now/core/util/input_converter.dart';
import 'package:testing_flutter_for_real_now/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:testing_flutter_for_real_now/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:testing_flutter_for_real_now/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:testing_flutter_for_real_now/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:testing_flutter_for_real_now/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:testing_flutter_for_real_now/features/number_trivia/presentation/bloc/number_trivia_state.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    // arrange
    // act

    // assert
    expect(bloc.initialState, equals(const Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(const Right(tNumberParsed));
    }

    void setUpMockGetTriviaForConcreteNumberEitherRight() {
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
    }

    test('''should call the InputConverter to validate and
         convert the string to an unsigned integer''', () async {
      // arrange
      setUpMockGetTriviaForConcreteNumberEitherRight();

      setUpMockInputConverterSuccess();
      // act
      bloc.add(const GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      // assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    blocTest(
      "should emit [Error] when the input is invalid",
      build: () => bloc,
      setUp: () {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
      },
      act: (tBloc) =>
          tBloc.add(const GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [
        const Error(message: invalidInputFailureMessage),
      ],
      verify: (bloc) {
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString))
            .called(1);
      },
    );

    test(
      'should get data from the concrete use case',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
        // act
        bloc.add(const GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
        // assert
        verify(
            mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
      },
    );

    blocTest(
      "should emit [Loading, Loaded] when data is gotten successfully",
      build: () => bloc,
      setUp: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => const Right(tNumberTrivia));
      },
      act: (tBloc) =>
          tBloc.add(const GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [
        const Loading(),
        const Loaded(trivia: tNumberTrivia),
      ],
      verify: (bloc) {
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString))
            .called(1);
        verify(mockGetConcreteNumberTrivia(
          const Params(number: tNumberParsed),
        ));
      },
    );

    blocTest(
      'should emit [Loading, Error] when getting data fails',
      build: () => bloc,
      setUp: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
      },
      act: (tBloc) =>
          tBloc.add(const GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [
        const Loading(),
        const Error(message: serverFailureMessage),
      ],
      verify: (bloc) {
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString))
            .called(1);
        verify(mockGetConcreteNumberTrivia(
          const Params(number: tNumberParsed),
        ));
      },
    );

    blocTest(
      'should emit [Loading, Error] with proper message for the error when getting data fails',
      build: () => bloc,
      setUp: () {
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
      },
      act: (tBloc) =>
          tBloc.add(const GetTriviaForConcreteNumber(tNumberString)),
      expect: () => [
        const Loading(),
        const Error(message: cacheFailureMessage),
      ],
      verify: (bloc) {
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString))
            .called(1);
        verify(
            mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)));
      },
    );
  });

  group(
    'GetTriviaForRandomNumber',
    () {
      const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

      test(
        'should get data from the random use case',
        () async {
          // arrange
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => const Right(tNumberTrivia));
          // act
          bloc.add(GetTriviaForRandomNumber());
          await untilCalled(mockGetRandomNumberTrivia(any));
          // assert
          verify(mockGetRandomNumberTrivia(any));
        },
      );

      blocTest('should emit [Loading, Loaded] when data is gotten successfully',
          build: () => bloc,
          setUp: () {
            when(mockGetRandomNumberTrivia(any))
                .thenAnswer((_) async => const Right(tNumberTrivia));
          },
          act: (tBloc) => {tBloc.add(GetTriviaForRandomNumber())},
          expect: () => [
                const Loading(),
                const Loaded(trivia: tNumberTrivia),
              ],
          verify: (bloc) {
            verify(mockGetRandomNumberTrivia(NoParams()));
          });

      blocTest(
        'should emit [Loading, Error] when getting data fails',
        build: () => bloc,
        setUp: () {
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Left(ServerFailure()));
        },
        act: (tBloc) => tBloc.add(GetTriviaForRandomNumber()),
        expect: () => [
          const Loading(),
          const Error(
            message: serverFailureMessage,
          )
        ],
        verify: (bloc) {
          verify(mockGetRandomNumberTrivia(any));
        },
      );

      blocTest(
          'should emit [Loading, Error] with proper message for the error when getting data fails',
          build: () => bloc,
          setUp: () {
            when(mockGetRandomNumberTrivia(any))
                .thenAnswer((_) async => Left(CacheFailure()));
          },
          act: (tBloc) => tBloc.add(GetTriviaForRandomNumber()),
          expect: () => [
                const Loading(),
                const Error(message: cacheFailureMessage),
              ],
          verify: (bloc) {
            verify(mockGetRandomNumberTrivia(any));
          });
    },
  );
}
