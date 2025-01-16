import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:myapp/app/data/event_response.dart';
import 'package:myapp/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:myapp/app/modules/dashboard/views/add_view.dart';
import 'package:myapp/app/modules/dashboard/views/edit_view.dart';
import 'package:myapp/app/modules/dashboard/views/event_detail_view.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class YourEventView extends GetView {
  const YourEventView({super.key});
  @override
  Widget build(BuildContext context) {

    DashboardController controller = Get.put(DashboardController());
    final ScrollController scrollController = ScrollController();
    
    return Scaffold(

      
 floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman AddView dan memanggil controller.getYourEvent() setelah kembali
          Get.to(() => AddView())?.then((_) {
            controller
                .getYourEvent(); // Memanggil ulang data setelah menambahkan event
          });
        },
        child: const Icon(Icons.add), // Menampilkan ikon add
      ),
      appBar: AppBar(
        title: const Text('Your Event'), // Judul aplikasi
        centerTitle: true, // Menyusun judul di tengah
      ),
     
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Memberi padding di sekitar konten
        child: FutureBuilder<EventResponse>(
          // Mengambil data event melalui fungsi getEvent dari controller
          future: controller.getEvent(),
          builder: (context, snapshot) {
            // Jika data sedang dimuat, tampilkan animasi loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.network(
                  // Menggunakan animasi Lottie untuk tampilan loading
                  'https://gist.githubusercontent.com/olipiskandar/4f08ac098c81c32ebc02c55f5b11127b/raw/6e21dc500323da795e8b61b5558748b5c7885157/loading.json',
                  repeat: true, // Animasi akan berulang terus-menerus
                  width: MediaQuery.of(context).size.width / 1, // Menyesuaikan lebar animasi
                ),
              );
            }
            // Jika tidak ada data yang diterima, tampilkan pesan "Tidak ada data"
            if (snapshot.data!.events!.isEmpty) {
              return const Center(child: Text("Tidak ada data"));
            }
            
            return ListView.builder(
              // Menentukan jumlah item berdasarkan panjang data events
              itemCount: snapshot.data!.events!.length,
              controller: scrollController, // Menggunakan ScrollController untuk ListView
              shrinkWrap: true, // Membatasi ukuran ListView agar sesuai dengan konten
              itemBuilder: (context, index) {
                return ZoomTapAnimation(
                  onTap: () {
                    // Navigasi ke EventDetailView saat item ditekan
                    Get.to(() => EventDetailView(), id: 1);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Menyusun elemen secara horizontal di kiri
                    children: [
                      // Menampilkan gambar event
                      Image.network(
                        'https://picsum.photos/id/${snapshot.data!.events![index].id}/700/300',
                        fit: BoxFit.cover, // Menyesuaikan gambar dengan area tampilan
                        height: 200,
                        width: 500,
                        errorBuilder: (context, error, stackTrace) {
                          // Menangani error jika gambar tidak ditemukan
                          return const SizedBox(
                            height: 200,
                            child: Center(
                              child: Text('Image not found'),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16), // Jarak antara elemen
                      // Menampilkan judul event
                      Text(
                         snapshot.data!.events![index].name
                        .toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold, // Membuat teks menjadi tebal
                        ),
                      ),
                      const SizedBox(height: 8), // Jarak antara elemen
                      // Menampilkan deskripsi event
                      Text(
                        snapshot.data!.events![index].description
                        .toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey, // Warna teks abu-abu
                        ),
                      ),
                      const SizedBox(height: 16), // Jarak antara elemen
                      Row(
                        children: [
                          // Ikon lokasi
                          const Icon(
                            Icons.location_on,
                            color: Colors.red, // Warna ikon merah
                          ),
                          const SizedBox(width: 8), // Jarak antara ikon dan teks
                          Expanded(
                            child: Text(
                          snapshot.data!.events![index].location
                          .toString(), // Lokasi event
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black, // Warna teks hitam
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Garis pembatas antara item
                      Divider(
                        height: 10, // Tinggi divider
                      ),
                      SizedBox(height: 16), 
                      Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end, // Posisi item di ujung kanan
                    children: [
                      // Tombol Edit buat ngedit event
                      TextButton.icon(
                        icon: const Icon(Icons.edit,
                            color: Colors.blue), // Ikon edit dengan warna biru
                        label: const Text('Edit',
                            style: TextStyle(
                                color: Colors.blue)), // Teks "Edit" warna biru
                        onPressed: () {
                          // Aksi kalau tombol Edit diklik
                            Get.to(
                              (dynamic event) => EditView(
                                id: event.id!, // Bawa ID event ke halaman Edit
                                title: event
                                    .name!, // Bawa nama event ke halaman Edit
                              ),
                            );
                        },
                      ),
                      // Tombol Delete buat hapus event
                      TextButton.icon(
                        icon: const Icon(Icons.delete,
                            color:
                                Colors.red), // Ikon delete dengan warna merah
                        label: const Text('Delete',
                            style: TextStyle(
                                color:
                                    Colors.red)), // Teks "Delete" warna merah
                        onPressed: () {},
                      ),
                    ],
                  ), // Jarak setelah divider
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}