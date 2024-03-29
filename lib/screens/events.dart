// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'package:cluedin_app/models/events.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:navbar_router/navbar_router.dart';
import 'package:retry/retry.dart';
import '../widgets/eventsCard.dart';
import '../widgets/offline.dart';
import 'login_page.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  List<Events> filter(List<Events> events, laBels, senders) {
    if (!_filters.contains("Technical")) {
      _senders.clear();
    }
    return events
        .where((event) =>
            (laBels.isEmpty || laBels.contains(event.eventLabel)) &&
            (senders.isEmpty || senders.contains(event.organizedBy)))
        .toList();
  }

  StreamSubscription? internetconnection;
  bool isoffline = false;
  bool showFrom = false;
  //set variable for Connectivity subscription listiner

  final url = "http://128.199.23.207:5000/api/app/appEvent";
  // final url =
  //     "https://gist.githubusercontent.com/tushar4303/675432e0e112e258c971986dbca37156/raw/9352579f1a97a046a7a9917b2e9a596f4ddc4ee0/events.json";
  final _filters = [];
  final _senders = [];
  final List<Events> _filteredEvents = [];
  late Future<List<Events>?> myfuture;

  @override
  void initState() {
    internetconnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        //connection is mobile data network
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        //connection is from wifi
        setState(() {
          isoffline = false;
        });
      }
    }); // using this listiner, you can get the medium of connection as well.
    super.initState();
    myfuture = loadEvents();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Events>?> loadEvents() async {
    var token = Hive.box('userBox').get("token");
    const r = RetryOptions(maxAttempts: 3);
    final response = await r.retry(
      // Make a GET request
      () => http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 2)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    try {
      if (response.statusCode == 200) {
        final EventsJson = response.body;
        final decodedData = jsonDecode(EventsJson);
        // print(decodedData);
        var eventsData = decodedData["events"];
        print(eventsData);
        var labelsData = decodedData["labels"];
        var organizersData = decodedData["organizers"];

        EventModel.labels = List.from(labelsData);
        EventModel.organizers = List.from(organizersData);

        EventModel.events = List.from(eventsData)
            .map<Events>((event) => Events.fromMap(event))
            .toList();

        print(EventModel.events);

        setState(() {
          _filters.clear();
          _senders.clear();
          showFrom = false;
          _filteredEvents.clear();

          _filteredEvents
              .addAll(filter(EventModel.events!, _filters, _senders));
        });

        return EventModel.events;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        var errorJson = json.decode(response.body);
        var error = '';
        if (errorJson['msg'] != null && errorJson['msg'].isNotEmpty) {
          error = errorJson['msg'];
          NavbarNotifier.hideBottomNavBar = true;
          // ignore: use_build_context_synchronously
          // Navigator.of(context, rootNavigator: true).pop();
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (c) => const LoginPage()),
              (r) => false);
          final box = await Hive.openBox("UserBox");
          await box.clear();
        }
        Fluttertoast.showToast(
          msg: error,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      } else {
        final error = response.body;
        final decodedData = jsonDecode(error);
        // print(decodedData);
        var message = decodedData["msg"];
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
        );
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: MediaQuery.of(context).size.height * 0.125,
        elevation: 0.3,
        // title: Text("Notifications"),
        title: Transform(
          transform: Matrix4.translationValues(8.0, 16.0, 0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Events",
                textAlign: TextAlign.left,
                textScaleFactor: 1.3,
                style: TextStyle(color: Color.fromARGB(255, 30, 29, 29)),
              ),
              const SizedBox(
                height: 4,
              ),
              (EventModel.labels != null && EventModel.labels!.isNotEmpty)
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Transform(
                              transform: Matrix4.translationValues(0, -4, 0),
                              child: Visibility(
                                visible: showFrom,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: ActionChip(
                                    onPressed: () async {
                                      await showModalBottomSheet(
                                          isScrollControlled: true,
                                          isDismissible: true,
                                          useRootNavigator: true,
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (context) =>
                                              DraggableScrollableSheet(
                                                  expand: false,
                                                  key: UniqueKey(),
                                                  initialChildSize: 0.4,
                                                  maxChildSize: 0.6,
                                                  builder:
                                                      (context, controller) =>
                                                          Container(
                                                            decoration: const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            20.0))),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 8,
                                                                      bottom:
                                                                          8),
                                                                  width: 40.0,
                                                                  height: 5.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: ListView
                                                                      .builder(
                                                                    itemCount: EventModel
                                                                        .organizers!
                                                                        .length,
                                                                    controller:
                                                                        controller,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return Column(
                                                                        children: [
                                                                          ListTile(
                                                                            visualDensity:
                                                                                const VisualDensity(vertical: -2.5),
                                                                            title:
                                                                                Text(EventModel.organizers![index]),
                                                                            selected:
                                                                                _senders.contains(EventModel.organizers![index]),
                                                                            selectedColor:
                                                                                Colors.blueAccent,
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                if (!_senders.contains(EventModel.organizers![index])) {
                                                                                  _senders.add(EventModel.organizers![index]);
                                                                                } else {
                                                                                  _senders.removeWhere((name) {
                                                                                    return name == EventModel.organizers![index];
                                                                                  });
                                                                                }
                                                                                _filteredEvents.clear();
                                                                                _filteredEvents.addAll(filter(EventModel.events!, _filters, _senders));
                                                                              });
                                                                            },
                                                                          ),
                                                                          Divider(
                                                                            thickness:
                                                                                0.5,
                                                                            color:
                                                                                Colors.grey.withOpacity(0.3),
                                                                          )
                                                                        ],
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )));
                                    },
                                    label: const Text("From"),
                                    avatar: const Icon(
                                      Icons.auto_awesome,
                                      color: Colors.black,
                                    ),
                                    visualDensity:
                                        const VisualDensity(vertical: -1.5),
                                    side: const BorderSide(
                                        width: 1,
                                        color: Color.fromARGB(66, 75, 74, 74)),
                                    // surfaceTintColor: Colors.black,

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: (EventModel.labels!.map((filterType) {
                                return Transform(
                                    transform: Matrix4.identity()..scale(0.85),
                                    child: FilterChip(
                                        checkmarkColor: Colors.black,
                                        label: Text(
                                          filterType,
                                          textScaleFactor: 1.1,
                                        ),
                                        // labelPadding: EdgeInsets.symmetric(
                                        //     horizontal: 4, vertical: 0),
                                        selected: _filters.contains(filterType),
                                        side: const BorderSide(
                                            width: 1,
                                            color:
                                                Color.fromARGB(66, 75, 74, 74)),
                                        // surfaceTintColor: Colors.black,

                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        selectedColor: const Color.fromARGB(
                                            180, 224, 220, 220),
                                        onSelected: ((value) {
                                          setState(() {
                                            if (value) {
                                              _filters.clear();
                                              _filters.add(filterType);
                                            } else {
                                              _filters.removeWhere((name) {
                                                return name == filterType;
                                              });
                                            }
                                            print(_filters);

                                            showFrom =
                                                _filters.contains("Technical");

                                            _filteredEvents.clear();
                                            _filteredEvents.addAll(filter(
                                                EventModel.events!,
                                                _filters,
                                                _senders));
                                          });
                                        })));
                              }).toList()),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                      color: Colors.white,
                    )),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            child: errmsg("No Internet Connection Available", isoffline),
            //to show internet connection message on isoffline = true.
          ),
          Expanded(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: FutureBuilder(
                    future: myfuture,
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return RefreshIndicator(
                            onRefresh: () async {
                              loadEvents();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 54, top: 4),
                              child: GridView.builder(
                                itemCount: _filteredEvents.length,
                                itemBuilder: (context, index) {
                                  return EventsWidget(
                                    event: _filteredEvents[index],
                                  );
                                },
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 16.0,
                                        mainAxisSpacing: 12.0,
                                        mainAxisExtent: 310.0),
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.035,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 0),
                                child: SvgPicture.asset(
                                  "assets/images/offline.svg",
                                  height:
                                      MediaQuery.of(context).size.height * 0.45,
                                ),
                              ),
                              const Text(
                                'Well this is awkward!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 30, 29, 29)),
                              ),
                              const Text(
                                'We dont seem to be connected...',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 30, 29, 29)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      visualDensity: VisualDensity.comfortable,
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black)),
                                  clipBehavior: Clip.hardEdge,
                                  child: const Text(
                                    "Try again",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      myfuture = loadEvents();
                                    });
                                  },
                                ),
                              )
                            ],
                          );
                        }
                      }
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      );
                    }))),
          ),
        ],
      ),
      // ignore: prefer_const_literals_to_create_immutables
    );
  }
}

// class _showRoleFilterSheet extends StatelessWidget {
//   const _showRoleFilterSheet({
//     Key? key,
//     required List senders,
//   })  : _senders = senders,
//         super(key: key);

//   final List _senders;

//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//         expand: false,
//         key: UniqueKey(),
//         initialChildSize: 0.4,
//         maxChildSize: 0.6,
//         builder: (context, controller) => Container(
//               decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(20.0),
//                       topRight: Radius.circular(20.0))),
//               child: Column(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(top: 8, bottom: 8),
//                     width: 40.0,
//                     height: 5.0,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       color: Colors.grey,
//                     ),
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: EventModel.senderRoles!.length,
//                       controller: controller,
//                       itemBuilder: (BuildContext context, int index) {
//                         return Column(
//                           children: [
//                             ListTile(
//                               visualDensity:
//                                   const VisualDensity(vertical: -2.5),
//                               title: Text(EventModel.senderRoles![index]),
//                               trailing: Visibility(
//                                   visible: _senders
//                                       .contains(EventModel.senderRoles![index]),
//                                   child: const Icon(Icons.check)),
//                               onTap: () {},
//                             ),
//                             Divider(
//                               thickness: 0.5,
//                               color: Colors.grey.withOpacity(0.3),
//                             )
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ));
//   }
// }
