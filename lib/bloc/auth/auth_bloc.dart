import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthBloc() : super(const AuthState()) {
    on<AuthLoginRequested>((event, emit) async {
      emit(const AuthState(status: AuthStatus.loading));
      try {
        await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        emit(const AuthState(status: AuthStatus.authenticated));
      } on FirebaseAuthException catch (e) {
        emit(AuthState(status: AuthStatus.error, errorMessage: _mapFirebaseError(e.code)));
      } catch (e) {
        emit(const AuthState(status: AuthStatus.error, errorMessage: 'An unexpected error occurred.'));
      }
    });

    on<AuthSignUpRequested>((event, emit) async {
      emit(const AuthState(status: AuthStatus.loading));
      try {
        UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        
        // Save the username to Firestore
        if (userCredential.user != null) {
          await _firestore.collection('users').doc(userCredential.user!.uid).set({
            'userName': event.userName,
            'email': event.email,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
        
        emit(const AuthState(status: AuthStatus.authenticated));
      } on FirebaseAuthException catch (e) {
        emit(AuthState(status: AuthStatus.error, errorMessage: _mapFirebaseError(e.code)));
      } catch (e) {
        emit(const AuthState(status: AuthStatus.error, errorMessage: 'An unexpected error occurred.'));
      }
    });

    on<AuthLogoutRequested>((event, emit) async {
      emit(const AuthState(status: AuthStatus.loading));
      await _firebaseAuth.signOut();
      emit(const AuthState(status: AuthStatus.initial));
    });
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
