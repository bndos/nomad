import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nomad/models/event/event.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createEvent(Event event) async {
    await _firestore.collection('events').add(event.toJson());
  }
}
