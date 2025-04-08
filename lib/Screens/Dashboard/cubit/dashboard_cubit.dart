import 'package:gymapp/Screens/Dashboard/model/dashboard_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../repository/dashboard_repo.dart';
part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository repository;

  DashboardCubit({required this.repository}) : super(DashboardInitial());

  Future<void> fetchPaymentDetails() async {
    emit(DashboardLoading());
    try {
      final payment = await repository.getPaymentDetails();
      emit(DashboardLoaded(payment: payment));
    } catch (e) {
      emit(DashboardError('Failed to fetch payment details: $e'));
    }
  }

  Future<void> saveExercises(List<ExerciseModel> exercises) async {
    emit(DashboardSaving());
    try {
      await repository.saveExercises(exercises);
      emit(DashboardSaved());
    } catch (e) {
      emit(DashboardError('Failed to save exercises: $e'));
    }
  }

  Future<void> saveNotices(List<NoticeModel> notices) async {
    emit(DashboardSaving());
    try {
      await repository.saveNotices(notices);
      emit(DashboardSaved());
    } catch (e) {
      emit(DashboardError('Failed to save notices: $e'));
    }
  }

  Future<void> updatePayment(PaymentModel payment) async {
    emit(DashboardSaving());
    try {
      await repository.updatePaymentDetails(payment);
      emit(DashboardSaved());
    } catch (e) {
      emit(DashboardError('Failed to update payment: $e'));
    }
  }
}