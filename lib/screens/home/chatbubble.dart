//------------------------------------------------------------------------------------
// The chat message balloon
//
//------------------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    Key? key,
    required this.text,
    required this.name,
    required this.type,
  });

  final String text;
  final String name;
  final bool type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: const CircleAvatar(child: Text('B')),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              name ?? "",
              style: GoogleFonts.poppins(
                color: Colors.black.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(text ?? "",
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 12,
                  )),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(name ?? "", ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(text ?? "",
                  style: GoogleFonts.poppins(
                    color: Colors.black.withOpacity(0.8),
                    fontSize: 12,
                  )),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
            child: Text(
          name[0] ?? "",
          style: GoogleFonts.poppins(
            color: Colors.black.withOpacity(0.8),
            fontSize: 12,
          ),
        )),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: type ?? false ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}
