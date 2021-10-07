import 'package:coddr/data/repositories/platform_repository_impl.dart';
import 'package:coddr/domain/entities/app_error.dart';
import 'package:coddr/domain/entities/curated_contest_model.dart';
import 'package:coddr/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class CreateCuratedContest extends Usecase<void, CuratedContestModel> {
  final PlatformRepositoryImpl platformRepository;

  CreateCuratedContest({this.platformRepository});

  @override
  Future<Either<AppError, void>> call(curatedContestModel) async {
    return await platformRepository.createCuratedContest(curatedContestModel);
  }
}
