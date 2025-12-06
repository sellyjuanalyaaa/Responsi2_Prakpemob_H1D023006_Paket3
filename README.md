# Responsi 2 Mobile - Inventaris Buku Alyaaamart

## Informasi Mahasiswa
- **Nama**: Sellyjuan Alya Rosalina
- **NIM**: H1D023006
- **Shift Baru**: Shift C
- **Shift Asal**: Shift A

## Video Demo

## Spesifikasi API

### Base URL
```
http://192.168.100.42:8080
```

### Endpoints

#### 1. Register
- **URL**: `/api/register`
- **Method**: `POST`
- **Request Body**:
```json
{
  "email": "string",
  "password": "string"
}
```
- **Response Success**:
```json
{
  "status": true,
  "message": "Registrasi berhasil"
}
```

#### 2. Login
- **URL**: `/api/login`
- **Method**: `POST`
- **Request Body**:
```json
{
  "email": "string",
  "password": "string"
}
```
- **Response Success**:
```json
{
  "status": true,
  "message": "Login berhasil",
  "data": {
    "token": "string",
    "user_id": "integer"
  }
}
```

#### 3. Get All Buku
- **URL**: `/api/buku`
- **Method**: `GET`
- **Headers**: 
  - `Authorization: Bearer {token}`
- **Response Success**:
```json
{
  "status": true,
  "data": [
    {
      "id": "integer",
      "judul": "string",
      "penulis": "string",
      "penerbit": "string",
      "tanggal_masuk": "date",
      "harga": "integer",
      "jumlah": "integer",
      "volume": "integer"
    }
  ]
}
```

#### 4. Get Buku by ID
- **URL**: `/api/buku/{id}`
- **Method**: `GET`
- **Headers**: 
  - `Authorization: Bearer {token}`
- **Response Success**:
```json
{
  "status": true,
  "data": {
    "id": "integer",
    "judul": "string",
    "penulis": "string",
    "penerbit": "string",
    "tanggal_masuk": "date",
    "harga": "integer",
    "jumlah": "integer",
    "volume": "integer"
  }
}
```

#### 5. Create Buku
- **URL**: `/api/buku`
- **Method**: `POST`
- **Headers**: 
  - `Authorization: Bearer {token}`
  - `Content-Type: application/json`
- **Request Body**:
```json
{
  "judul": "string",
  "penulis": "string",
  "penerbit": "string",
  "tanggal_masuk": "date",
  "harga": "integer",
  "jumlah": "integer",
  "volume": "integer"
}
```
- **Response Success**:
```json
{
  "status": true,
  "message": "Buku berhasil ditambahkan"
}
```

#### 6. Update Buku
- **URL**: `/api/buku/{id}`
- **Method**: `PUT`
- **Headers**: 
  - `Authorization: Bearer {token}`
  - `Content-Type: application/json`
- **Request Body**:
```json
{
  "judul": "string",
  "penulis": "string",
  "penerbit": "string",
  "tanggal_masuk": "date",
  "harga": "integer",
  "jumlah": "integer",
  "volume": "integer"
}
```
- **Response Success**:
```json
{
  "status": true,
  "message": "Buku berhasil diupdate"
}
```

#### 7. Delete Buku
- **URL**: `/api/buku/{id}`
- **Method**: `DELETE`
- **Headers**: 
  - `Authorization: Bearer {token}`
- **Response Success**:
```json
{
  "status": true,
  "message": "Buku berhasil dihapus"
}
```

## Penjelasan Kode

### 1. Authentication (Login & Register)

#### `lib/pages/login_page.dart`
- **Fungsi utama**: Halaman login dengan email dan password
- **UI Features**:
  - Gradient background (brown theme)
  - Logo aplikasi dengan ikon buku
  - Form input email dan password dengan validasi
  - Tombol login dengan loading indicator
  - Link ke halaman registrasi
- **Logic**:
  - `_loginController`: TextEditingController untuk email
  - `_passwordController`: TextEditingController untuk password
  - `_isLoading`: State untuk menampilkan loading
  - `_submit()`: Method untuk proses login
    1. Validasi input tidak boleh kosong
    2. Set loading state
    3. Panggil `LoginBloc.login()` dengan email dan password
    4. Simpan token dan userID ke SharedPreferences via `UserInfo`
    5. Navigate ke halaman `/buku` jika sukses
    6. Tampilkan error message jika gagal

#### `lib/pages/register_page.dart`
- **Fungsi utama**: Halaman registrasi user baru
- **UI Features**:
  - Gradient background matching login page
  - Back button untuk kembali ke login
  - Form input email dan password dengan validasi
  - Tombol register dengan loading indicator
- **Logic**:
  - `_emailController`: TextEditingController untuk email
  - `_passwordController`: TextEditingController untuk password
  - `_isLoading`: State untuk loading indicator
  - `_submit()`: Method untuk registrasi
    1. Validasi email dan password tidak kosong
    2. Set loading state
    3. Panggil `RegistrasiBloc.registrasi()` dengan email dan password
    4. Tampilkan dialog sukses dan navigate ke login
    5. Tampilkan error jika gagal

#### `lib/bloc/login_bloc.dart`
- **Fungsi**: Business logic untuk login
- **Method `login()`**:
  1. Kirim POST request ke `/api/login` dengan email dan password
  2. Parse response JSON
  3. Return true jika sukses, false jika gagal

#### `lib/bloc/registrasi_bloc.dart`
- **Fungsi**: Business logic untuk registrasi
- **Method `registrasi()`**:
  1. Kirim POST request ke `/api/register` dengan email dan password
  2. Parse response JSON
  3. Return true jika sukses, false jika gagal

#### `lib/helpers/user_info.dart`
- **Fungsi**: Helper untuk menyimpan dan mengambil data user di SharedPreferences
- **Methods**:
  - `setToken()`: Simpan authentication token
  - `getToken()`: Ambil token yang tersimpan
  - `setUserID()`: Simpan user ID
  - `getUserID()`: Ambil user ID
  - `logout()`: Hapus semua data user (token dan userID)

### 2. CRUD Buku

#### `lib/pages/buku_list_page.dart`
- **Fungsi utama**: Halaman utama untuk menampilkan daftar buku dengan fitur filtering
- **UI Features**:
  - Gradient header dengan menu drawer dan user icon
  - Search bar (placeholder)
  - Category tabs: Semua, Populer, Terbaru, Favorit
  - Grid layout 2 kolom untuk menampilkan buku
  - Modern card design dengan gradient cover
  - PopupMenu untuk edit/delete pada setiap card
  - Floating action button untuk tambah buku
  - Sidebar drawer dengan menu navigasi
- **State Variables**:
  - `_items`: List semua buku dari API
  - `_filteredItems`: List buku setelah di-filter berdasarkan kategori
  - `_loading`: State loading indicator
  - `_selectedCategory`: Kategori yang sedang dipilih
- **Methods**:
  - `_load()`: Fetch data buku dari API via `BukuBloc.getBukus()`
  - `_applyFilter()`: Filter dan sort buku berdasarkan kategori:
    - **Populer**: Sort by jumlah (stok) descending
    - **Terbaru**: Sort by tanggal_masuk descending
    - **Favorit**: Sort by harga descending
    - **Semua**: Tampilkan semua tanpa sorting
  - `_selectCategory()`: Update kategori terpilih dan apply filter
  - `_delete()`: Hapus buku dengan konfirmasi dialog
  - `_showDetailDialog()`: Tampilkan popup detail buku dengan:
    - Header gradient dengan judul buku
    - Card harga dan stok
    - Detail info (tanggal, volume, penulis, penerbit)
    - Tombol Edit dan Hapus
  - `_logout()`: Logout dan clear data user

#### `lib/pages/buku_form_page.dart`
- **Fungsi utama**: Form untuk tambah dan edit buku
- **UI Features**:
  - Gradient header dengan back button
  - Section headers: "Informasi Buku" dan "Detail Penerbit"
  - Form fields dengan validasi:
    - Judul Buku (required)
    - Penulis (required)
    - Penerbit (required)
    - Tanggal Masuk (date picker)
    - Harga (number only)
    - Jumlah/Stok (number only)
    - Volume (number only)
  - Submit button dengan loading indicator
- **State Variables**:
  - `_formKey`: GlobalKey untuk form validation
  - Controllers untuk setiap field (judul, penulis, penerbit, dll)
  - `_isLoading`: State untuk loading indicator
- **Methods**:
  - `_load()`: Load data buku jika mode edit (ada ID)
  - `_pickDate()`: Tampilkan date picker untuk tanggal masuk
  - `_simpan()`: Submit form
    1. Validasi semua field required
    2. Create object Buku dari form data
    3. Jika mode edit: panggil `BukuBloc.updateBuku()`
    4. Jika mode tambah: panggil `BukuBloc.addBuku()`
    5. Navigate back ke list page jika sukses
    6. Tampilkan error jika gagal

#### `lib/pages/buku_detail_page.dart`
- **Fungsi utama**: Halaman detail buku (halaman terpisah, bukan popup)
- **UI Features**:
  - AppBar dengan judul
  - Card informasi utama dengan icon buku
  - Meta chips untuk harga, jumlah, tanggal, volume
  - Card detail penulis dan penerbit
  - Tombol Edit dan Kembali
- **Methods**:
  - `_load()`: Fetch detail buku by ID via `BukuBloc.showBuku()`

#### `lib/bloc/buku_bloc.dart`
- **Fungsi**: Business logic untuk operasi CRUD buku
- **Methods**:
  - `getBukus()`: GET semua buku dari `/api/buku`
  - `showBuku()`: GET detail buku by ID dari `/api/buku/{id}`
  - `addBuku()`: POST buku baru ke `/api/buku`
  - `updateBuku()`: PUT update buku ke `/api/buku/{id}`
  - `deleteBuku()`: DELETE buku dari `/api/buku/{id}`
- Semua method menggunakan header Authorization dengan token dari SharedPreferences

### 3. Helper Classes

#### `lib/helpers/api.dart`
- **Fungsi**: Helper untuk HTTP requests dengan authentication
- **Methods**:
  - `setHeaders()`: Set headers dengan authorization token
  - `get()`: HTTP GET request
  - `post()`: HTTP POST request (form-encoded)
  - `postJson()`: HTTP POST request dengan JSON body
  - `put()`: HTTP PUT request (form-encoded)
  - `putJson()`: HTTP PUT request dengan JSON body
  - `delete()`: HTTP DELETE request

#### `lib/helpers/api_url.dart`
- **Fungsi**: Centralized API URL configuration
- **Constants**:
  - `baseUrl`: Base URL untuk API
  - `registrasi`: Endpoint registrasi
  - `login`: Endpoint login
  - `listBuku`: Endpoint list buku
  - `createBuku`: Endpoint create buku
  - `showBuku()`: Function untuk get URL detail buku by ID
  - `updateBuku()`: Function untuk get URL update buku by ID
  - `deleteBuku()`: Function untuk get URL delete buku by ID

### 4. Model

#### `lib/model/buku.dart`
- **Fungsi**: Model data class untuk Buku
- **Properties**:
  - `id`: String (primary key)
  - `judul`: String (judul buku)
  - `penulis`: String (nama penulis)
  - `penerbit`: String (nama penerbit)
  - `tanggalMasuk`: String (format date)
  - `harga`: int (harga buku)
  - `jumlah`: int (jumlah stok)
  - `volume`: int (volume/edisi buku)
- **Methods**:
  - `fromJson()`: Convert JSON ke object Buku
  - `toJson()`: Convert object Buku ke JSON

### 5. Custom Widgets

#### `_CompactDetailRow` (di buku_list_page.dart)
- **Fungsi**: Widget untuk menampilkan detail dalam popup (compact mode)
- **Props**: icon, label, value
- **UI**: Single row dengan icon, label, dan value

#### `_CategoryChip` (di buku_list_page.dart)
- **Fungsi**: Widget untuk tab kategori filter
- **Props**: label, isSelected, onTap
- **UI**: Chip dengan background yang berubah saat selected

#### `_DrawerMenuItem` (di buku_list_page.dart)
- **Fungsi**: Widget untuk menu item di sidebar
- **Props**: icon, title, isSelected, onTap
- **UI**: ListTile dengan highlight saat selected

#### `_BookCard` (di buku_list_page.dart)
- **Fungsi**: Widget card untuk menampilkan buku di grid
- **Props**: buku, onTap, onEdit, onDelete
- **UI**: Card dengan gradient cover, PopupMenu, judul, penulis, harga, stok

### 6. Theming

#### `lib/main.dart`
- **Theme Configuration**:
  - Primary color: Brown
  - Font: Poppins (via Google Fonts)
  - Material Design 2 (useMaterial3: false)
- **Routes**:
  - `/login`: LoginPage
  - `/register`: RegisterPage
  - `/buku`: BukuListPage
  - `/buku/add`: BukuFormPage (tambah)
  - `/buku/edit`: BukuFormPage (edit, via onGenerateRoute)
  - `/buku/detail`: BukuDetailPage (via onGenerateRoute)

## Fitur Aplikasi

1. **Authentication**
   - Register dengan email dan password
   - Login dengan validasi
   - Token-based authentication
   - Auto logout

2. **Manajemen Buku**
   - Lihat daftar buku (grid 2 kolom)
   - Filter kategori: Semua, Populer, Terbaru, Favorit
   - Tambah buku baru dengan form validasi
   - Edit buku existing
   - Hapus buku dengan konfirmasi
   - Lihat detail buku (popup atau halaman terpisah)
   - Search (placeholder)



"# Responsi2_Prakpemob_H1D023006_Paket3" 
