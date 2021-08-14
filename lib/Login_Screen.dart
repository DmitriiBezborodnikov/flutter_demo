import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  CountdownController countdownController = CountdownController(duration: Duration(minutes: 1));

  bool _load = false;
  bool _load2 = false;
  bool isPhoneValid = false;
  String? errorPhoneMessage;
  String? errorCodeMessage;

  String fabText = 'Запросить смс';

  @override
  void initState() {
    super.initState();
    codeController.addListener(() async {
      if (codeController.text != '') {
        if (codeController.text == '1111') {
          _load2 = true;
          new Future.delayed(new Duration(seconds: 2), () async {
            errorCodeMessage = null;
            _load2 = false;

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('phone', phoneController.text);

            Navigator.of(context).pushReplacementNamed('/home');
          });

        } else {
          errorCodeMessage = 'Некорректный код из смс';
        }
      }

      setState(() {
      });
    });
    countdownController = CountdownController(duration: Duration(minutes: 1), onEnd: (() {
      fabText = 'Запросить смс';
      countdownController.value = Duration(minutes: 1).inMilliseconds;
      setState(() {});
    }));
    countdownController.addListener(() {
      int? secs = countdownController.currentRemainingTime.sec;
      if (secs != null && secs > 0) {
        fabText = secs.toString();
      } else {
        fabText = 'Запросить смс';
      }
      setState(() {});
    });
  }

  void onFabPressed() {
    if (phoneController.text == '+79998887766') {
      errorPhoneMessage = null;
      _load=true;
      setState(() {
        new Future.delayed(new Duration(seconds: 2), () {
          isPhoneValid = true;
          if (!countdownController.isRunning) {
            countdownController.start();
          }
          _load=false;
        });
      });
    } else {
      setState(() {
        isPhoneValid = false;
        errorPhoneMessage = 'Неверный номер телефона';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login Screen'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Test app',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    enabled: !_load && !countdownController.isRunning,
                    controller: phoneController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Phone number',
                      errorText: errorPhoneMessage,
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: _load ? Center(
                      child: CircularProgressIndicator(),
                    ) : RaisedButton(
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: Text(fabText),
                        onPressed: countdownController.isRunning ? null : onFabPressed
                    )
                ),
                Visibility(
                  visible: isPhoneValid,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                    child: TextField(
                      enabled: !_load2,
                      controller: codeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'SMS code',
                        errorText: errorCodeMessage,
                        helperText: '',
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _load2,
                  child: Center(
                      child: CircularProgressIndicator()
                  ),
                ),
              ],
            )
        ),
    );
  }

  @override
  void dispose() {
    countdownController.dispose();
    super.dispose();
  }
}