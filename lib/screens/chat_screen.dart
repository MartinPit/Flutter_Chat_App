import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          DropdownButton(
            items: const [
              DropdownMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Logout'),
                  ],
                ),
              )
            ],
            onChanged: (id) {
              if (id == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
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
                    )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('chats/exwkvllfDrFVszvJhxXf/messages')
                .add({'text': 'Another text'});
          },
          child: const Icon(Icons.add)),
    );
  }
}
