import 'package:chatapplication/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';


final _firestore = FirebaseFirestore.instance;

late User signedInUser;


class ChatScreen extends StatefulWidget {
  static const String screenRoute = 'chat_screen';

  var Idgroupe,Name;



 // const ChatScreen({Key? key , Idgroupe}) : super(key: key);

  ChatScreen ({super.key, required this.Idgroupe,required this.Name });


  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String? messageText;

  List<dynamic> UserList = [
    {"uid": "", "secondName": "", "email": "", "firstName": "", "Role": ""}
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    getUserNom();
    messsageStreams();
    print('dataime');
    print(DateTime.now());
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    user?.email;

    try {
      if (user != null) {
        signedInUser = user;
        signedInUser.email;
      }
    } catch (e) {
      print(e);
    }
  }

  getUserNom() async {
    List ListUserNom = [];
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get()
          .then((QuerySnapshot querySnapshot) => {
        querySnapshot.docs.forEach((doc) {
          ListUserNom.add(doc.data());
        }),
      });
      setState(() {
        UserList = ListUserNom;
      });

      print('Nom user connected  ');
      print(UserList[0]['firstName']);
      return UserList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }




  void messsageStreams() async {
    //.where('UidGroupe',isEqualTo:'Rk6xbMstHh64wwm1GBBH')
    await for (var snapshot in _firestore.collection('Message').where('UidGroupe',isEqualTo:widget.Idgroupe ).snapshots()) {
       for (var messages in snapshot.docs) {

         print('****************dataaaaa***************');
                        print(messages.data());
         print('****************dataaaaa***************');

       }
    }
  }


  getTimec(dynamic Mydate) {
    dynamic time = DateTime.fromMicrosecondsSinceEpoch(Mydate);

    String formattedDate =
    DateFormat('dd/MMM/yyyy hh:mm ').format(time);
    print(formattedDate);
    return formattedDate;
  }

  //name.test@live.com
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue[300],
        title: Row(
          children:  [
            //Image.asset('images/image.jpg', height: 25),
            const SizedBox(width: 20),
         Text(widget.Name)
          ],
        ),
       /* actions: [
          IconButton(
              onPressed: () {
                _auth.signOut();
                Navigator.pushNamed(context, SignInScreen.screenRoute);
                //_auth.signOut();
                // Navigator.pop(context);
              },
              icon: const Icon(Icons.close)
          )
        ],*/
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Image.asset("images/fontimage.jpg"),
             MessageStreamBuilder(Idgroupe: widget.Idgroupe),

            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.blueAccent,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: const InputDecoration(
                        //suffixIcon: IconButton(onPressed:() {messageTextController.clear();},
                        //   icon: Icon(Icons.photo)),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Ecrire votre message Ici ...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      messageTextController.clear();
                      if(messageText == null ){
                        return
                          MotionToast.error(
                            title: const Text(
                              'Error ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            description: const Text('Please enter your Message'),
                            animationType: AnimationType.fromLeft,
                            position: MotionToastPosition.bottom,
                            barrierColor: Colors.black.withOpacity(0.3),
                            width: 300,
                            height: 80,
                            dismissable: false,
                          ).show(context);

                      }

                      else {

                        _firestore.collection('Message').add({
                          'text': messageText,
                          'sender': signedInUser.email,
                          //'time': FieldValue.serverTimestamp(),
                           'time' : DateTime.now(),
                          'UidGroupe':widget.Idgroupe,
                          'Name' : UserList[0]['firstName'],
                        });
                        messageText =null;
                      }

                    },
                    label: const Text(' ') ,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  var Idgroupe;

    Convertdate(Timestamp time){
      DateTime date = time.toDate();
     var mydate = DateFormat('dd-MM-yyyy–hh:mm').format(date);

     return mydate ;
    }


  MessageStreamBuilder({super.key,required this.Idgroupe,
  });


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('Message')
           .where('UidGroupe',isEqualTo: this.Idgroupe ).orderBy('time', descending: true)
        .snapshots().handleError((error) => print(error.toString())),
      builder: (context, snapshot) {
        List<MessageLine> messageWidgets = [];
        if (!snapshot.hasData) {
         return const  Center(
             child: CircularProgressIndicator(
               backgroundColor: Colors.blue,
             ),
         );

        }

          final messages = snapshot.data!.docs;
          for (var message in messages) {
          final messageText = message.get('text');
          final messageSender = message.get('sender');
          final time = message.get('time');
          final Name = message.get('Name');
          final currentUser = signedInUser.email;



          final messgaeWidget = MessageLine(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender,
              Name: Name,
              time: Convertdate(time),
            );

          messageWidgets.add(messgaeWidget);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageWidgets,
          ),

        );
      },
    );
  }
}


//partie cors chat
class MessageLine extends StatelessWidget {

  // required this.TimeM
  const MessageLine({required this.isMe,this.text, this.sender,this.Name,required this.time, Key? key})
      : super(key: key);

  final String? sender;
  final String? Name;
  final String? text;
  final bool isMe;
  final dynamic time;

  //final dynamic TimeM;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$Name',
            style: const TextStyle(fontSize: 10, color:Colors.blue),
          ),
          Material(
              elevation: 5,
              borderRadius: isMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
              color: isMe ? Colors.blue[600] : Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  '$text',
                  style: TextStyle(
                      fontSize: 15,
                      color: isMe ? Colors.white : Colors.black45),
                ),
              )),
          const SizedBox(height: 8 ),
         Text('$time',
              style:TextStyle(fontSize: 9,color: Colors.grey ),

            ),
        ],
      ),
    );
  }
}
