import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

bool isDarkMode(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark;

void showFirebaseErrorSnack(
  BuildContext context,
  Object? error,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      content: Text(
        (error as FirebaseException).message ?? "Something went't wrong.",
      ),
    ),
  );
}

String getChatRoomId(String userId, String otherUserId) {
  return userId.hashCode <= otherUserId.hashCode
      ? '${userId}000$otherUserId'
      : '${otherUserId}000$userId';
}

String convertTimeStampToTime(int timeStamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  final now = DateTime.now();
  final difference = now.difference(date);
  if (difference.inDays > 0) {
    return "${date.day}/${date.month}/${date.year}";
  } else if (difference.inHours > 0) {
    return "${date.hour}:${date.minute}";
  } else if (difference.inMinutes == 0) {
    return "Just now";
  } else {
    return "${difference.inMinutes} minutes ago";
  }
}

bool isWithin2Minutes(int timeStamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  final now = DateTime.now();
  final difference = now.difference(date);
  return difference.inMinutes <= 2;
}
