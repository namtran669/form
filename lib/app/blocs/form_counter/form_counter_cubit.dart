import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:talosix/app/blocs/form_incomplete/form_incomplete_bloc.dart';

part 'form_counter_state.dart';

class FormCounterCubit extends Cubit<FormCounterState> {
  FormCounterCubit(this._treatmentRepo) : super(FormCounterInitial());

  final PatientTreatmentRepo _treatmentRepo;

  countFormStatus(int registryId) async {
    final quantity = await _treatmentRepo.countFormByStatus(
      registryId,
      [FormStatus.complete.toShortString(), FormStatus.incomplete.toShortString()],
    );
    quantity.when(success: (data) {
      emit(FormStatusCounted(
        data[FormStatus.complete.toShortString()] ?? 0,
        data[FormStatus.incomplete.toShortString()] ?? 0,
      ));
    });
  }
}
