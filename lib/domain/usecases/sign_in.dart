import 'package:coddr/data/repositories/platform_repository_impl.dart';
import 'package:coddr/domain/entities/app_error.dart';
import 'package:coddr/domain/entities/no_params.dart';
import 'package:coddr/domain/entities/user_credentials.dart';
import 'package:coddr/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';

class SignIn extends Usecase<bool, NoParams> {
  PlatformRepositoryImpl platformRepositoryImpl;

  SignIn({@required this.platformRepositoryImpl});

  @override
  Future<Either<AppError, bool>> call(NoParams noParams) async {
    return platformRepositoryImpl.signOut();
  }
}
