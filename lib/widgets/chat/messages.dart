import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;

  Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              reverse: true,
              itemBuilder: (context, index) => MessageBubble(
                userName: snapshot.data!.docs[index]['userName'],
                message: snapshot.data!.docs[index]['text'],
                isMe: snapshot.data!.docs[index]['userId'] == user.uid,
                key: ValueKey(snapshot.data!.docs[index].id),
              ),
              itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
            ),
    );
  }
}
