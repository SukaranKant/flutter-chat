import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatefulWidget {
  const Messages({Key key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final documents = streamSnapshot.data.docs;

        return ListView.builder(
          reverse: true,
          itemCount: documents.length,
          itemBuilder: (ctx, index) => Container(
            padding: const EdgeInsets.all(8),
            child: MessageBubble(
              documents[index]['text'],
              documents[index]['username'],
              documents[index]['userId'] == FirebaseAuth.instance.currentUser.uid,
              key: ValueKey(documents[index].id),
            ),
          ),
        );
      },
    );
  }
}
