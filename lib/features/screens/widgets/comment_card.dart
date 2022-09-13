import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              snap.data()['profilePic'],
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: snap.data()['name'],
                          style: theme.textTheme.subtitle2,
                        ),
                        TextSpan(
                          text: ' ${snap.data()['text']}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        snap.data()['datePublished'].toDate(),
                      ),
                      style: theme.textTheme.bodySmall,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
