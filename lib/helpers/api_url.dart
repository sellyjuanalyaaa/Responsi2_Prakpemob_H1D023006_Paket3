class ApiUrl {
  // Ganti sesuai host CI4 Anda
  static const String baseUrl = 'http://192.168.100.42:8080';

  // Auth (sesuai Routes.php CI4: api/register, api/login)
  static const String registrasi = baseUrl + '/registrasi';
  static const String login = baseUrl + '/login';

  // Buku CRUD (sesuai group 'api/buku')
  static const String listBuku = baseUrl + '/api/buku';
  static const String createBuku = baseUrl + '/api/buku';
  static String updateBuku(int id) => baseUrl + '/api/buku/' + id.toString();
  static String showBuku(int id) => baseUrl + '/api/buku/' + id.toString();
  static String deleteBuku(int id) => baseUrl + '/api/buku/' + id.toString();
}
