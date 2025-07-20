import 'package:fpdart/fpdart.dart';
import 'package:alumea/core/errors/failure_class.dart';

typedef FutureEither<T> = Future<Either<FailureClass, T>>;
typedef FutureVoid = FutureEither<void>;