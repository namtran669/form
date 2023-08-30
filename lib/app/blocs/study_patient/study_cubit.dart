import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';

part 'study_state.dart';

class StudyCubit extends Cubit<StudyState> {
  StudyCubit(this._repo) : super(StudyInitial());

  final PatientTreatmentRepo _repo;

  List<Study> studies = [];
  Study? studySelected;

  fetchStudies() async {
    if (studies.isEmpty) {
      emit(StudyLoading());
      var result = await _repo.fetchStudies();
      result.when(success: (data) {
        studies = data;
        selectStudy(data.first);
      });
    }
  }

  selectStudy(Study? study) {
    if(study != null) {
      studySelected = study;
      emit(StudySelected(studySelected!));
    }
  }

  reset() {
    studies.clear();
    studySelected = null;
  }
}
