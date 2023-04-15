import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').snapshots(),
      builder: (context, snapshot) =>
      snapshot.connectionState == ConnectionState.waiting
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(itemBuilder: (context, index) => Text(snapshot.data!.docs[index]['text']),
        itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,),
    );
  }
}
