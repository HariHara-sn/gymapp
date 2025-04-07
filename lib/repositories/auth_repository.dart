import 'package:dartz/dartz.dart';
import 'package:gymapp/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Either<String, String>> signUpWithEmail(
    String email,
    String pass,
    Map<String, dynamic> userData,
  ) async {
    try {
      final res = await _supabase.auth.signUp(email: email, password: pass);
      if (res.user != null) {
        // Insert additional user data in Supabase
        await _supabase.from('signup').insert({
          'gymId': res.user!.id,
          ...userData,
        });
      }
      return Right(res.user?.id ?? ""); //Success
    } catch (e) {
      return Left(e.toString()); // error
    }
  }

  Future<Either<String, String>> signInWithEmail(
    String email,
    String password,
  ) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return Left("Authentication failed. Please try again.");
      }

      return Right(response.user!.id); // Success, return user ID
    } on AuthException catch (e) {
      return Left(_mapSupabaseAuthError(e.message));
    } on Exception catch (e) {
      logger.e("Login Error: $e");
      return Left("An unexpected error occurred. Please try again.");
    }
  }

  String _mapSupabaseAuthError(String errorMessage) {
    if (errorMessage.contains("Invalid login credentials")) {
      return "Incorrect email or password. Please try again.";
    } else if (errorMessage.contains("Email not confirmed")) {
      return "Please verify your email before logging in.";
    } else if (errorMessage.contains("User not found")) {
      return "No account found with this email.";
    } else if (errorMessage.contains(
      "Password should be at least 6 characters",
    )) {
      return "Password must be at least 6 characters long.";
    } else if (errorMessage.contains("Too many requests")) {
      return "Too many login attempts. Please try again later.";
    } else if (errorMessage.contains("invalid_email")) {
      return "The email address is invalid.";
    } else if (errorMessage.contains("reset password")) {
      return "Unable to send reset link. Please try again later.";
    } else if (errorMessage.contains("User already registered")) {
      return "This email is already registered. Please login or reset password.";
    } else if (errorMessage.contains("Rate limit exceeded")) {
      return "Too many requests. Try again in a few minutes.";
    } else {
      return "Something went wrong. Please try again.";
    }
  }

  /// Sign in with Google
  Future<Either<String, void>> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(OAuthProvider.google);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> signOut() async {
    try {
      await _supabase.auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<void> forgotPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(
      email,
      redirectTo: 'https://nine-harvest-patio.glitch.me/',
    );
  }
}
