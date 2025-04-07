import 'package:bloc/bloc.dart';

import '../../Screens/Dashboard/models/dashboard_model.dart';
import '../../repositories/dashboard_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository repository;

  DashboardCubit({required this.repository}) : super(DashboardInitial());

  void loadInitialData() {
    emit(DashboardLoaded(
      exercises: [],
      notices: [],
      upiId: 'abiramig070-1@okicici',
      amount: '100',
      qrReference: _generateQRCode('abiramig070-1@okicici', '100'),
    ));
  }

  void addExercise() {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      final newExercises = List<Exercise>.from(currentState.exercises)
        ..add(Exercise(title: '', description: ''));
      emit(DashboardLoaded(
        exercises: newExercises,
        notices: currentState.notices,
        upiId: currentState.upiId,
        amount: currentState.amount,
        qrReference: currentState.qrReference,
      ));
    }
  }

  void addNotice() {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      final newNotices = List<Notice>.from(currentState.notices)
        ..add(Notice(title: '', description: ''));
      emit(DashboardLoaded(
        exercises: currentState.exercises,
        notices: newNotices,
        upiId: currentState.upiId,
        amount: currentState.amount,
        qrReference: currentState.qrReference,
      ));
    }
  }

  void updateUPI(String upiId, String amount) {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(DashboardLoaded(
        exercises: currentState.exercises,
        notices: currentState.notices,
        upiId: upiId,
        amount: amount,
        qrReference: _generateQRCode(upiId, amount),
      ));
    }
  }

  void saveData() async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(DashboardLoading());
      try {
        await repository.saveDataToSupabase(
            currentState.exercises, currentState.notices, currentState.upiId, currentState.amount);
        emit(currentState); 
      } catch (e) {
        emit(DashboardError(e.toString()));
      }
    }
  }

  static String _generateQRCode(String upiId, String amount) {
    return "upi://pay?pa=$upiId&am=$amount&cu=INR";
  }
}
