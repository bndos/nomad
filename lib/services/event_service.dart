import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nomad/models/event/event.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createEvent(Event event) async {
    await _firestore.collection('events').add(event.toJson());
  }

  Future<List<Event>> fetchAllEvents() async {
    QuerySnapshot querySnapshot = await _firestore.collection('events').get();
    return querySnapshot.docs
        .map((doc) => Event.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
