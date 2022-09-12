import 'package:flutter/material.dart';
import 'package:cluedin_app/models/notification.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key, required this.item});
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.symmetric(vertical: 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          onTap: () {},
          leading: CircleAvatar(
              backgroundImage: NetworkImage(item.imageUrl),
              child: const Text('DP')),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(
                  item.userRole,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 0.95,
                ),
                Text(" @${item.userName}",
                    textScaleFactor: 0.95,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(
                  width: 16,
                ),
              ]),
              const SizedBox(
                height: 1,
              ),
              Text(item.messageTitle,
                  textScaleFactor: 0.9,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              item.userMessage,
              textScaleFactor: 0.9,
            ),
          ),
          trailing: Text(
            item.dateOfExpiration,
            textAlign: TextAlign.end,
            textScaleFactor: 0.8,
          ),
        ),
      ),
    );
  }
}