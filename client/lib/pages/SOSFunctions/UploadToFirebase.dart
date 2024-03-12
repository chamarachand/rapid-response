import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class UploadToFirebase {
  Future<String?> uploadImageToFirebase(File? image) async {
    if (image == null) return null; // Early exit if no image

    final storageRef = FirebaseStorage.instance.ref();
    final imagesRef = storageRef.child("sos_images/${DateTime.now()}.jpg");

    try {
      await imagesRef.putFile(image); // Upload!
      final downloadURL = await imagesRef.getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (e) {
      // Handle errors (consider showing a dialog or a snackbar)
      print("Upload failed: $e");
      return null;
    }
  }
}
