import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Hàm lấy job list của user hiện tại
Future<List<dynamic>> fetchUserJobs() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return []; // user chưa đăng nhập

  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('jobs')
      .get();

  // Chuyển thành List<Map<String, dynamic>>
  final jobs = snapshot.docs.map((doc) => doc.data()).toList();
  return jobs;
}
