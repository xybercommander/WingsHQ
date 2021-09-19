// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wings_hq/helper/helper_functions.dart';
import 'package:wings_hq/pages/private_chat/private_chat.dart';
import 'package:wings_hq/services/database_service.dart';

class HireProfessionalPage extends StatefulWidget {
  final String name;
  final String imgUrl;
  final String profession;
  final String about;  

  const HireProfessionalPage({ Key key, this.name, this.imgUrl, this.profession, this.about }) : super(key: key);

  @override
  _HireProfessionalPageState createState() => _HireProfessionalPageState();
}

class _HireProfessionalPageState extends State<HireProfessionalPage> {

  DatabaseService databaseMethods = DatabaseService();

  Razorpay razorpay;    

  getChatRoomId(String a, String b) {
    if(a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  String fullName = "";
  getName() async {
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        fullName = value;
      });
    });
  }  


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Payment is Successful');
    print('PAYMENT ID -----> ' + response.paymentId.toString());

    // Fluttertoast.showToast(
    //   msg: 'Payment was successful! :D',
    //   textColor: Colors.black,
    //   fontSize: 16,
    //   backgroundColor: Colors.grey[300]      
    // );

    Future.delayed(Duration(seconds: 2), () {
      // directing to private chat room
      var chatRoomId = getChatRoomId(fullName, widget.name);
      Map<String, dynamic> chatRoomInfoMap = {
        'users' : [fullName, widget.name]
      };
      databaseMethods.createChatRoom(chatRoomId, chatRoomInfoMap);

      Navigator.push(context, MaterialPageRoute(
        builder: (context) => PrivateChatScreen(widget.name),
      ));
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Error');
    print('PAYMENT ERROR -----> ' + response.message.toString());

    // Fluttertoast.showToast(
    //   msg: 'Payment was not successful :(',
    //   textColor: Colors.black,
    //   fontSize: 16,
    //   backgroundColor: Colors.grey[300]      
    // );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External Wallet');
    print('EXTERNAL WALLET -----> ' + response.walletName.toString());
  }

  void openCheckout() {
    var options = {
      "key": "rzp_test_KIvpZVV3hI9vHB",
      "amount": int.parse("100") * 100,
      "name": "Wings HQ",
      "description": "Payment for chat with professional",
      "external": {
        "wallets" : ["paytm"]
      } 
    };

    try {
      razorpay.open(options);
    } catch(e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getName();
    
    razorpay = Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }  

  @override
  void dispose() {    
    super.dispose();
    razorpay.clear();
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 400,
              padding: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imgUrl),
                  fit: BoxFit.cover                  
                )
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: MaterialButton(
                  elevation: 0,
                  onPressed: () => Navigator.pop(context),
                  shape: CircleBorder(),
                  color: Colors.black45,          
                  child: Icon(Icons.arrow_back, color: Colors.white,),
                ),
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(              
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.8,
                padding: EdgeInsets.only(top: 40, left: 16, right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name, 
                      style: TextStyle(
                        fontSize: 30, color: Colors.black
                      ),
                    ),
                    Text(
                      widget.profession, 
                      style: TextStyle(
                        fontSize: 25, color: Colors.grey[600]
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(
                      'About', 
                      style: TextStyle(
                        fontSize: 20, color: Colors.blue
                      ),
                    ),                    
                    SizedBox(height: 5,),
                    Text(
                      widget.about,
                      style: TextStyle(
                        color: Colors.grey[700], fontSize: 18
                      ),
                    ),
                    SizedBox(height: 50,),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 64,
                        height: 55,
                        child: MaterialButton(
                          onPressed: () {
                            openCheckout();
                          },
                          color: Colors.black,
                          elevation: 0,
                          child: Text('Pay & Chat', style: TextStyle(color: Colors.white, fontSize: 20),),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            )
          ],
          
        ),
      ),
    );
  }
}