import 'package:amihub/repository/amizone_repository.dart';

class RefreshRepository {
  AmizoneRepository _amizoneRepository = AmizoneRepository();

  Future refreshTodayClass(String date) async {
    await _amizoneRepository.networkCallTodayClass(date);
  }

  Future refreshCourses(int semester) async {
    await _amizoneRepository.networkCallCourses(semester);
  }

  Future refreshMetadata() async {
    await _amizoneRepository.networkCallMetadata();
  }

  Future refreshResult(int semester) async {
    await _amizoneRepository.networkCallResult(semester);
  }
}
