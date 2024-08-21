import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_chat/model/model.dart';
import 'package:supabase_chat/model/model_impl.dart';
import 'package:supabase_chat/model/vos/messag_vo.dart';
import 'package:supabase_chat/pages/log_in_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ChatBloc extends ChangeNotifier {
  bool isDisposed = false;

  bool? isLoggedIn;
  User? user = Supabase.instance.client.auth.currentUser;
  List<MessageVo>? messageList;

  ChatBloc() {
    getData();
    listenMsg();
  }

  TextEditingController msgController = TextEditingController();
  XFile? selectedImage;

  final Model _model = ModelImpl();

  void getData() async {
    await _model.getMessage().then(
      (value) {
        messageList = value;
        safeNotifyListeners();
        checkSendByUserMessage();
      },
    );

    safeNotifyListeners();
  }

  void listenMsg() {
    _model.listenNewMessage().listen(
      (newValue) {
        messageList = newValue ?? [];
        safeNotifyListeners();
        checkSendByUserMessage();
      },
    );
  }

  void checkSendByUserMessage() {
    messageList?.forEach(
      (element) {
        if (element.userId == user?.id) {
          element.isUserMsg = true;
        } else {
          element.isUserMsg = false;
        }
      },
    );
    safeNotifyListeners();
  }

  void onAddImage() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = image;
      safeNotifyListeners();
    }
  }

  void send() async {
    if (msgController.text.isNotEmpty) {
      await _model
          .sendMessage(
        message: msgController.text,
        userId: user?.id ?? '',
        userEmail: user?.email ?? '',
        file: selectedImage != null ? File(selectedImage?.path ?? '') : null,
      )
          .then(
        (value) {
          msgController.clear();
          selectedImage = null;
          safeNotifyListeners();
        },
      );
    }
  }

  void removeImage() {
    selectedImage = null;
    safeNotifyListeners();
  }

  void logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LogInPage()),
        (route) => false,
      );
    }
  }

  void safeNotifyListeners() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
