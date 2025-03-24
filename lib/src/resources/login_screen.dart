import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/src/blocs/login_bloc.dart';
import 'package:untitled/src/resources/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  LoginBloc bloc = new LoginBloc();
  bool _showPass = false;
  TextEditingController _userController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: Container(
                  width: 70,
                  height: 70,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffd8d8d8)
                  ),
                  child: FlutterLogo()),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
              child: Text("Hello\nWelcome Back", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 30

              ),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: StreamBuilder(
                stream: bloc.userStream,
                builder: (context, snapshot) =>TextField(
                style: TextStyle(fontSize: 18, color: Colors.black),
                controller: _userController,
                decoration: InputDecoration(
                    labelText: "USERNAME",
                    errorText: snapshot.hasError ? snapshot.error.toString() : null,
                    labelStyle: TextStyle(color: Color(0xff888888), fontSize: 15)),

              ))),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  StreamBuilder(
                      stream: bloc.passStream,
                      builder: (context, snapshot)=>TextField(
                    style: TextStyle(fontSize: 18, color: Colors.black),
                    controller: _passController,
                    obscureText: !_showPass,
                    decoration: InputDecoration(
                        labelText: "PASSWORD",
                        errorText: snapshot.hasError ? snapshot.error.toString() : null,
                        labelStyle: TextStyle(color: Color(0xff888888), fontSize: 15)),

                    ),
                  ),
                  GestureDetector(
                    onTap: onToggleShowPass,
                    child: Text(
                      _showPass ? "HIDE":"SHOW",
                      style: TextStyle(color: Colors.blue,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ] ,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onSigninClicked,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 5, // Độ bóng
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Bo góc
                    ),
                  ),
                  child: Text("SIGN IN",
                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Container(
              height: 65,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("NEW USER?SIGN UP",style: TextStyle(
                      fontSize:  15,
                      color: Color(0xff888888)),
                  ),
                  Text("FORGOT PASSWORD",style: TextStyle(
                      fontSize:  15,
                      color: Colors.blue),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  void onToggleShowPass(){
    setState(() {
      _showPass = !_showPass;
    });
  }
  void onSigninClicked() {
      if(bloc.isValidInfo(_userController.text, _passController.text)){
        Navigator.push(context,MaterialPageRoute(builder: (context) => HomePage()));
      }
    }
    Widget gotoHome(BuildContext context){
       return HomePage();
    }
  }

