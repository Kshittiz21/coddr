import 'package:coddr/domain/entities/app_error.dart';
import 'package:coddr/domain/entities/cf_standings_entity.dart';
import 'package:coddr/domain/entities/contest_entity.dart';
import 'package:coddr/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PlatformRepository {
  Future<Either<AppError, List<ContestEntity>>> getCFContestList();

  Future<Either<AppError, bool>> signIn(String email, String password);

  Future<Either<AppError, bool>> signUp(String email, String password);

  Future<Either<AppError, bool>> signOut();

  bool isSignedIn();

  String getEmailId();

  Future<Either<AppError, void>> storeUserCredentials(
      Map<String, String> authData);

  Future<Either<AppError, List<UserEntity>>> getCFUserList(List<String> params);

  Future<Either<AppError, CFStandingsEntity>> getCFStandings(
      List<String> handles, String contestId);
}
