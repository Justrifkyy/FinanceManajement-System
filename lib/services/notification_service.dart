import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:runway_finance/core/utils/money_formatter.dart';
import 'package:runway_finance/data/database/app_database.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  static const int idDailyLog = 100;
  static const int idFrugalMotivation = 200;
  static const int idInstantTest = 300;
  static const int idBufferRelease = 500;

  static const String channelId = 'runway_finance_reminders';
  static const String channelName = 'Pengingat & Motivasi Runway';
  static const String channelDescription = 'Notifikasi harian, tagihan, dan motivasi berhemat Runway Finance';

  /// Kumpulan kutipan & pesan pengingat berhemat acak (Neo-Brutalisme, santai, lugas, jujur)
  static const List<String> frugalQuotes = [
    'Ingat yaa berhemat! Masa depan cerah menanti mereka yang sabar menahan godaan jajan.',
    'Sebelum checkout keranjang belanja, tanya dirimu: ini Kebutuhan (Needs) atau cuma Keinginan (Wants)?',
    'Tahan dulu godaan jajan kopi & checkout! Setiap rupiah yang kamu simpan memperpanjang nafas runway-mu.',
    'Uang kas di rekening itu oksigen finansialmu. Jangan habiskan cuma demi gengsi sesaat!',
    'Puasa jajan hari ini = bebas cemas tanggal tua besok. Kamu pasti bisa!',
    'Godaan promo cuma 5 menit, tapi rasa sesal dompet kering bisa berminggu-minggu. Yuk berhemat!',
    'Kalkulator keringat mengingatkan: barang yang mau kamu beli setara berapa hari kerjamu? Pikirkan lagi!',
    'Uang dingin bikin pikiran tenang dan tidur nyenyak. Pertahankan streak puasa jajanmu!',
    'Cek aplikasi Runway sekarang: berapa hari daya tahan hidupmu hari ini? Amankan kasmu!',
    'Hemat bukan berarti pelit, tapi bijak menentukan prioritas hidup. Tetap semangat, pejuang!',
    'Tolak diskon barang yang sebenarnya tidak kamu butuhkan. Uangmu tetap utuh 100%!',
    'Beli masa depan yang tenang, bukan tumpukan barang yang cuma sesaat bikin senang.',
    'Uang yang tidak kamu belanjakan hari ini adalah modal kebebasanmu di masa depan.',
    'Sudah cek saldo amplop sebelum melangkah keluar? Belanja sesuai alokasi yaa!',
  ];

  /// Mengambil satu kutipan berhemat acak
  static String getRandomQuote() {
    final random = Random();
    return frugalQuotes[random.nextInt(frugalQuotes.length)];
  }

  /// Inisialisasi plugin notifikasi & zona waktu lokal
  Future<void> initialize() async {
    if (_isInitialized) return;

    // 1. Konfigurasi Timezone lokal (default Asia/Makassar UTC+8)
    tz.initializeTimeZones();
    try {
      if (!kIsWeb && !Platform.isWindows) {
        final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));
      } else {
        tz.setLocalLocation(tz.getLocation('Asia/Makassar'));
      }
    } catch (_) {
      try {
        tz.setLocalLocation(tz.getLocation('Asia/Makassar'));
      } catch (_) {}
    }

    // 2. Pengaturan Platform Android & iOS
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Callback saat notifikasi ditekan oleh pengguna
      },
    );

    // 3. Buat Channel Notifikasi Android
    const androidChannel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.high,
    );

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.createNotificationChannel(androidChannel);
    }

    _isInitialized = true;
  }

  /// Minta izin notifikasi runtime (Android 13+ & iOS)
  Future<bool> requestPermission() async {
    await initialize();

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final granted = await androidImplementation.requestNotificationsPermission();
      return granted ?? false;
    }

    final iosImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

    if (iosImplementation != null) {
      final granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true;
  }

  /// Tampilkan notifikasi langsung saat ini juga
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const darwinDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  /// Kirim notifikasi motivasi berhemat acak seketika (untuk tes atau pengingat spontan)
  Future<void> showRandomFrugalMotivation() async {
    final quote = getRandomQuote();
    await showNotification(
      id: idInstantTest,
      title: '💡 Ingat Yaa Berhemat!',
      body: quote,
    );
  }

  /// Kirim notifikasi pengingat evaluasi harian seketika
  Future<void> showDailyLogReminderNow() async {
    await showNotification(
      id: idDailyLog,
      title: '📝 Evaluasi Keuangan Hari Ini',
      body: 'Sudah catat pengeluaran hari ini? 1 menit mencatat, amankan harimu ke depan.',
    );
  }

  /// Jadwalkan pengingat harian (misal setiap malam jam 20:00 atau jam 12:30)
  Future<void> scheduleDailyReminder({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    await initialize();

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Jadwalkan notifikasi jatuh tempo langganan (H-3 dan H-0)
  Future<void> scheduleSubscriptionReminder({
    required int notificationSeq,
    required String name,
    required int amount,
    required DateTime dueDate,
  }) async {
    await initialize();

    final formattedAmount = MoneyFormatter.format(amount);

    // H-3 jam 09:00 pagi
    final hMinus3 = dueDate.subtract(const Duration(days: 3));
    final h3Date = tz.TZDateTime(
      tz.local,
      hMinus3.year,
      hMinus3.month,
      hMinus3.day,
      9,
      0,
    );

    if (h3Date.isAfter(tz.TZDateTime.now(tz.local))) {
      await _notificationsPlugin.zonedSchedule(
        id: notificationSeq * 10 + 1,
        title: '⏰ Tagihan Segera Datang: $name',
        body: 'Tagihan $name sebesar $formattedAmount jatuh tempo dalam 3 hari. Pastikan saldo amplop cukup!',
        scheduledDate: h3Date,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: channelDescription,
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }

    // H-0 jam 09:00 pagi
    final h0Date = tz.TZDateTime(
      tz.local,
      dueDate.year,
      dueDate.month,
      dueDate.day,
      9,
      0,
    );

    if (h0Date.isAfter(tz.TZDateTime.now(tz.local))) {
      await _notificationsPlugin.zonedSchedule(
        id: notificationSeq * 10 + 2,
        title: '🚨 Tagihan Jatuh Tempo Hari Ini: $name',
        body: 'Hari ini tagihan $name sebesar $formattedAmount jatuh tempo. Selesaikan dan catat agar runway akurat!',
        scheduledDate: h0Date,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: channelDescription,
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  /// Batalkan notifikasi langganan berdasarkan notificationSeq
  Future<void> cancelSubscriptionReminder(int notificationSeq) async {
    await _notificationsPlugin.cancel(id: notificationSeq * 10 + 1);
    await _notificationsPlugin.cancel(id: notificationSeq * 10 + 2);
  }

  /// Batalkan notifikasi tertentu berdasarkan ID
  Future<void> cancel(int id) async {
    await _notificationsPlugin.cancel(id: id);
  }

  /// Batalkan semua notifikasi
  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Jadwalkan ulang semua notifikasi (dipanggil saat aplikasi dibuka atau pengaturan diubah)
  Future<void> rescheduleAll(AppDatabase db) async {
    await initialize();

    final settingsDao = db.settingsDao;
    final subDao = db.subscriptionDao;

    // 1. Cek pengaturan pengingat harian
    final dailyReminderEnabled = await settingsDao.getBool('daily_reminder_enabled', defaultValue: true);
    if (dailyReminderEnabled) {
      await scheduleDailyReminder(
        id: idDailyLog,
        title: '📝 Evaluasi Keuangan Hari Ini',
        body: 'Sudah catat pengeluaran hari ini? 1 menit mencatat, amankan harimu ke depan.',
        hour: 20,
        minute: 0,
      );
    } else {
      await cancel(idDailyLog);
    }

    // 2. Cek pengaturan motivasi berhemat acak (siang hari pukul 12:30 waktu godaan jajan)
    final frugalMotivationEnabled = await settingsDao.getBool('frugal_motivation_enabled', defaultValue: true);
    if (frugalMotivationEnabled) {
      final randomQuote = getRandomQuote();
      await scheduleDailyReminder(
        id: idFrugalMotivation,
        title: '💡 Ingat Yaa Berhemat!',
        body: randomQuote,
        hour: 12,
        minute: 30,
      );
    } else {
      await cancel(idFrugalMotivation);
    }

    // 3. Jadwalkan ulang notifikasi semua langganan aktif
    try {
      final activeSubs = await subDao.getActiveSubscriptions();
      for (final sub in activeSubs) {
        if (sub.isActive) {
          final dueDate = DateTime.parse(sub.nextDueDate);
          await scheduleSubscriptionReminder(
            notificationSeq: sub.notificationSeq,
            name: sub.name,
            amount: sub.amount,
            dueDate: dueDate,
          );
        } else {
          await cancelSubscriptionReminder(sub.notificationSeq);
        }
      }
    } catch (_) {}
  }
}
