import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nomad/widgets/events/event_form.dart';
import 'package:nomad/widgets/events/event_preview.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:nomad/models/event/event.dart' as nomad_event;

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
                                  child: ChannelPage(channel: channel),
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

class ChannelPage extends StatefulWidget {
  final Channel channel;
  const ChannelPage({
    Key? key,
    required this.channel,
  }) : super(key: key);

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  final Map<String, nomad_event.Event> _eventMap = {};

  void _handleEventCreated(nomad_event.Event event) {
    // event id generated in firestore

    // Generate a numerical ID based on the size of the map
    int eventId = _eventMap.length;

    // Use the generated ID as the key in the map
    _eventMap[eventId.toString()] = event;

    widget.channel.sendMessage(
      Message(
        text: 'Event::${eventId.toString()};',
      ),
    );

    // Update the UI
    setState(() {});
  }

  void _openEventForm(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (
        BuildContext context,
      ) {
        return EventForm(
          onEventCreated: _handleEventCreated,
        );
      },
    );
  }

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
                final pattern =
                    RegExp(r'Event::([^\s;]+);', caseSensitive: false);

                if (details.message.text != null) {
                  final matches = pattern.allMatches(details.message.text!);

                  if (matches.isNotEmpty) {
                    for (var match in matches) {
                      final eventId = match.group(1);
                      if (_eventMap.containsKey(eventId)) {
                        final event = _eventMap[eventId];
                        return EventPreview(event: event!);
                      }
                    }
                  }
                }
                return defaultMessageWidget;
              },
            ),
          ),
          StreamMessageInput(
            actions: [
              InkWell(
                child: Icon(
                  Icons.bookmark_add,
                  size: 20.0,
                  color: Colors.grey[700],
                ),
                onTap: () {
                  // Do something here
                  _openEventForm(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
