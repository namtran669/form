import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

part 'treatment_event.dart';
part 'treatment_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PatientTreatmentBloc extends Bloc<PatientTreatmentEvent, PatientTreatmentState> {
  final PatientTreatmentRepo _treatmentRepo;
  int _page = 1;
  Study? study;

  PatientTreatmentBloc(this._treatmentRepo) : super(const PatientTreatmentState()) {
    on<TreatmentFetched>(
      _onPatientFetched,
      transformer: throttleDroppable(throttleDuration),
    );

    on<PatientUpdateStudy>(
      _onSelectStudy,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  _onSelectStudy(
    PatientUpdateStudy event,
    Emitter<PatientTreatmentState> emit,
  ) async {
    _page = 1;
    study = event.study;
    emit(const PatientTreatmentState());
    add(TreatmentFetched());
  }

  Future<void> _onPatientFetched(
    TreatmentFetched event,
    Emitter<PatientTreatmentState> emit,
  ) async {
    if (state.hasReachedMax) return;
    if (study == null) return;

    final response =
        await _treatmentRepo.fetchTreatments(study!.registryId, _page++);
    response.when(success: (data) {
      List<Treatment> totalTreatments = List.of(state.treatments)..addAll(data.treatments!);
      for (var treatment in totalTreatments) {
        treatment.formData.sort((a, b) => a.formOrder.compareTo(b.formOrder));
      }
      emit(state.copyWith(
          status: LoadMoreStatus.success,
          treatments: totalTreatments,
          hasReachedMax: data.pageTotal == data.page));
    }, error: (err) {
      emit(state.copyWith(status: LoadMoreStatus.failure));
    });
  }

  reset() {
    _page = 1;
    study = null;
  }
}
