import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class Helpers {
  static const imageUrl = "https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Coat_of_arms_of_Sierra_Leone.svg/600px-Coat_of_arms_of_Sierra_Leone.svg.png";

  static Widget buildSilverAppBar(String title, String imgUrl) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: SizedBox(
            width: 200,
            child: AutoSizeText(
                title.toUpperCase(),
                maxLines: 4,
                minFontSize: 18.0,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18.0,)
            ),
          ),
          //background: Image.network("", fit: BoxFit.scaleDown,)
      )
    );
  }

  static Widget buildListLeadingText(String text) {
    return AutoSizeText(
      text,
      textAlign: TextAlign.start,
        style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold)
    );
  }

  Widget buildListTitle(String title) {
    return SizedBox(
      width: 200,
      child: AutoSizeText(
          title,
          minFontSize: 16.0,
          textAlign: TextAlign.start,
      ),
    );
  }

  static Widget buildListItemHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildListLeadingText(title),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              subtitle,
              minFontSize: 16.0,
              textAlign: TextAlign.left,
              //style: Theme.of(context).textTheme.body2,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListItemTitle(String title) {
    return SizedBox(
      width: 200,
      child: AutoSizeText(
          title,
          maxLines: 2,
          minFontSize: 16.0,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 16.0,)
      ),
    );
  }

  static Widget autoScrollTagContainer({AutoScrollController controller,int index, Widget child}) {
    return AutoScrollTag(
      key: ValueKey(index),
      controller: controller,
      index: index,
      child: child,
      highlightColor: Colors.black.withOpacity(0.1),
    );
  }

  static Widget buildAppBar(String appBarIconPath, String title) {
    return PreferredSize(
      preferredSize: Size.fromHeight(200.0),
      child: AppBar(
        elevation: 4.0,
        automaticallyImplyLeading: true, // hides leading widget
        flexibleSpace: _buildAppBarContent(appBarIconPath, title),
      ),
    );
  }

  static Widget _buildAppBarContent(String appBarIconPath, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
        ),
         Image.network(imageUrl, fit: BoxFit.fitHeight, height: 80,),
        Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(title.toUpperCase(),
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  )),
            )),
        //Text(_chapter.title),
      ],
    );
  }
}