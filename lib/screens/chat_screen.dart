import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/exwkvllfDrFVszvJhxXf/messages')
            .snapshots(),
        builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemBuilder: (context, index) => Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(snapshot.data!.docs[index]['text']),
                  ),
                  itemCount: snapshot.data!.docs.length,
                )
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: () {
            FirebaseFirestore.instance.collection('chats/exwkvllfDrFVszvJhxXf/messages').add({'text': 'Another text'});
          }, child: const Icon(Icons.add)),
    );
  }
}
