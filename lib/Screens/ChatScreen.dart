import 'package:chat_app/Constants/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Models/message.dart';
import '../Widgets/ChatBubble.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});

  static String id = 'ChatScreen';
  CollectionReference messages = FirebaseFirestore.instance.collection(KMessageCollections);
  TextEditingController messageController = TextEditingController();
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy(KCreatedTime, descending: true).snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            List<Message> messagesList = [];
            for (int i=0; i< snapshot.data!.docs.length; i++) {
              messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
            }
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Text(
                  'Chat App',
                  style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w600),
                ),
                centerTitle: true,
                backgroundColor: KPrimaryColor,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      controller: _controller,
                      itemCount: messagesList.length,
                        itemBuilder: (context,index){
                          return messagesList[index].id == email ?
                          ChatBubble(message: messagesList[index],) :
                          ChatBubbleFriend(message: messagesList[index],);
                        }
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      controller: messageController,
                      onSubmitted: (date) {
                        messages.add({
                          KMessage: date,
                          KCreatedTime: DateTime.now(),
                          KId: email
                        });
                        messageController.clear();
                        _controller.animateTo(
                            0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      },
                      decoration: InputDecoration(
                        suffixIcon: const Icon(Icons.send,color: KPrimaryColor,),
                        hintText: 'Message',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: KPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
    );
  }
}
