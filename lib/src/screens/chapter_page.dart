import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:expandable/expandable.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:share/share.dart';

import '../../src/model/constitution.dart';
import '../helpers.dart';

class ChapterPage extends StatefulWidget {
  final Chapter chapter;
  final int initialScrollIndex;

  ChapterPage({Key key, @required this.chapter, this.initialScrollIndex})
      : super(key: key);

  @override
  _ChapterPageState createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  static const _appBarIconPath = "assets/graphics/splash_logo.jpg";
  static const _scrollAnimationDuration = 1000;
  final _scrollDirection = Axis.vertical;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  AutoScrollController controller;
  Chapter _chapter;
  List<Section> _sections = [];
  bool _isOnTop = true;

  @override
  void initState() {
    super.initState();
    // Initialise variables and listeners
    _chapter = widget.chapter;
    _sections.addAll(_chapter.getAllSections());
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: _scrollDirection);

    // Scroll to the selected section
    _jumpToIndex(widget.initialScrollIndex);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Helpers.buildAppBar(_appBarIconPath, _chapter.title),
      body: _buildList(),
      floatingActionButton: _buildNavigationActionButton(),
    );
  }

  int _findIndex(Section section) {
    return _sections.indexOf(section);
  }

  Future _jumpToIndex(int index) async {
    await controller.scrollToIndex(index,
        preferPosition: AutoScrollPosition.begin);
    controller.highlight(index);
  }

  void _scrollToBottom() {
    controller.animateTo(controller.position.maxScrollExtent,
        duration: Duration(milliseconds: _scrollAnimationDuration),
        curve: Curves.easeOut);
    setState(() => _isOnTop = false);
  }

  void _scrollToTop() {
    controller.animateTo(controller.position.minScrollExtent,
        duration: Duration(milliseconds: _scrollAnimationDuration),
        curve: Curves.easeIn);
    setState(() => _isOnTop = true);
  }

  Widget _buildList() {
    return ListView(
      scrollDirection: _scrollDirection,
      controller: controller,
      children: _sections.map<Widget>((section) {
        return ExpandableNotifier(
            child: ScrollOnExpand(
          scrollOnExpand: false,
          scrollOnCollapse: true,
          child: _buildListItem(context, section),
        ));
      }).toList(),
    );
  }

  Widget _buildNavigationActionButton() {
    return FloatingActionButton(
      onPressed: _isOnTop ? _scrollToBottom : _scrollToTop,
      child: Icon(_isOnTop ? Icons.arrow_downward : Icons.arrow_upward),
    );
  }

  Widget _buildListItemCollapsedContent(Section section) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        section.content,
        softWrap: true,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildListItemExpandedContent(Section section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              section.content,
              softWrap: true,
              overflow: TextOverflow.fade,
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
                child: Text('COPY TEXT'),
                onPressed: () {
                  Clipboard.setData(new ClipboardData(text: section.content));
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text("Section copied to Clipboard"),
                  ));
                }),
            FlatButton(
              child: Text('SHARE'),
              onPressed: () {
                Share.share('Check out this section ${section.content}');
              },
            ),
          ],
        )
      ],
    );
  }

  Widget _buildListItem(BuildContext context, Section section) {
    return Helpers.autoScrollTagContainer(
      controller: controller,
      index: _findIndex(section),
      child: Padding(
        padding: EdgeInsets.all(8.0),
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
                  //header: _buildListItemHeader(section),
                  // "§ Chapter $chapterIndex. Section $sectionNumber."
                  //            section.title, _chapter.number, section.number));
                  header: Helpers.buildListItemHeader("§ Chapter ${_chapter.number} Section ${section.number}", section.title),
                  collapsed: _buildListItemCollapsedContent(section),
                  expanded: _buildListItemExpandedContent(section),
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
        ),
      ),
    );
  }
}
