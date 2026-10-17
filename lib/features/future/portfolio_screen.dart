import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_button.dart';
import 'package:runway_finance/shared/widgets/brutal/page_headers.dart';
import 'package:runway_finance/shared/widgets/brutal/stamp.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  String _selectedRange = '6B';

  final List<Map<String, dynamic>> _assets = [
    {
      'name': 'Reksa Dana Pasar Uang',
      'type': 'REKSA DANA',
      'value': 'Rp 4.850.000',
      'gain': '+Rp 210.000',
      'tone': BrutalTokens.safe,
      'mark': 'RD',
    },
    {
      'name': 'Emas Digital',
      'type': 'EMAS',
      'value': 'Rp 3.200.000',
      'gain': '+Rp 430.000',
      'tone': BrutalTokens.goal,
      'mark': 'AU',
    },
    {
      'name': 'Laptop Kerja',
      'type': 'ASET FISIK',
      'value': 'Rp 8.000.000',
      'gain': 'Nilai manual',
      'tone': BrutalTokens.buffer,
      'mark': 'LP',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrutalTokens.canvas,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
          children: [
            DetailHeader(
              eyebrow: 'GROWTH MODE · V1.5',
              title: 'Portofolio & aset',
              onBack: () => context.pop(),
            ),

            // Net Worth Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BrutalTokens.safe,
                borderRadius: BrutalTokens.radiusZero,
                border: Border.all(
                  color: BrutalTokens.ink,
                  width: BrutalTokens.borderHeavy,
                ),
                boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowLg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TOTAL KEKAYAAN BERSIH',
                        style: TextStyle(
                          fontFamily: BrutalTokens.fontUi,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: BrutalTokens.ink,
                        ),
                      ),
                      Stamp(text: '↑ 4,8%', backgroundColor: BrutalTokens.paper),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Rp 29.480.000',
                    style: TextStyle(
                      fontFamily: BrutalTokens.fontNumbers,
                      fontSize: 31,
                      fontWeight: FontWeight.w800,
                      color: BrutalTokens.ink,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Naik Rp 1.340.000 dalam 6 bulan.',
                    style: TextStyle(
                      fontFamily: BrutalTokens.fontUi,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: BrutalTokens.ink,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Simulated Neo-Brutalist Line Chart
                  Container(
                    height: 105,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: BrutalTokens.ink,
                          width: BrutalTokens.borderBase,
                        ),
                      ),
                    ),
                    child: CustomPaint(
                      painter: _ChartPainter(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Range Picker
                  Row(
                    children: ['1B', '3B', '6B', '1T'].map((r) {
                      final isActive = _selectedRange == r;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedRange = r),
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: isActive ? BrutalTokens.paper : Colors.transparent,
                              border: isActive
                                  ? Border.all(
                                      color: BrutalTokens.ink,
                                      width: BrutalTokens.borderThin,
                                    )
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              r,
                              style: const TextStyle(
                                fontFamily: BrutalTokens.fontUi,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: BrutalTokens.ink,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Allocation Breakdown Bar
            Container(
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BrutalTokens.radiusZero,
                border: Border.all(
                  color: BrutalTokens.ink,
                  width: BrutalTokens.borderBase,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 42,
                    child: Container(color: BrutalTokens.needs),
                  ),
                  Container(width: BrutalTokens.borderThin, color: BrutalTokens.ink),
                  Expanded(
                    flex: 28,
                    child: Container(color: BrutalTokens.buffer),
                  ),
                  Container(width: BrutalTokens.borderThin, color: BrutalTokens.ink),
                  Expanded(
                    flex: 30,
                    child: Container(color: BrutalTokens.goal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Breakdown Legend
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ColoredBox(color: BrutalTokens.needs, child: SizedBox(width: 11, height: 11)),
                    SizedBox(width: 4),
                    Text('CASH 42%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
                  ],
                ),
                Row(
                  children: [
                    ColoredBox(color: BrutalTokens.buffer, child: SizedBox(width: 11, height: 11)),
                    SizedBox(width: 4),
                    Text('TABUNGAN 28%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
                  ],
                ),
                Row(
                  children: [
                    ColoredBox(color: BrutalTokens.goal, child: SizedBox(width: 11, height: 11)),
                    SizedBox(width: 4),
                    Text('ASET 30%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
                  ],
                ),
              ],
            ),

            const SectionTitle(title: 'Aset kamu', action: '+ TAMBAH'),

            // Asset List
            ..._assets.map((asset) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: BrutalTokens.paper,
                  borderRadius: BrutalTokens.radiusZero,
                  border: Border.all(
                    color: BrutalTokens.ink,
                    width: BrutalTokens.borderBase,
                  ),
                  boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowSm),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: asset['tone'] as Color,
                        border: Border.all(
                          color: BrutalTokens.ink,
                          width: BrutalTokens.borderThin,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        asset['mark'] as String,
                        style: const TextStyle(
                          fontFamily: BrutalTokens.fontNumbers,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: BrutalTokens.ink,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            asset['type'] as String,
                            style: const TextStyle(
                              fontFamily: BrutalTokens.fontUi,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              color: BrutalTokens.ink,
                            ),
                          ),
                          Text(
                            asset['name'] as String,
                            style: const TextStyle(
                              fontFamily: BrutalTokens.fontUi,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: BrutalTokens.ink,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            asset['gain'] as String,
                            style: const TextStyle(
                              fontFamily: BrutalTokens.fontUi,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF08782C),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      asset['value'] as String,
                      style: const TextStyle(
                        fontFamily: BrutalTokens.fontNumbers,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: BrutalTokens.ink,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward, size: 18, color: BrutalTokens.ink),
                  ],
                ),
              );
            }),
            const SizedBox(height: 18),

            // Portfolio Note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BrutalTokens.disabled,
                borderRadius: BrutalTokens.radiusZero,
                border: Border.all(
                  color: BrutalTokens.ink,
                  width: BrutalTokens.borderThin,
                  style: BorderStyle.solid,
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.lock_outline, size: 20, color: BrutalTokens.ink),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NILAI DIISI MANUAL',
                          style: TextStyle(
                            fontFamily: BrutalTokens.fontUi,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: BrutalTokens.ink,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Tanpa koneksi bank atau API harga. Privasi tetap milikmu.',
                          style: TextStyle(
                            fontFamily: BrutalTokens.fontUi,
                            fontSize: 11,
                            color: BrutalTokens.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Page CTA
            BrutalButton(
              text: 'TAMBAH ASET',
              variant: BrutalButtonVariant.primary,
              isFullWidth: true,
              icon: const Icon(Icons.add, size: 20, color: BrutalTokens.ink),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = BrutalTokens.ink
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = const Color(0x66FFFFFF)
      ..style = PaintingStyle.fill;

    final points = [
      Offset(0, size.height * 0.84),
      Offset(size.width * 0.14, size.height * 0.70),
      Offset(size.width * 0.28, size.height * 0.76),
      Offset(size.width * 0.43, size.height * 0.49),
      Offset(size.width * 0.57, size.height * 0.58),
      Offset(size.width * 0.72, size.height * 0.31),
      Offset(size.width * 0.86, size.height * 0.36),
      Offset(size.width, size.height * 0.10),
    ];

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
