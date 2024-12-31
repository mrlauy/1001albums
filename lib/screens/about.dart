import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  static const String routeName = "/about";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: ListView(children: <Widget>[
        _buildTitle(context, '1001 Albums'),
        _buildIcon(context, Icons.adb),
        _buildVersion(context, 'v1.2.1'),
        _buildDescription(context, Theme.of(context).textTheme.bodyLarge!,
            '1001 Albums You Must Hear Before You Die'),
        _buildDescription(
            context,
            Theme.of(context).textTheme.bodyMedium!,
            '1001 Albums You Must Hear Before You Die is a musical reference '
            'book first published in 2005 by Universe Publishing. Part of '
            'the 1001 Before You Die series, it compiles writings and '
            'information on albums chosen by a panel of music critics to '
            'be the most important, influential, and best in popular music '
            'between the 1950s and the 2010s. The book is edited by '
            'Robert Dimery, an English writer and editor who had previously '
            'worked for magazines such as Time Out and Vogue.'),
        _buildDescription(context, Theme.of(context).textTheme.bodyLarge!,
            'Rolling Stone\'s 500 Greatest Albums of All Time'),
        _buildDescription(
            context,
            Theme.of(context).textTheme.bodyMedium!,
            '"The 500 Greatest Albums of All Time" is a recurring music ranking '
            'of the finest albums in history as compiled by the American '
            'magazine Rolling Stone. It is based on weighted '
            'votes from selected musicians, critics, and industry figures. The '
            'first list was published in a special issue of the magazine in 2003'
            ' and a related book in 2005.'),
        _buildDescription(context, Theme.of(context).textTheme.bodyMedium!,
            'Contact us with questions or feedback at support@brink-it.com.'),
        _buildFooter(context, 'powered by Brink-IT'),
      ]),
    );
  }

  Widget _buildTitle(BuildContext context, String title) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, IconData icon) {
    return Icon(icon);
  }

  Widget _buildVersion(BuildContext context, String version) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text(version, style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }

  Widget _buildDescription(
      BuildContext context, TextStyle style, String description) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Text(
        description,
        style: style,
      ),
    );
  }

  Widget _buildFooter(BuildContext context, String footer) {
    return Container(
      key: Key('footer'),
      padding: EdgeInsets.all(16.0),
      child: Center(
          child: Text(footer, style: Theme.of(context).textTheme.bodySmall)),
    );
  }
}
