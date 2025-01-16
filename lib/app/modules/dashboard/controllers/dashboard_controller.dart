import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/detail_event_response.dart';
import '../../../data/event_response.dart';
import '../../../utils/api.dart';
import '../views/index_view.dart';
import '../views/profile_view.dart';
import '../views/your_event_view.dart';

class DashboardController extends GetxController {
  var selectedIndex = 0.obs;

  final _getConnect = GetConnect();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController eventDateController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  final token = GetStorage().read('token');

  Future<EventResponse> getEvent() async {
    final response = await _getConnect.get(
      BaseUrl.events,
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );
    return EventResponse.fromJson(response.body);
  }

  Future<DetailEventResponse> getDetailEvent({required int id}) async {
    final response = await _getConnect.get(
      '${BaseUrl.detailEvents}/$id',
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );
    return DetailEventResponse.fromJson(response.body);
  }

  var yourEvents = <Events>[].obs;

  Future<void> getYourEvent() async {
    final response = await _getConnect.get(
      BaseUrl.yourEvent,
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );
    final eventResponse = EventResponse.fromJson(response.body);

    yourEvents.value = eventResponse.events ?? [];
  }
  //TODO: Implement DashboardController

  void addEvent() async {
    final response = await _getConnect.post(
      BaseUrl.events,
      {
        'name': nameController.text,
        'description': descriptionController.text,
        'event_date': eventDateController.text,
        'location': locationController.text,
      },
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );

    if (response.statusCode == 201) {
      Get.snackbar(
        'Success',
        'Event Added',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      nameController.clear();
      descriptionController.clear();
      eventDateController.clear();
      locationController.clear();
      update();
      getEvent();
      getYourEvent();
      Get.close(1);
    } else {
      Get.snackbar(
        'Failed',
        'Event Failed to Add',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void editEvent({required int id}) async {
    final response = await _getConnect.post(
      '${BaseUrl.events}/$id',
      {
        'name': nameController.text,
        'description': descriptionController.text,
        'event_date': eventDateController.text,
        'location': locationController.text,
        '_method': 'PUT',
      },
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );

    if (response.statusCode == 200) {
      Get.snackbar(
        'Success',
        'Event Updated',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      nameController.clear();
      descriptionController.clear();
      eventDateController.clear();
      locationController.clear();

      update();
      getEvent();
      getYourEvent();
      Get.close(1);
    } else {
      Get.snackbar(
        'Failed',
        'Event Failed to Update',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Fungsi buat hapus event, tinggal kasih ID-nya
void deleteEvent({required int id}) async {
  // Kirim request POST ke server, tapi sebenarnya buat DELETE
  final response = await _getConnect.post(
    '${BaseUrl.deleteEvents}$id', // URL endpoint ditambah ID event
    {
      '_method': 'delete', // Hack biar request diubah jadi DELETE
    },
    headers: {'Authorization': "Bearer $token"}, // Header autentikasi (token user)
    contentType: "application/json", // Data dikirim dalam format JSON
  );

  // Cek respons server, kalau sukses ya good vibes
  if (response.statusCode == 200) {
    // Notifikasi sukses hapus event
    Get.snackbar(
      'Success', // Judul snack bar
      'Event Deleted', // Pesan sukses
      snackPosition: SnackPosition.BOTTOM, // Posisi snack bar di bawah
      backgroundColor: Colors.green, // Latar hijau biar lega
      colorText: Colors.white, // Teks putih biar baca enak
    );

    // Update UI dan reload data event biar up-to-date
    update(); // Kasih tahu UI kalau ada yang berubah
    getEvent(); // Refresh semua event
    getYourEvent(); // Refresh event user
  } else {
    // Kalau gagal, ya udah kasih tau user aja
    Get.snackbar(
      'Failed', // Judul snack bar
      'Event Failed to Delete', // Pesan error
      snackPosition: SnackPosition.BOTTOM, // Posisi snack bar di bawah
      backgroundColor: Colors.red, // Latar merah biar tegas
      colorText: Colors.white, // Teks putih biar tetap baca jelas
    );
  }
}
  void logOut() async {
    final response = await _getConnect.post(
      BaseUrl.logout,
      {},
      headers: {'Authorization': "Bearer $token"},
      contentType: "application/json",
    );

    if (response.statusCode == 200) {
      Get.snackbar(
        'Success',
        'Logout Success',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      GetStorage().erase();

      Get.offAllNamed('/login');
    } else {
      Get.snackbar(
        'Failed',
        'Logout Failed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> pages = [
    IndexView(),
    YourEventView(),
    ProfileView(),
  ];

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    getEvent();
    getYourEvent();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
