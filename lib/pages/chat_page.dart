import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_chat/blocs/chat_bloc.dart';
import 'package:supabase_chat/constants/dimens.dart';
import 'package:supabase_chat/constants/strings.dart';
import 'package:supabase_chat/model/vos/messag_vo.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatBloc(),
      child: Consumer<ChatBloc>(
        builder: (context, bloc, child) => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blue,
            actions: [
              GestureDetector(
                  onTap: () {
                    bloc.logout(context);
                  },
                  child: const Icon(
                    Icons.logout,
                  )),
              const SizedBox(
                width: kMarginMedium2,
              )
            ],
          ),
          body: Column(
            children: [
              Expanded(
                  child: bloc.messageList == null
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        )
                      : ListView.builder(
                          itemCount: bloc.messageList?.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            return MessageView(
                              msg: bloc.messageList?[index] ?? MessageVo(),
                            );
                          },
                        )),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
                  child: Column(
                    children: [
                      Visibility(
                        visible: bloc.selectedImage != null,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.file(
                                File(bloc.selectedImage?.path ?? ''),
                              ),
                              GestureDetector(
                                onTap: () {
                                  bloc.removeImage();
                                },
                                child: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              bloc.onAddImage();
                            },
                            child: const Icon(
                              Icons.add_circle,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: kMarginMedium2,
                          ),
                          Expanded(
                              child: TextField(
                            controller: bloc.msgController,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            decoration: const InputDecoration(
                              hintText: "Send A Message",
                              hintStyle: TextStyle(
                                color: Colors.white54,
                              ),
                            ),
                          )),
                          const SizedBox(
                            width: kMarginMedium2,
                          ),
                          GestureDetector(
                            onTap: () {
                              bloc.send();
                            },
                            child: const Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MessageView extends StatelessWidget {
  final MessageVo msg;
  const MessageView({
    super.key,
    required this.msg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
        margin: const EdgeInsets.only(bottom: kMarginMedium2),
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: (msg.isUserMsg ?? false) ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                      visible: !(msg.isUserMsg ?? false),
                      child: Text(
                        msg.userEmail ?? '',
                        style: const TextStyle(color: Colors.black),
                      )),
                  Container(
                    decoration: BoxDecoration(
                      color: (msg.isUserMsg ?? false) ? Colors.blue : Colors.red,
                      borderRadius: BorderRadius.circular(kMarginMedium2),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2, vertical: kMarginMedium),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          msg.message ?? '',
                          style: const TextStyle(color: Colors.white, fontSize: kTextRegular2x),
                        ),
                        Visibility(
                          visible: msg.filePath != null,
                          child: Image.network("$SUPABASE_IMAGE_HOST_URL${msg.filePath}"),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ],
        ));
  }
}
