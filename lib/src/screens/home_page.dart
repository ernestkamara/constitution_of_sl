import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:constitution_of_sl/src/screens/chapter_page.dart';
import 'package:constitution_of_sl/src/model/constitution.dart';

import '../helpers.dart';

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, @required this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _appBarIconPath = "assets/graphics/splash_logo.png";
  final scrollDirection = Axis.vertical;

  AutoScrollController controller;
  List<Chapter> _chapters = [];
  final Firestore store = firestore();

  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery
                .of(context)
                .padding
                .bottom),
        axis: scrollDirection);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('You are going to exit the application!!'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scaffold(
            appBar: Helpers.buildAppBar(_appBarIconPath, widget.title),
            body: _buildContent(context)));
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: store.collection('chapters').onSnapshot,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: new CircularProgressIndicator());
              default:
                return ListView(
                  scrollDirection: scrollDirection,
                  controller: controller,
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    Chapter chapter = Chapter.fromDocumentSnapshot(document);
                    return ExpandableNotifier(
                        child: ScrollOnExpand(
                          scrollOnExpand: false,
                          scrollOnCollapse: true,
                          child: _buildChapterItem(context, chapter),
                        ));
                  }).toList(),
                );
            }
          }),
    );
  }

  Widget _buildChapterItem(BuildContext context, Chapter chapter) {
    return Helpers.autoScrollTagContainer(
        controller: controller,
        index: _chapters.indexOf(chapter),
        //child: ChapterItem(context, chapter)
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              ScrollOnExpand(
                scrollOnExpand: true,
                scrollOnCollapse: false,
                child: ExpandablePanel(
                  tapHeaderToExpand: true,
                  tapBodyToCollapse: true,
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  header: Helpers.buildListItemHeader("§ CHAPTER ${chapter.id}", chapter.title),
                  expanded: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        for (final section in chapter.getAllSections())
                          Container(
                            child: ListTile(
                                contentPadding: const EdgeInsets.only(
                                  left: 10.0,
                                  top: 0.0,
                                  right: 10.0,
                                  bottom: 0.0,
                                ),
                                title: Text(section.title,
                                    softWrap: true, overflow: TextOverflow.fade),
                                onTap: () {
                                  navigateToSectionPage(context, chapter,
                                      chapter.getAllSections().indexOf(section));
                                }),
                          ),
                      ],
                    ),
                  ),
                  builder: (_, collapsed, expanded) {
                    return Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: Expandable(
                        collapsed: collapsed,
                        expanded: expanded,
                        crossFadePoint: 0,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Future navigateToSectionPage(BuildContext context, Chapter chapter,
      int scrollIndex) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChapterPage(
                chapter: chapter, initialScrollIndex: scrollIndex)));
  }
}
