import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:runway_finance/core/theme/brutal_tokens.dart';
import 'package:runway_finance/core/utils/money_formatter.dart';
import 'package:runway_finance/domain/entities/envelope_entity.dart';
import 'package:runway_finance/providers/repository_providers.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_button.dart';
import 'package:runway_finance/shared/widgets/brutal/page_headers.dart';
import 'package:runway_finance/shared/widgets/brutal/brutal_toast.dart';

class ManageEnvelopesScreen extends ConsumerStatefulWidget {
  const ManageEnvelopesScreen({super.key});

  @override
  ConsumerState<ManageEnvelopesScreen> createState() => _ManageEnvelopesScreenState();
}

class _ManageEnvelopesScreenState extends ConsumerState<ManageEnvelopesScreen> {
  String _selectedFilter = 'all'; // all, needs, wants

  @override
  Widget build(BuildContext context) {
    final envelopeRepo = ref.watch(envelopeRepositoryProvider);

    return Scaffold(
      backgroundColor: BrutalTokens.canvas,
      body: SafeArea(
        child: StreamBuilder<List<EnvelopeEntity>>(
          stream: envelopeRepo.watchActiveEnvelopes(),
          builder: (context, snapshot) {
            final allEnvelopes = snapshot.data ?? [];
            final userEnvelopes = allEnvelopes.where((e) => !e.isSystem).toList();

            final filtered = _selectedFilter == 'all'
                ? userEnvelopes
                : userEnvelopes.where((e) {
                    if (_selectedFilter == 'needs') {
                      return e.category == EnvelopeCategory.needs;
                    } else {
                      return e.category == EnvelopeCategory.wants;
                    }
                  }).toList();

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 22.0),
              children: [
                DetailHeader(
                  eyebrow: 'ATUR POS UANGMU',
                  title: 'Kelola amplop',
                  onBack: () => context.pop(),
                ),

                // Info Strip
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: BrutalTokens.paper,
                    borderRadius: BrutalTokens.radiusZero,
                    border: Border.all(
                      color: BrutalTokens.ink,
                      width: BrutalTokens.borderBase,
                    ),
                    boxShadow: BrutalTokens.hardShadow(offset: BrutalTokens.shadowMd),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${userEnvelopes.length}',
                        style: const TextStyle(
                          fontFamily: BrutalTokens.fontNumbers,
                          fontSize: 38,
                          fontWeight: FontWeight.w700,
                          color: BrutalTokens.ink,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AMPLOP AKTIF',
                              style: TextStyle(
                                fontFamily: BrutalTokens.fontUi,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: BrutalTokens.ink,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Tambah, ubah nama, atau hapus pos amplop.',
                              style: TextStyle(
                                fontFamily: BrutalTokens.fontUi,
                                fontSize: 12,
                                color: BrutalTokens.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                BrutalButton(
                  text: '💰 ATUR ALOKASI DANA KAS',
                  variant: BrutalButtonVariant.primary,
                  isFullWidth: true,
                  onPressed: () => context.push('/allocate'),
                ),
                const SizedBox(height: 18),

                // Filter Tabs
                Row(
                  children: [
                    _buildFilterTab('all', 'SEMUA', isFirst: true),
                    _buildFilterTab('needs', 'KEBUTUHAN'),
                    _buildFilterTab('wants', 'KEINGINAN', isLast: true),
                  ],
                ),
                const SizedBox(height: 14),

                // Empty State if no envelopes
                if (filtered.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: BrutalTokens.paper,
                      border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Tidak ada amplop di kategori ini.',
                      style: TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w700),
                    ),
                  ),

                // Envelope Rows
                ...filtered.map((item) {
                  final isNeeds = item.category == EnvelopeCategory.needs;
                  final iconDisplay = item.icon ?? (isNeeds ? '🍽️' : '🍿');

                  return GestureDetector(
                    onTap: () => context.push('/allocate?envelopeId=${item.id}'),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: isNeeds ? BrutalTokens.needs : BrutalTokens.wants,
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
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: BrutalTokens.paper,
                            border: Border.all(
                              color: BrutalTokens.ink,
                              width: BrutalTokens.borderThin,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            iconDisplay,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StreamBuilder<int>(
                            stream: envelopeRepo.watchEnvelopeBalance(item.id),
                            builder: (context, balSnap) {
                              final balance = balSnap.data ?? 0;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontFamily: BrutalTokens.fontUi,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: BrutalTokens.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${isNeeds ? "KEBUTUHAN" : "KEINGINAN"} · ${MoneyFormatter.format(balance)}',
                                    style: const TextStyle(
                                      fontFamily: BrutalTokens.fontUi,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: BrutalTokens.ink,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        // Tombol Edit
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20, color: BrutalTokens.ink),
                          tooltip: 'Edit Amplop',
                          onPressed: () => _showEditEnvelopeDialog(context, ref, item),
                        ),
                        // Tombol Hapus
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20, color: BrutalTokens.ink),
                          tooltip: 'Hapus Amplop',
                          onPressed: () => _showDeleteEnvelopeDialog(context, ref, item),
                        ),
                      ],
                    ),
                  ),
                );
              }),

                // System Envelope Box
                Container(
                  margin: const EdgeInsets.only(top: 14, bottom: 20),
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
                              'AMPLOP SISTEM TERKUNCI',
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
                              'Belum Bertugas & Bantalan tidak bisa dihapus.',
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

                // Button Buat Amplop Baru
                BrutalButton(
                  text: 'BUAT AMPLOP BARU',
                  variant: BrutalButtonVariant.primary,
                  isFullWidth: true,
                  icon: const Icon(Icons.add, size: 20, color: BrutalTokens.ink),
                  onPressed: () => _showCreateEnvelopeDialog(context, ref),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showCreateEnvelopeDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    EnvelopeCategory selectedCategory = EnvelopeCategory.needs;
    String selectedIcon = '🍽️';
    final envelopeRepo = ref.read(envelopeRepositoryProvider);

    const icons = ['🍽️', '🛵', '⚡', '🏠', '🛒', '📶', '🎮', '🍿', '☕', '📚', '🎁', '💊', '👕', '✈️', '💼'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          backgroundColor: BrutalTokens.canvas,
          shape: const RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
          title: const Text(
            'BUAT AMPLOP BARU',
            style: TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w900),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama Amplop (misal: Ngopi, Laundry)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'KATEGORI:',
                  style: TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w800, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() {
                          selectedCategory = EnvelopeCategory.needs;
                          selectedIcon = '🍽️';
                        }),
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            color: selectedCategory == EnvelopeCategory.needs ? BrutalTokens.needs : BrutalTokens.paper,
                            border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                          ),
                          alignment: Alignment.center,
                          child: const Text('KEBUTUHAN', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() {
                          selectedCategory = EnvelopeCategory.wants;
                          selectedIcon = '☕';
                        }),
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            color: selectedCategory == EnvelopeCategory.wants ? BrutalTokens.wants : BrutalTokens.paper,
                            border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                          ),
                          alignment: Alignment.center,
                          child: const Text('KEINGINAN', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'PILIH IKON:',
                  style: TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w800, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: icons.map((ic) {
                    final isSelected = ic == selectedIcon;
                    return GestureDetector(
                      onTap: () => setModalState(() => selectedIcon = ic),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: isSelected ? BrutalTokens.warn : BrutalTokens.paper,
                          border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                        ),
                        alignment: Alignment.center,
                        child: Text(ic, style: const TextStyle(fontSize: 18)),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            BrutalButton(
              text: 'BATAL',
              variant: BrutalButtonVariant.neutral,
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            BrutalButton(
              text: 'SIMPAN',
              variant: BrutalButtonVariant.primary,
              onPressed: () async {
                final name = nameCtrl.text.trim();
                if (name.isNotEmpty) {
                  await envelopeRepo.createEnvelope(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: name,
                    category: selectedCategory,
                    icon: selectedIcon,
                  );
                  if (ctx.mounted) Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditEnvelopeDialog(BuildContext context, WidgetRef ref, EnvelopeEntity envelope) {
    final nameCtrl = TextEditingController(text: envelope.name);
    EnvelopeCategory selectedCategory = envelope.category;
    String selectedIcon = envelope.icon ?? (envelope.category == EnvelopeCategory.needs ? '🍽️' : '🍿');
    final envelopeRepo = ref.read(envelopeRepositoryProvider);

    const icons = ['🍽️', '🛵', '⚡', '🏠', '🛒', '📶', '🎮', '🍿', '☕', '📚', '🎁', '💊', '👕', '✈️', '💼'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          backgroundColor: BrutalTokens.canvas,
          shape: const RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
          title: const Text(
            'UBAH AMPLOP',
            style: TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w900),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama Amplop',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'KATEGORI:',
                  style: TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w800, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => selectedCategory = EnvelopeCategory.needs),
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            color: selectedCategory == EnvelopeCategory.needs ? BrutalTokens.needs : BrutalTokens.paper,
                            border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                          ),
                          alignment: Alignment.center,
                          child: const Text('KEBUTUHAN', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => selectedCategory = EnvelopeCategory.wants),
                        child: Container(
                          height: 38,
                          decoration: BoxDecoration(
                            color: selectedCategory == EnvelopeCategory.wants ? BrutalTokens.wants : BrutalTokens.paper,
                            border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                          ),
                          alignment: Alignment.center,
                          child: const Text('KEINGINAN', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'PILIH IKON:',
                  style: TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w800, fontSize: 11),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: icons.map((ic) {
                    final isSelected = ic == selectedIcon;
                    return GestureDetector(
                      onTap: () => setModalState(() => selectedIcon = ic),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: isSelected ? BrutalTokens.warn : BrutalTokens.paper,
                          border: Border.all(color: BrutalTokens.ink, width: BrutalTokens.borderThin),
                        ),
                        alignment: Alignment.center,
                        child: Text(ic, style: const TextStyle(fontSize: 18)),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            BrutalButton(
              text: 'BATAL',
              variant: BrutalButtonVariant.neutral,
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            BrutalButton(
              text: 'SIMPAN',
              variant: BrutalButtonVariant.primary,
              onPressed: () async {
                final name = nameCtrl.text.trim();
                if (name.isNotEmpty) {
                  await envelopeRepo.updateEnvelope(
                    id: envelope.id,
                    name: name,
                    category: selectedCategory,
                    icon: selectedIcon,
                  );
                  if (ctx.mounted) Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteEnvelopeDialog(BuildContext context, WidgetRef ref, EnvelopeEntity envelope) {
    final envelopeRepo = ref.read(envelopeRepositoryProvider);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: BrutalTokens.canvas,
        shape: const RoundedRectangleBorder(borderRadius: BrutalTokens.radiusZero),
        title: const Text(
          'HAPUS AMPLOP?',
          style: TextStyle(fontFamily: BrutalTokens.fontUi, fontWeight: FontWeight.w900),
        ),
        content: Text(
          'Yakin ingin menghapus amplop "${envelope.name}"? Riwayat transaksi lama tetap tersimpan di buku besar.',
          style: const TextStyle(fontFamily: BrutalTokens.fontUi, fontSize: 14),
        ),
        actions: [
          BrutalButton(
            text: 'BATAL',
            variant: BrutalButtonVariant.neutral,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          BrutalButton(
            text: 'HAPUS',
            variant: BrutalButtonVariant.danger,
            onPressed: () async {
              await envelopeRepo.deleteEnvelope(envelope.id);
              if (ctx.mounted) {
                Navigator.of(ctx).pop();
                BrutalToast.showSuccess(
                  context,
                  title: 'POS DIBERSIHKAN',
                  message: 'Amplop pos "${envelope.name}" berhasil dihapus.',
                  pushToSystem: true,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String id, String label, {bool isFirst = false, bool isLast = false}) {
    final isActive = _selectedFilter == id;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedFilter = id),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: isActive ? BrutalTokens.ink : BrutalTokens.paper,
            borderRadius: BrutalTokens.radiusZero,
            border: Border.all(
              color: BrutalTokens.ink,
              width: BrutalTokens.borderThin,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: BrutalTokens.fontUi,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: isActive ? BrutalTokens.paper : BrutalTokens.ink,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
