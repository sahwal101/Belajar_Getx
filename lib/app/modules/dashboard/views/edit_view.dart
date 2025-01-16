import 'package:flutter/material.dart';

import 'package:get/get.dart';

class EditView extends GetView {
  const EditView({super.key, required title, required id});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EditView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'EditView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
