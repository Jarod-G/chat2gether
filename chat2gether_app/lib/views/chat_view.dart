import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatView extends StatefulWidget {
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final msgCtrl = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  void sendMessage() async {
    if (msgCtrl.text.trim().isEmpty) return;

    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('messages').add({
      'text': msgCtrl.text.trim(),
      'userId': user.uid,
      'userEmail': user.email,
      'timestamp': FieldValue.serverTimestamp(),
    });

    msgCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat global'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messages')
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final msg = docs[index].data() as Map<String, dynamic>;
                      final isMe = msg['userId'] == _auth.currentUser?.uid;

                      return ListTile(
                        title: Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isMe ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              msg['text'] ?? '',
                              style: TextStyle(color: isMe ? Colors.white : Colors.black),
                            ),
                          ),
                        ),
                        subtitle: Align(
                          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                          child: Text(
                            msg['userEmail'] ?? '',
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: msgCtrl,
                      decoration: InputDecoration(hintText: 'Écris un message...'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: sendMessage,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
