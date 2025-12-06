import 'package:flutter/material.dart';
import 'package:responsi2mobilepaket3h1d023006/model/buku.dart';
import 'package:responsi2mobilepaket3h1d023006/bloc/buku_bloc.dart';

class BukuFormPage extends StatefulWidget {
  final String appBarTitle;
  final String? id; // null for create
  const BukuFormPage({super.key, required this.appBarTitle, this.id});

  @override
  State<BukuFormPage> createState() => _BukuFormPageState();
}

class _BukuFormPageState extends State<BukuFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _judul = TextEditingController();
  final _harga = TextEditingController();
  final _jumlah = TextEditingController();
  final _tanggalMasuk = TextEditingController();
  final _volume = TextEditingController();
  final _penulis = TextEditingController();
  final _penerbit = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final b = await BukuBloc.showBuku(id: int.parse(widget.id!));
      _judul.text = b.judul ?? '';
      _harga.text = (b.harga ?? 0).toString();
      _jumlah.text = (b.jumlah ?? 0).toString();
      _tanggalMasuk.text = b.tanggalMasuk ?? '';
      _volume.text = (b.volume ?? 0).toString();
      _penulis.text = b.penulis ?? '';
      _penerbit.text = b.penerbit ?? '';
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal memuat detail')));
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.brown,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _tanggalMasuk.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final buku = Buku(
      judul: _judul.text.trim(),
      harga: int.tryParse(_harga.text.trim()) ?? 0,
      jumlah: int.tryParse(_jumlah.text.trim()) ?? 0,
      tanggalMasuk: _tanggalMasuk.text.trim(),
      volume: int.tryParse(_volume.text.trim()) ?? 0,
      penulis: _penulis.text.trim(),
      penerbit: _penerbit.text.trim(),
    );
    setState(() => _loading = true);
    try {
      if (widget.id == null) {
        await BukuBloc.addBuku(buku: buku);
      } else {
        await BukuBloc.updateBuku(
          buku: Buku(
            id: widget.id,
            judul: buku.judul,
            harga: buku.harga,
            jumlah: buku.jumlah,
            tanggalMasuk: buku.tanggalMasuk,
            volume: buku.volume,
            penulis: buku.penulis,
            penerbit: buku.penerbit,
          ),
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menyimpan')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration deco(String label, {IconData? icon}) => InputDecoration(
      labelText: label,
      prefixIcon: icon == null ? null : Icon(icon, color: Colors.brown),
      filled: true,
      fillColor: Colors.brown.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.brown.shade700, Colors.brown.shade500],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.id == null ? 'Tambah Buku' : 'Edit Buku',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.id == null
                                ? 'Tambah buku baru ke inventaris'
                                : 'Perbarui informasi buku',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Form Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: _loading
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.brown),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.brown.shade50,
                                        Colors.brown.shade100,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.brown.shade700,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.book_rounded,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Informasi Buku',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.brown,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Isi detail informasi buku dengan lengkap',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.brown.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _judul,
                                  decoration: deco(
                                    'Judul',
                                    icon: Icons.book_rounded,
                                  ),
                                  validator: _req,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _harga,
                                        decoration: deco(
                                          'Harga',
                                          icon: Icons.attach_money,
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: _req,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _jumlah,
                                        decoration: deco(
                                          'Jumlah',
                                          icon: Icons.countertops,
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: _req,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _tanggalMasuk,
                                  decoration:
                                      deco(
                                        'Tanggal Masuk (YYYY-MM-DD)',
                                        icon: Icons.calendar_today,
                                      ).copyWith(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            Icons.calendar_month,
                                            color: Colors.brown,
                                          ),
                                          onPressed: _pickDate,
                                        ),
                                      ),
                                  readOnly: true,
                                  onTap: _pickDate,
                                  validator: _req,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _volume,
                                  decoration: deco(
                                    'Volume',
                                    icon: Icons.format_list_numbered,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: _req,
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.brown.shade50,
                                        Colors.brown.shade100,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.brown.shade700,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.apartment_rounded,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      const Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Detail Penerbit',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.brown,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Informasi penulis dan penerbit',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.brown,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _penulis,
                                  decoration: deco(
                                    'Penulis',
                                    icon: Icons.person_rounded,
                                  ),
                                  validator: _req,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _penerbit,
                                  decoration: deco(
                                    'Penerbit',
                                    icon: Icons.apartment_rounded,
                                  ),
                                  validator: _req,
                                ),
                                const SizedBox(height: 32),
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton.icon(
                                    onPressed: _loading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.brown.shade700,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 4,
                                      shadowColor: Colors.brown.withOpacity(
                                        0.5,
                                      ),
                                    ),
                                    icon: _loading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : Icon(
                                            widget.id == null
                                                ? Icons.save_rounded
                                                : Icons.update_rounded,
                                            size: 24,
                                          ),
                                    label: Text(
                                      widget.id == null
                                          ? 'Simpan Buku'
                                          : 'Update Buku',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _req(String? v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null;
}
