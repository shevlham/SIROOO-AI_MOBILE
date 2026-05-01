**[REFACTORING INSTRUCTIONS FOR AI MODEL]**

Tugas Anda adalah me-refactor *codebase* ini agar memenuhi standar industri (Clean Architecture/Layered Architecture) sehingga lebih mudah di-maintain dan di-scale. Kerjakan langkah-langkah di bawah ini secara berurutan.

### Tahap 1: Refactoring Backend (FastAPI)
1. **Buat Struktur Direktori Standar:** 
   Di dalam folder `backend/`, buat struktur folder baru seperti berikut:
   ```text
   backend/
   ├── app/
   │   ├── api/
   │   ├── core/
   │   ├── crud/
   │   ├── models/
   │   └── schemas/
   ```
2. **Pecah Monolith `main.py` dan `models.py` Lama:**
   - Buat `backend/app/core/database.py`: Pindahkan konfigurasi koneksi SQLite (SQLAlchemy) dari `backend/database.py` lama ke sini.
   - Buat `backend/app/models/chat.py`: Pindahkan definisi SQLAlchemy model (`ChatMessage`) dari `backend/models.py` lama.
   - Buat `backend/app/schemas/chat.py`: Pindahkan definisi Pydantic models (`MessageBase`, `MessageCreate`, `Message`) dari `main.py` lama.
   - Buat `backend/app/crud/chat.py`: Ekstrak logika database (fungsi untuk `get_messages` dan `create_message`).
   - Buat `backend/app/api/chat.py`: Buat `APIRouter()` dan pindahkan fungsi endpoint `GET /api/chat` dan `POST /api/chat` dari `main.py`. Endpoint ini hanya memanggil fungsi dari `crud/chat.py`.
   - Ubah `backend/main.py`: File ini sekarang harus sangat bersih. Hanya berisi inisialisasi `app = FastAPI()` dan me-register router (`app.include_router()`).
3. **Pembersihan:** Hapus file `database.py` dan `models.py` lama yang berada di luar folder `app/` setelah isinya dipindahkan dengan benar. Perbaiki semua *import statement*.

### Tahap 2: Refactoring Frontend (Flutter)
1. **Buat Struktur Folder UI:**
   Di dalam `frontend/sirooo_ai/lib/`, rapikan foldernya menjadi:
   ```text
   lib/
   ├── models/
   ├── screens/
   ├── services/
   ├── utils/
   └── widgets/
   ```
2. **Pecah Monolith `main.dart`:**
   - Buat `lib/screens/chat_screen.dart`: Pindahkan `ChatScreen` (StatefulWidget) dari `main.dart` ke file ini.
   - Buat `lib/widgets/chat_bubble.dart`: Ekstrak desain UI pesan (warna ungu/abu dan layout) menjadi sebuah widget terpisah yang *reusable*. Gunakan widget ini di dalam `chat_screen.dart`.
   - Ubah `lib/main.dart`: File ini hanya boleh berisi `main()` dan `SiroooAiApp` (MaterialApp config) yang menunjuk ke `ChatScreen`.
3. **Perbaiki Penanganan URL API:**
   - Buat `lib/utils/constants.dart`: Simpan variabel `baseUrl`. Tambahkan logika untuk menentukan IP yang tepat (menggunakan pengecekan platform seperti `Platform.isAndroid` dari `dart:io`): `10.0.2.2` untuk Android Emulator, dan `127.0.0.1` untuk Desktop/Web.
   - Ubah `lib/services/api_service.dart` agar menggunakan `baseUrl` dari file konstanta tersebut.

**Catatan untuk Eksekutor:**
Lakukan pengujian lokal (test run FastAPI dan `flutter build`) di setiap akhir tahap sebelum melanjutkan ke tahap berikutnya untuk memastikan tidak ada import error atau broken build.
