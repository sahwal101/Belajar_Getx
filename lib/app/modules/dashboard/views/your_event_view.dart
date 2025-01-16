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
          Get.to(() => AddView())?.then((_) {
            controller.getYourEvent();
          });
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Your Event'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.yourEvents.isEmpty) {
            return const Center(child: Text("Tidak ada data"));
          }
          return ListView.builder(
            itemCount: controller.yourEvents.length,
            controller: scrollController,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final event = controller.yourEvents[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    'https://picsum.photos/id/${event.id}/700/300',
                    fit: BoxFit.cover,
                    width: 500,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        height: 200,
                        child: Center(
                          child: Text('Image not found'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    event.name!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          event.location!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        label: const Text('Edit',
                            style: TextStyle(color: Colors.blue)),
                        onPressed: () {
                          Get.to(
                            () => EditView(
                              id: event.id!,
                              title: event.name!,
                            ),
                          );
                        },
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          controller.deleteEvent(id: event.id!);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}
