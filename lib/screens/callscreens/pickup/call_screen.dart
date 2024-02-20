import 'dart:async';
import 'package:flutter/material.dart';
import 'package:voip_kit/voip_kit.dart';
import 'package:newapp/resources/local_db/call_methods.dart';

import '../../../models/call.dart';
import '../../../resources/local_db/call_methods.dart';

class CallScreen extends StatefulWidget {
  final Call call;

  CallScreen({required this.call});

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallMethods callMethods = CallMethods();
  final VoipClient voip = VoipClient();
  bool muted = false;
  List<Widget> _users = [];
  StreamSubscription<dynamic>? callStreamSubscription;

  @override
  void initState() {
    super.initState();
    initializeVoip();
  }

  Future<void> initializeVoip() async {
    try {
      await voip.initialize();
      await voip.joinChannel(widget.call.channelId);
      callStreamSubscription = voip.callStream.listen((event) {
        setState(() {
          _users = event['users'].map<Widget>((user) {
            return VoipClientRenderWidget(
              uid: user['uid'],
              mirror: false,
            );
          }).toList();
        });
      });
    } catch (e) {
      // Handle initialization errors
      print('Error initializing VoIP: $e');
    }
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    voip.mute(muted);
  }

  void _onSwitchCamera() {
    voip.switchCamera();
  }

  Widget _viewRows() {
    return Expanded(
      child: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (BuildContext context, int index) {
          return _users[index];
        },
      ),
    );
  }

  Widget _toolbar() {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic : Icons.mic_off,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => callMethods.endCall(
              call: widget.call,
            ),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _users.clear();
    voip.endCall();
    voip.leaveChannel();
    voip.dispose();
    callStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _viewRows(),
          _toolbar(),
        ],
      ),
    );
  }

  static VoipClient() {}
}
