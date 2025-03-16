import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ตรวจสอบสถานะการล็อกอิน
  User? get currentUser => _auth.currentUser;
  
  // รับ UID ของผู้ใช้ปัจจุบัน
  String get currentUserUid => _auth.currentUser?.uid ?? '';
  
  // ตรวจสอบว่ามีผู้ใช้ล็อกอินอยู่หรือไม่
  bool get isLoggedIn => _auth.currentUser != null;

  // ล็อกอินด้วยอีเมลและรหัสผ่าน
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  // สมัครบัญชีใหม่
  Future<User?> register(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // สร้างข้อมูลผู้ใช้เพิ่มเติมใน Firestore
      if (userCredential.user != null) {
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      
      return userCredential.user;
    } catch (e) {
      print("Register Error: $e");
      return null;
    }
  }

  // ออกจากระบบ
  Future<void> signOut() async {
    await _auth.signOut();
  }
}