import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';

part 'form_incomplete_event.dart';

part 'form_incomplete_state.dart';

enum FormStatus {incomplete, complete}

extension FormStatusToString on FormStatus {
  String toShortString() {
    return toString().split('.').last;
  }
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PatientTreatmentRepo _treatmentRepo;
  int _page = 1;
  Study? study;
  List<FormData> totalFormsIncomplete = [];

  HomeBloc(this._treatmentRepo) : super(HomeInitial()) {
    on((event, emit) async {
      if (event is FormIncompleteRequested) {
        emit(FormIncompleteFetching());
        totalFormsIncomplete.clear();
        final response = await _treatmentRepo.fetchTreatmentsByStatuses(
          study!.registryId,
          _page++,
          [FormStatus.incomplete.toShortString()],
        );

        response.when(success: (data) {
          for (Treatment treatment in data.treatments ?? []) {
            for (FormData form in treatment.formData) {
              if (form.statusName == FormStatus.incomplete.toShortString()) {
                totalFormsIncomplete.add(form);
              }
            }
          }
          bool hasReachedMax = false;
          if(data.pageTotal != null && data.page != null) {
            hasReachedMax = data.pageTotal! <= data.page! || data.pageTotal == 0;
          }
          if (!hasReachedMax) {
            add(const FormIncompleteRequested());
          } else {
            emit(FormIncompleteFetched(totalFormsIncomplete));
          }
        }, error: (err) {
          emit(FormIncompleteFetchFail(err.message));
        });
      } else if (event is HomeUpdateStudy) {
        _page = 1;
        study = event.study;
        totalFormsIncomplete.clear();
        add(const FormIncompleteRequested());
      }
    });
  }

  reset() {
    _page = 1;
    study = null;
    totalFormsIncomplete.clear();
  }
}
