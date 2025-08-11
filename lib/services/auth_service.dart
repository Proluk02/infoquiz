// Service d'authentification Firebase : gère la connexion, l'inscription, la déconnexion, etc.
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Instance FirebaseAuth utilisée pour toutes les opérations
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Connexion d'un utilisateur avec email et mot de passe
  Future<User?> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  // Inscription d'un nouvel utilisateur
  Future<User?> signUp(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  // Envoi d'un email de réinitialisation de mot de passe
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Déconnexion de l'utilisateur
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Récupère l'utilisateur actuellement connecté (ou null)
  User? get currentUser => _auth.currentUser;
}
