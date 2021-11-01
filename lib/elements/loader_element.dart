import 'package:flutter/material.dart';

Widget buildLoaderWidget() {
  return Center(
    child: Column(
      children: const [
        CircularProgressIndicator(),
      ],
    ),
  );
}
