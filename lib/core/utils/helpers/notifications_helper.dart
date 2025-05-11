import 'dart:developer' show log;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart' show Colors;

import '../../widgets/local_notification/controller/local_notifications_controller.dart';

class NotifyHelper {
  // جدولة الإشعار مع الصوت المخصص
  Future<void> scheduledNotification({
    required int reminderId,
    required String title,
    required String summary,
    required String body,
    required bool isRepeats,
    DateTime? time,
    Map<String, String?>? payload,
    int? soundIndex,
  }) async {
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();

    try {
      // إنشاء الإشعار مع الصوت الافتراضي إذا كان "bell"
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: reminderId,
          groupKey: 'prayers_notifications_group',
          channelKey: 'notifications_channel_ak_notification',
          actionType: ActionType.Default,
          title: title,
          summary: summary,
          body: body,
          payload: payload,
          wakeUpScreen: true,
          badge: LocalNotificationsController.instance.unreadCount,
          customSound: 'resource://raw/notification',
          // إذا كان "bell"، يتم استخدام الصوت الافتراضي للنظام
        ),
        schedule: time != null
            ? NotificationCalendar.fromDate(date: time, repeats: isRepeats)
            : NotificationInterval(
                interval: const Duration(minutes: 2),
                timeZone: localTimeZone,
                repeats: false,
              ),
      );

      log('Notification successfully scheduled', name: 'NotifyHelper');
    } catch (e, stackTrace) {
      log('Error scheduling notification: $e, $stackTrace',
          name: 'NotifyHelper');
    }
  }

  // تهيئة مكتبة Awesome Notifications
  static Future<void> initAwesomeNotifications() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/ic_notifications', // أيقونة الإشعار
      [
        NotificationChannel(
          channelKey: 'notifications_channel_ak_notification',
          channelName: 'Reminder Notifications',
          channelDescription: 'Notification channel for Reminder',
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          playSound: true,
          soundSource: 'resource://raw/notification',
        ),
      ],
      debug: true, // تمكين وضع التصحيح
    );

    log('Awesome Notifications Initialized and Channels Created',
        name: 'NotifyHelper');
  }

  Future<void> notificationBadgeListener() async {
    await AwesomeNotifications().getGlobalBadgeCounter().then((_) async {
      await AwesomeNotifications().setGlobalBadgeCounter(
        LocalNotificationsController.instance.unreadCount,
      );
    });
  }

  Future<void> cancelNotification(int notificationId) {
    log('Notification ID $notificationId was cancelled', name: 'NotifyHelper');
    return AwesomeNotifications().cancelSchedule(notificationId);
  }

  Future<void> requistPermissions() async {
    await AwesomeNotifications().isNotificationAllowed().then((
      isAllowed,
    ) async {
      if (!isAllowed) {
        // Get.dialog(
        //     const Text('please allow us to send you helpfull notifications'));
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  void setNotificationsListeners() {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    log(
      'Notification Created: ${receivedNotification.title}',
      name: 'NotifyHelper',
    );
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    log(
      'notificationDisplayed 2: ${receivedNotification.body}',
      name: 'NotifyHelper',
    );
    // log('audioPlayer.allowsExternalPlayback : ${PrayersNotificationsCtrl.instance.state.adhanPlayer.allowsExternalPlayback}',
    //     name: 'NotifyHelper');
    // if (prayerList.contains(receivedNotification.title!) ||
    //     receivedNotification.payload?['sound_type'] == 'sound') {
    //   await PrayersNotificationsCtrl.instance
    //       .fullAthanForIos(receivedNotification);
    // }
    if (receivedNotification.payload?['sound_type'] == 'sound') {
      // playAudio(receivedNotification.id, receivedNotification.title,
      //     receivedNotification.body);
    }
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    log('Notification Dismessed: ${receivedAction.body}', name: 'NotifyHelper');
    // notiCtrl.state.adhanPlayer.stop();
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    log(
      'Received Action: ${receivedAction.body} Received Action ID: ${receivedAction.id}',
      name: 'NotifyHelper',
    );
  }
}
