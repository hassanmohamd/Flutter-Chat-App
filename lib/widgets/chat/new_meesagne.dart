import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _message = '';
  final _editingController = TextEditingController();

  void _senMessage(String _message) async {
    FocusScope.of(context).unfocus();

    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection("users").document(user.uid).get();
    Firestore.instance.collection("chat").add({
      'text': _message,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      "username": userData['username'],
      "userIamge": userData['imageUrl'],
    });

    _editingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                autocorrect: true,
                enableSuggestions: true,
                textCapitalization: TextCapitalization.sentences,
                controller: _editingController,
                decoration: InputDecoration(
                  labelText: "send a message .. ",
                ),
                onChanged: (value) {
                  setState(() {
                    _message = value;
                  });
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
              onPressed:
                  _message.trim().isEmpty ? null : () => _senMessage(_message),
            )
          ],
        ),
      ),
    );
  }
}
