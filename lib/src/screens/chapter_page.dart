import 'package:auto_size_text/auto_size_text.dart';
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
      body: _buildList(context),
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

  Widget s_buildSectionList(List<Section> sections) {
    return ListView(
      scrollDirection: _scrollDirection,
      controller: controller,
      children: sections.map<Widget>((section) {
        return ExpandableNotifier(
            child: ScrollOnExpand(
          scrollOnExpand: false,
          scrollOnCollapse: true,
          child: _buildListItem(context, section),
        ));
      }).toList(),
    );
  }


  Widget _buildPartSectionList(BuildContext context, List<ListItem> list) {
    return ListView.builder(
      scrollDirection: _scrollDirection,
      controller: controller,
      itemCount: list.length,
      itemBuilder: (context, index) {
        final listItem = list[index];
        
        if (listItem is PartHeadingItem) {
          return Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 20),
                child: AutoSizeText(
                  "PART ${listItem.number.toString()}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 5),
                  child: AutoSizeText(
                    listItem.heading,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.title,
                  ))
            ],
          );
          
        } else {
          return ExpandableNotifier(
              child: ScrollOnExpand(
                scrollOnExpand: false,
                scrollOnCollapse: true,
                child: _buildListItem(context, (listItem as SectionItem).section),
              ));
        }
      }
    );
  }

  Widget _buildList(BuildContext context) {
    List<ListItem> list = [];
    _chapter.parts.asMap().forEach((index, part) {
      String name = part.name;
      if(name != null) {
        int number = index + 1;
        list.add(PartHeadingItem(number, name));
      }
      for(var section in part.sections) {
        list.add(SectionItem(section));
      }
    });
    return _buildPartSectionList(context, list);
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
        ListTile(
            contentPadding: EdgeInsets.only(
              left: 10.0,
              top: 0.0,
              right: 10.0,
              bottom: 0.0,),
            title: Text(
              section.content,
              softWrap: true,
              textAlign: TextAlign.start,
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
                header: Helpers.buildListItemHeader("§ CHAPTER ${_chapter.id}. Section ${section.id}", section.title.toUpperCase()),
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
    );
  }
}

abstract class ListItem {}

class PartHeadingItem implements ListItem {
  final int number;
  final String heading;
  PartHeadingItem(this.number, this.heading);
}

class SectionItem implements ListItem {
  final Section section;
  SectionItem(this.section);
}