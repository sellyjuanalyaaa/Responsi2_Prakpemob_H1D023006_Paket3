class Buku {
  String? id;
  String? judul;
  int? harga;
  int? jumlah;
  String? tanggalMasuk;
  int? volume;
  String? penulis;
  String? penerbit;

  Buku({
    this.id,
    this.judul,
    this.harga,
    this.jumlah,
    this.tanggalMasuk,
    this.volume,
    this.penulis,
    this.penerbit,
  });

  factory Buku.fromJson(Map<String, dynamic> obj) {
    return Buku(
      id: obj['id']?.toString(),
      judul: obj['judul'],
      harga: obj['harga'] is String ? int.tryParse(obj['harga']) : obj['harga'],
      jumlah: obj['jumlah'] is String ? int.tryParse(obj['jumlah']) : obj['jumlah'],
      tanggalMasuk: obj['tanggal_masuk'] ?? obj['tanggalMasuk'],
      volume: obj['volume'] is String ? int.tryParse(obj['volume']) : obj['volume'],
      penulis: obj['penulis'],
      penerbit: obj['penerbit'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'harga': harga,
      'jumlah': jumlah,
      'tanggal_masuk': tanggalMasuk,
      'volume': volume,
      'penulis': penulis,
      'penerbit': penerbit,
    };
  }
}
