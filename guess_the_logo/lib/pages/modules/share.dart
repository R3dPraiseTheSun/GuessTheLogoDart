import 'package:flutter/material.dart';
import 'package:share/share.dart';

import 'package:provider/provider.dart';

import '../../highscore/highscore.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({super.key});
  @override
  Widget build(BuildContext context) {
    String highscore = Provider.of<HighscoreProvider>(context).highscore.toString();
    return TextButton (
        onPressed: () => _onShare(context, 'Check out my Highscore ($highscore) on Guess The Logo', 'Highscore Update!'),
        child: const Text('Share'),
      );
  }
}

void _onShare(context, text, subject) async {
  final box = context.findRenderObject() as RenderBox?;

  await Share.share(
    text,
    subject: subject,
    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
  );
}
