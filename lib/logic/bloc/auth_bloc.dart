import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
part 'auth_event.dart';
part 'auth_state.dart';



class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitialState()) {
    on<SignInEvent>(_onSignIn);
    on<SignUpEvent>(_onSignUp);
    on<SignOutEvent>(_onSignOut);
    on<ForgotPasswordEvent>(_onForgotPassword);
  }

 Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
  emit(AuthLoadingState()); // Show loading state

  final result = await authRepository.signInWithEmail(event.email, event.password);

  result.fold(
    (error) => emit(AuthFailureState(error)), // Emit failure with error message
    (userId) => emit(AuthSuccessState(userId)), // Emit success if login is successful
  );
}


  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final userId = await authRepository.signUpWithEmail(
        event.email,
        event.password,
        event.userData,
      );

      if (userId != null) {
        emit(AuthSuccessState(userId.toString()));
        
      } else {
        emit(AuthFailureState("Sign-up failed"));
      }
    } catch (e) {
      emit(AuthFailureState(e.toString()));
    }
  }
  

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      await authRepository.signOut();
      emit(AuthInitialState());
    } catch (e) {
      emit(AuthFailureState(e.toString()));
    }
  }

  Future<void> _onForgotPassword(ForgotPasswordEvent event, Emitter<AuthState> emit) async {
  emit(AuthLoadingState());
  try {
    await authRepository.forgotPassword(event.email);
    emit(ForgotPasswordSuccessState());
  } catch (e) {
    emit(ForgotPasswordFailureState(e.toString()));
  }
}

}