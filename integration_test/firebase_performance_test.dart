import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:integration_test/integration_test.dart';

Future<void> initializeFirebase() async {
  await Firebase.initializeApp();
}

Future<List<Map<String, String>>> fetchEmergencyContacts() async {
  List<Map<String, String>> contacts = [];
  String userId = getCurrentUserId();

  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('emergencyContacts')
        .get();

    for (var doc in snapshot.docs) {
      contacts.add({
        'name': doc['name'] ?? '',
        'phone': doc['phone'] ?? '',
        'email': doc['email'] ?? '',
        'relationship': doc['relationship'] ?? '',
      });
    }
  } catch (e) {
    print('Error fetching emergency contacts: $e');
  }
  return contacts;
}

String getCurrentUserId() {
  return 'testUserId';
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized(); // Initialize the binding

  setUpAll(() async {
    await initializeFirebase();
  });

  testWidgets('Measure time taken to fetch emergency contacts from Firebase', (WidgetTester tester) async {
    // Start the timer
    final stopwatch = Stopwatch()..start();

    // Fetch the emergency contacts
    await fetchEmergencyContacts();

    // Stop the timer
    stopwatch.stop();
    print('Time taken to fetch emergency contacts: ${stopwatch.elapsedMilliseconds} ms');

    // Assert that the time taken is within acceptable limits
    expect(stopwatch.elapsedMilliseconds, lessThan(10000)); // Example threshold
  });
}