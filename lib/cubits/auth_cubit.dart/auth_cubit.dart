import 'package:bloc/bloc.dart';
import 'auth_state.dart';
import 'package:notes_app/core/services/auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit(this.authService) : super(AuthInitial());

  Future<void> signIn(String email, String password) async {
    try {
      emit(AuthLoading());
      await authService.signIn(email, password);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      emit(AuthLoading());
      await authService.signUp(email, password);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    await authService.signOut();
    emit(AuthUnauthenticated());
  }

  void checkAuthStatus() {
    final user = authService.getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }
}
