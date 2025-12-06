import 'package:flutter/material.dart';
import 'package:responsi2mobilepaket3h1d023006/model/buku.dart';
import 'package:responsi2mobilepaket3h1d023006/bloc/buku_bloc.dart';

class BukuDetailPage extends StatefulWidget {
  final String id;
  final String appBarTitle;
  const BukuDetailPage({super.key, required this.id, required this.appBarTitle});

  @override
  State<BukuDetailPage> createState() => _BukuDetailPageState();
}

class _BukuDetailPageState extends State<BukuDetailPage> {
  Buku? _buku;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await BukuBloc.showBuku(id: int.parse(widget.id));
      setState(() => _buku = data);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal memuat detail')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.appBarTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _buku == null
              ? const Center(child: Text('Data tidak ditemukan'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Card(
                        elevation: 0,
                        color: theme.colorScheme.surface,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 72,
                                height: 96,
                                decoration: BoxDecoration(
                                  color: Colors.brown.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.book_rounded, color: Colors.brown, size: 32),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _buku!.judul ?? '-',
                                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        _MetaChip(icon: Icons.attach_money, label: 'Harga', value: (_buku!.harga ?? 0).toString()),
                                        _MetaChip(icon: Icons.countertops, label: 'Jumlah', value: (_buku!.jumlah ?? 0).toString()),
                                        _MetaChip(icon: Icons.calendar_today, label: 'Tanggal Masuk', value: _buku!.tanggalMasuk ?? '-'),
                                        _MetaChip(icon: Icons.format_list_numbered, label: 'Volume', value: (_buku!.volume ?? 0).toString()),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _InfoRow(icon: Icons.person_rounded, label: 'Penulis', value: _buku!.penulis ?? '-'),
                              const SizedBox(height: 12),
                              _InfoRow(icon: Icons.apartment_rounded, label: 'Penerbit', value: _buku!.penerbit ?? '-'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.edit_rounded),
                              label: const Text('Edit Inventaris'),
                              onPressed: () => Navigator.pushNamed(context, '/buku/edit', arguments: {'id': _buku!.id}),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.arrow_back_rounded),
                              label: const Text('Kembali'),
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.brown,
                                side: BorderSide(color: Colors.brown.shade300),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MetaChip({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.brown.shade50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.brown.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.brown.shade400),
          const SizedBox(width: 6),
          Text('$label: ', style: TextStyle(color: Colors.brown.shade700, fontWeight: FontWeight.w600)),
          Text(value, style: TextStyle(color: Colors.brown.shade700)),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.brown),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.labelLarge?.copyWith(color: Colors.brown, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(value, style: theme.textTheme.bodyMedium),
            ],
          ),
        )
      ],
    );
  }
}
