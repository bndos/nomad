import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  StreamChatClient? client;
  final String idUser = 'bndos';

  @override
  void initState() {
    super.initState();
    _initStreamConfig();
  }

  _initStreamConfig() async {
    String getStreamApiKey = dotenv.get('STREAM_API_KEY');

    client = StreamChatClient(
      getStreamApiKey,
      logLevel: Level.INFO,
    );

    await client!.connectUser(
      User(id: idUser),
      client!.devToken(idUser).rawValue,
    );

    setState(() {});
  }

  late final _listController = StreamChannelListController(
    client: client!,
    filter: Filter.in_(
      'members',
      [idUser],
    ),
    limit: 20,
  );

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamChat(
      client: client!,
      child: Scaffold(
        body: client == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Navigator(
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    builder: (context) {
                      return StreamChannelListView(
                        controller: _listController,
                        onChannelTap: (channel) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return StreamChannel(
                                  channel: channel,
                                  child: const ChannelPage(),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StreamChannelHeader(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(
              messageBuilder:
                  (context, details, messageList, defaultMessageWidget) {
                if (details.message.text != null &&
                    details.message.text!.startsWith('Event:')) {
                  // event interaction like location, time and type
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                details.message.text!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return defaultMessageWidget;
              },
            ),
          ),
          StreamMessageInput(
            actions: [
              InkWell(
                child: Icon(
                  Icons.location_on,
                  size: 20.0,
                  color: Colors.grey[700],
                ),
                onTap: () {
                  // Do something here
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
