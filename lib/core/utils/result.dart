import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

// Tipo alias para un resultado que puede contener un error o datos válidos
typedef Result<T> = Either<Failure, T>;