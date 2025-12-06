import 'package:flutter/material.dart';
import 'package:responsi2mobilepaket3h1d023006/model/buku.dart';
import 'package:responsi2mobilepaket3h1d023006/bloc/buku_bloc.dart';
import 'package:responsi2mobilepaket3h1d023006/bloc/logout_bloc.dart';

class BukuListPage extends StatefulWidget {
  final String appBarTitle;
  const BukuListPage({super.key, required this.appBarTitle});

  @override
  State<BukuListPage> createState() => _BukuListPageState();
}

class _BukuListPageState extends State<BukuListPage> {
  List<Buku> _items = [];
  List<Buku> _filteredItems = [];
  bool _loading = true;
  String _selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await BukuBloc.getBukus();
      setState(() {
        _items = data;
        _applyFilter();
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal memuat data')));
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _applyFilter() {
    if (_items.isEmpty) {
      _filteredItems = [];
      return;
    }
    
    switch (_selectedCategory) {
      case 'Populer':
        _filteredItems = List<Buku>.from(_items)..sort((a, b) => (b.jumlah ?? 0).compareTo(a.jumlah ?? 0));
        break;
      case 'Terbaru':
        _filteredItems = List<Buku>.from(_items)
          ..sort((a, b) {
            final dateA = DateTime.tryParse(a.tanggalMasuk ?? '') ?? DateTime(1900);
            final dateB = DateTime.tryParse(b.tanggalMasuk ?? '') ?? DateTime(1900);
            return dateB.compareTo(dateA);
          });
        break;
      case 'Favorit':
        _filteredItems = List<Buku>.from(_items)..sort((a, b) => (b.harga ?? 0).compareTo(a.harga ?? 0));
        break;
      default:
        _filteredItems = List<Buku>.from(_items);
    }
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _applyFilter();
    });
  }

  Future<void> _delete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.orange.shade700, size: 28),
              const SizedBox(width: 12),
              const Text('Konfirmasi Hapus'),
            ],
          ),
          content: const Text('Apakah Anda yakin ingin menghapus buku ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      final ok = await BukuBloc.deleteBuku(id: int.parse(id));
      if (ok && mounted) {
        _load();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Buku berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menghapus')));
    }
  }

  Future<void> _logout() async {
    await LogoutBloc.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showDetailDialog(BuildContext context, Buku buku) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Compact Header
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.brown.shade700, Colors.brown.shade500],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          buku.judul ?? '-',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                // Content - with SingleChildScrollView to prevent overflow
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Price and Stock Row - Compact
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.brown.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.attach_money_rounded, color: Colors.brown.shade700, size: 18),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Rp ${buku.harga ?? 0}',
                                        style: TextStyle(
                                          color: Colors.brown.shade900,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.brown.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.inventory_2_rounded, color: Colors.brown.shade700, size: 18),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${buku.jumlah ?? 0} stok',
                                        style: TextStyle(
                                          color: Colors.brown.shade900,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Details - Compact
                          _CompactDetailRow(icon: Icons.calendar_today_rounded, label: 'Tanggal', value: buku.tanggalMasuk ?? '-'),
                          const SizedBox(height: 6),
                          _CompactDetailRow(icon: Icons.format_list_numbered_rounded, label: 'Volume', value: (buku.volume ?? 0).toString()),
                          const SizedBox(height: 6),
                          _CompactDetailRow(icon: Icons.person_rounded, label: 'Penulis', value: buku.penulis ?? '-'),
                          const SizedBox(height: 6),
                          _CompactDetailRow(icon: Icons.apartment_rounded, label: 'Penerbit', value: buku.penerbit ?? '-'),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.edit_rounded, size: 16),
                                  label: const Text('Edit', style: TextStyle(fontSize: 13)),
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await Navigator.pushNamed(context, '/buku/edit', arguments: {'id': buku.id});
                                    _load();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.brown.shade700,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.delete_rounded, size: 16),
                                  label: const Text('Hapus', style: TextStyle(fontSize: 13)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _delete(buku.id!);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade600,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.brown.shade700,
              Colors.brown.shade500,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Builder(
                          builder: (context) => IconButton(
                            icon: const Icon(Icons.menu_rounded, color: Colors.white),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.person_rounded, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Inventaris Buku',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Search bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.white.withOpacity(0.8)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Cari buku...',
                                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Category tabs
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _CategoryChip(
                            label: 'Semua',
                            isSelected: _selectedCategory == 'Semua',
                            onTap: () => _selectCategory('Semua'),
                          ),
                          const SizedBox(width: 8),
                          _CategoryChip(
                            label: 'Populer',
                            isSelected: _selectedCategory == 'Populer',
                            onTap: () => _selectCategory('Populer'),
                          ),
                          const SizedBox(width: 8),
                          _CategoryChip(
                            label: 'Terbaru',
                            isSelected: _selectedCategory == 'Terbaru',
                            onTap: () => _selectCategory('Terbaru'),
                          ),
                          const SizedBox(width: 8),
                          _CategoryChip(
                            label: 'Favorit',
                            isSelected: _selectedCategory == 'Favorit',
                            onTap: () => _selectCategory('Favorit'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : _filteredItems.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.book_outlined, size: 64, color: Colors.white.withOpacity(0.5)),
                                const SizedBox(height: 16),
                                Text('Tidak ada buku', style: TextStyle(color: Colors.white.withOpacity(0.7))),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _load,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                              ),
                              child: GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                                itemCount: _filteredItems.length,
                                itemBuilder: (context, i) {
                                  final b = _filteredItems[i];
                                  return _BookCard(
                                    buku: b,
                                    onTap: () => _showDetailDialog(context, b),
                                    onEdit: () {
                                      Navigator.pushNamed(context, '/buku/edit', arguments: {'id': b.id}).then((_) => _load());
                                    },
                                    onDelete: () => _delete(b.id!),
                                  );
                                },
                              ),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.brown.shade700, Colors.brown.shade500],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40, color: Colors.brown),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Inventaris App',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kelola Buku Anda',
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _DrawerMenuItem(icon: Icons.home_rounded, title: 'Beranda', isSelected: true, onTap: () => Navigator.pop(context)),
                  _DrawerMenuItem(icon: Icons.book_rounded, title: 'Daftar Buku', isSelected: false, onTap: () {}),
                  _DrawerMenuItem(icon: Icons.favorite_rounded, title: 'Favorit', isSelected: false, onTap: () {}),
                  _DrawerMenuItem(icon: Icons.history_rounded, title: 'Riwayat', isSelected: false, onTap: () {}),
                  _DrawerMenuItem(icon: Icons.settings_rounded, title: 'Pengaturan', isSelected: false, onTap: () {}),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                    title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
                    tileColor: Colors.red.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onTap: _logout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown.shade700,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Navigator.pushNamed(context, '/buku/add').then((_) => _load()),
      ),
    );
  }
}

class _CompactDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _CompactDetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.brown.shade700, size: 18),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.brown.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.brown.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.brown.shade700, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.brown.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _CategoryChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.brown.shade700 : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.brown.shade700 : Colors.white.withOpacity(0.5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  const _DrawerMenuItem({required this.icon, required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.brown.shade700 : Colors.grey.shade700),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.brown.shade700 : Colors.grey.shade800,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.brown.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }
}

class _BookCard extends StatelessWidget {
  final Buku buku;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BookCard({
    required this.buku,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book cover
            Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.brown.shade300,
                    Colors.brown.shade100,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.menu_book_rounded,
                      size: 50,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: PopupMenuButton(
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.more_vert, size: 18, color: Colors.brown),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Row(
                            children: [
                              Icon(Icons.edit_rounded, color: Colors.brown, size: 20),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                          onTap: onEdit,
                        ),
                        PopupMenuItem(
                          child: const Row(
                            children: [
                              Icon(Icons.delete_rounded, color: Colors.redAccent, size: 20),
                              SizedBox(width: 8),
                              Text('Hapus'),
                            ],
                          ),
                          onTap: onDelete,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Book info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    buku.judul ?? '-',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    buku.penulis ?? '-',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.attach_money, size: 14, color: Colors.brown.shade700),
                      Text(
                        '${buku.harga ?? 0}',
                        style: TextStyle(
                          color: Colors.brown.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.brown.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${buku.jumlah ?? 0} stok',
                          style: TextStyle(
                            color: Colors.brown.shade700,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
