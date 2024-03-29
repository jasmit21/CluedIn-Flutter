// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cluedin_app/models/home.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentChapterPage extends StatelessWidget {
  const StudentChapterPage({
    Key? key,
    required this.chapter,
  }) : super(key: key);
  final StudentChapters chapter;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          // appBar: SliverAppBar(),
          body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    const SliverAppBar(
                      floating: true,
                    )
                  ],
              body: Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, bottom: 54, top: 8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 8, bottom: 16),
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(30, 29, 29, 0.8),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Student Chapter",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8, bottom: 16),
                            decoration: const BoxDecoration(
                                color: Color.fromRGBO(30, 29, 29, 0.8),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Since ${chapter.establisedIn.toString()}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        chapter.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 28,
                            color: Color.fromARGB(255, 30, 29, 29)),
                      ),

                      //start

                      if (chapter.coverPic.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            child: Center(
                              child: CachedNetworkImage(
                                imageUrl: chapter.coverPic,
                                placeholder: (context, url) {
                                  return Image.asset(
                                    "assets/images/placeholder.png",
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                              // child: Image.asset(
                              //   "assets/images/csi.png",
                              //   fit: BoxFit.cover,
                              // ),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          chapter.desc,
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black)),
                              clipBehavior: Clip.hardEdge,
                              child: const Text(
                                "Visit Website for more Info",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                final url = Uri.parse(chapter.website);
                                if (!await launchUrl(url)) {
                                  throw 'Could not launch $url';
                                }
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ))),
    );
  }
}
