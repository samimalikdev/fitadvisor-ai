import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutrition_ai/services/api_controller.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class NutritionChatController extends GetxController {
  static String currentFoodContext = "";

  var messages = <ChatMessage>[
    ChatMessage(
      text:
          "Hello! I'm your elite AI Nutritionist. How can I guide your health and fitness goals today?",
      isUser: false,
    ),
  ].obs;

  var isLoading = false.obs;

  final ApiController _apiController = ApiController();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> sendMessage(String messageText) async {
    if (messageText.trim().isEmpty) return;

    messages.add(ChatMessage(text: messageText, isUser: true));

    messages.add(ChatMessage(text: "...", isUser: false));
    int replyIndex = messages.length - 1;

    isLoading.value = true;

    try {
      List<Map<String, dynamic>> historyPayload = [];
      for (int i = 0; i < messages.length - 2; i++) {
        historyPayload.add({
          'text': messages[i].text,
          'isUser': messages[i].isUser,
        });
      }

      final payload = {
        'message': messageText,
        'history': historyPayload,
      };

      if (currentFoodContext.isNotEmpty) {
        payload['foodContext'] = currentFoodContext;
      }

      final responseData = await _apiController.post('/ai/chat', payload);

      if (responseData != null && responseData['reply'] != null) {
        messages[replyIndex] = ChatMessage(
          text: responseData['reply'],
          isUser: false,
        );
      } else {
        messages[replyIndex] = ChatMessage(
          text: "I'm sorry, I encountered an error. Please try again.",
          isUser: false,
        );
      }
    } catch (e) {
      messages[replyIndex] = ChatMessage(
        text: "I'm sorry, I encountered an error. Please try again.",
        isUser: false,
      );
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}

class AskNutritionManagerScreen extends StatelessWidget {
  final TextEditingController userMessageController = TextEditingController();
  final NutritionChatController chatController = Get.put(
    NutritionChatController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Chat Assistant',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(decoration: const BoxDecoration(color: Colors.black)),
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(() {
                      return ListView.builder(
                        reverse: true,
                        itemCount: chatController.messages.length,
                        itemBuilder: (context, index) {
                          final reversedIndex =
                              chatController.messages.length - 1 - index;
                          final msg = chatController.messages[reversedIndex];
                          return _buildChatBubble(
                            msg.text,
                            isUser: msg.isUser,
                            context: context,
                          );
                        },
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: userMessageController,
                            style: GoogleFonts.poppins(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: GoogleFonts.poppins(
                                color: Colors.white54,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          if (userMessageController.text.isNotEmpty &&
                              !chatController.isLoading.value) {
                            chatController.sendMessage(
                              userMessageController.text,
                            );
                            userMessageController.clear();
                          }
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueAccent.withOpacity(0.5),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.send, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(
    String message, {
    required bool isUser,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser)
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.green,
              child: const Icon(Icons.assistant, color: Colors.white),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                        colors: [Color(0xFF2193B0), Color(0xFF6DD5ED)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : const LinearGradient(
                        colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isUser
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: isUser
                  ? Text(
                      message,
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 16),
                    )
                  : MarkdownBody(
                      data: message,
                      styleSheet: MarkdownStyleSheet(
                        p: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 15, height: 1.5),
                        h1: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                        h2: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                        h3: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        strong: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.w700),
                        em: GoogleFonts.poppins(
                            color: Colors.white70, fontStyle: FontStyle.italic),
                        listBullet: GoogleFonts.poppins(
                            color: Colors.amberAccent, fontSize: 18),
                        code: GoogleFonts.firaCode(
                            color: Colors.greenAccent,
                            backgroundColor: Colors.black45),
                        codeblockDecoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 8),
          if (isUser)
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.blueAccent,
              child: const Icon(Icons.person, color: Colors.white),
            ),
        ],
      ),
    );
  }
}
