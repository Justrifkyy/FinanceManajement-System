import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';
import 'package:runway_finance/services/notification_service.dart';

enum BrutalToastType {
  success,
  error,
  warning,
  info,
}

/// Sistem Notifikasi & Toast Neo-Brutalism
/// Menampilkan banner mengambang dengan animasi kinetik, getaran haptik,
/// border tebal, bayangan keras, dan countdown bar waktu aktif.
class BrutalToast {
  static OverlayEntry? _currentEntry;
  static Timer? _autoDismissTimer;

  static void showSuccess(
    BuildContext context, {
    required String title,
    String? message,
    bool pushToSystem = false,
    Duration duration = const Duration(milliseconds: 3200),
  }) {
    show(
      context,
      title: title,
      message: message,
      type: BrutalToastType.success,
      pushToSystem: pushToSystem,
      duration: duration,
    );
  }

  static void showError(
    BuildContext context, {
    required String title,
    String? message,
    bool pushToSystem = false,
    Duration duration = const Duration(milliseconds: 3800),
  }) {
    show(
      context,
      title: title,
      message: message,
      type: BrutalToastType.error,
      pushToSystem: pushToSystem,
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String title,
    String? message,
    bool pushToSystem = false,
    Duration duration = const Duration(milliseconds: 3500),
  }) {
    show(
      context,
      title: title,
      message: message,
      type: BrutalToastType.warning,
      pushToSystem: pushToSystem,
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String title,
    String? message,
    bool pushToSystem = false,
    Duration duration = const Duration(milliseconds: 3000),
  }) {
    show(
      context,
      title: title,
      message: message,
      type: BrutalToastType.info,
      pushToSystem: pushToSystem,
      duration: duration,
    );
  }

  static void dismiss() {
    _autoDismissTimer?.cancel();
    _autoDismissTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }

  static void show(
    BuildContext context, {
    required String title,
    String? message,
    required BrutalToastType type,
    bool pushToSystem = false,
    Duration duration = const Duration(milliseconds: 3200),
  }) {
    // 1. Kirim notifikasi sistem Android jika diminta
    if (pushToSystem) {
      try {
        final notifTitle = switch (type) {
          BrutalToastType.success => '✓ $title',
          BrutalToastType.error => '✖ $title',
          BrutalToastType.warning => '⚠ $title',
          BrutalToastType.info => 'ℹ $title',
        };
        NotificationService().showActionNotification(
          title: notifTitle,
          body: message ?? title,
          isError: type == BrutalToastType.error,
        );
      } catch (_) {}
    }

    // 2. Tampilkan di UI In-App Overlay
    final overlay = Overlay.of(context, rootOverlay: true);

    dismiss();

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _BrutalToastWidget(
        title: title,
        message: message,
        type: type,
        duration: duration,
        onDismiss: () {
          if (_currentEntry == entry) {
            dismiss();
          }
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);

    _autoDismissTimer = Timer(duration, () {
      if (_currentEntry == entry) {
        dismiss();
      }
    });
  }
}

class _BrutalToastWidget extends StatefulWidget {
  final String title;
  final String? message;
  final BrutalToastType type;
  final Duration duration;
  final VoidCallback onDismiss;

  const _BrutalToastWidget({
    required this.title,
    this.message,
    required this.type,
    required this.duration,
    required this.onDismiss,
  });

  @override
  State<_BrutalToastWidget> createState() => _BrutalToastWidgetState();
}

class _BrutalToastWidgetState extends State<_BrutalToastWidget>
    with TickerProviderStateMixin {
  late final AnimationController _enterController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  late final AnimationController _shakeController;
  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();

    // Haptic Feedback instan
    if (widget.type == BrutalToastType.error) {
      HapticFeedback.heavyImpact();
    } else if (widget.type == BrutalToastType.warning) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }

    // Slide & Scale In Animation
    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _enterController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = CurvedAnimation(
      parent: _enterController,
      curve: Curves.easeIn,
    );

    _enterController.forward();

    // Shake Animation untuk Error / Salah Input
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    if (widget.type == BrutalToastType.error) {
      _shakeController.forward();
    }

    // Progress Bar Countdown
    _progressController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..reverse(from: 1.0);
  }

  @override
  void dispose() {
    _enterController.dispose();
    _shakeController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _triggerDismiss() {
    _enterController.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top + 10;

    final (bgColor, tagText, tagBg, iconData) = switch (widget.type) {
      BrutalToastType.success => (
          BrutalTokens.safe,
          '✓ BERHASIL',
          BrutalTokens.paper,
          Icons.check_circle_outline_rounded
        ),
      BrutalToastType.error => (
          BrutalTokens.danger,
          '✖ SALAH INPUT / PERHATIAN',
          BrutalTokens.warn,
          Icons.error_outline_rounded
        ),
      BrutalToastType.warning => (
          BrutalTokens.warn,
          '⚠ PERINGATAN',
          BrutalTokens.paper,
          Icons.warning_amber_rounded
        ),
      BrutalToastType.info => (
          BrutalTokens.needs,
          'ℹ PEMBERITAHUAN',
          BrutalTokens.paper,
          Icons.info_outline_rounded
        ),
    };

    return Positioned(
      top: topPadding,
      left: 14,
      right: 14,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
              _triggerDismiss();
            }
          },
          child: AnimatedBuilder(
            animation: Listenable.merge([_enterController, _shakeController]),
            builder: (context, child) {
              // Shake offset untuk error
              final shakeOffset = widget.type == BrutalToastType.error && _shakeController.isAnimating
                  ? sin(_shakeController.value * 4 * pi) * 7.0
                  : 0.0;

              return Transform.translate(
                offset: Offset(shakeOffset, 0),
                child: SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: child,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(
                  color: BrutalTokens.ink,
                  width: BrutalTokens.borderBase,
                ),
                boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowMd),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Status Header Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: BrutalTokens.ink,
                          width: BrutalTokens.borderThin,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: tagBg,
                                border: Border.all(
                                  color: BrutalTokens.ink,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                tagText,
                                style: const TextStyle(
                                  fontFamily: BrutalTokens.fontNumbers,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                  color: BrutalTokens.ink,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'RUNWAY /// ALERT',
                              style: TextStyle(
                                fontFamily: BrutalTokens.fontUi,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                                color: BrutalTokens.ink,
                              ),
                            ),
                          ],
                        ),
                        // Close [✕] Button
                        InkWell(
                          onTap: _triggerDismiss,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: BrutalTokens.paper,
                              border: Border.all(
                                color: BrutalTokens.ink,
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: BrutalTokens.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content Body
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: BrutalTokens.paper,
                            border: Border.all(
                              color: BrutalTokens.ink,
                              width: BrutalTokens.borderThin,
                            ),
                            boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm),
                          ),
                          child: Icon(
                            iconData,
                            size: 24,
                            color: BrutalTokens.ink,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  fontFamily: BrutalTokens.fontUi,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.4,
                                  color: BrutalTokens.ink,
                                ),
                              ),
                              if (widget.message != null && widget.message!.isNotEmpty) ...[
                                const SizedBox(height: 3),
                                Text(
                                  widget.message!,
                                  style: const TextStyle(
                                    fontFamily: BrutalTokens.fontUi,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: BrutalTokens.ink,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Timer Countdown Bar
                  AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return Container(
                        height: 3.5,
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        color: BrutalTokens.ink.withValues(alpha: 0.2),
                        child: FractionallySizedBox(
                          widthFactor: _progressController.value.clamp(0.0, 1.0),
                          child: Container(
                            color: BrutalTokens.ink,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
