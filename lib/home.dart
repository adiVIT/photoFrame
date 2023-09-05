import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:image_cropper/image_cropper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Uint8List? _pickedImage;
  bool _isContainerVisible = false;
  Uint8List? _usedImage;
  bool _usedImageVisible = false;

  Uint8List? _originalImage;
  String _pickedImageFramePath = 'images/user_image_frame_1.png';
  bool _showMaskedImage = true;
  bool _showOriginalImage = true;
  bool _showSelectedImage = false;
  Future<void> pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final imageBytes = await pickedImage.readAsBytes();

      // Create an instance of ImageCropper
      final imageCropper = ImageCropper();

      try {
        final croppedImage = await imageCropper.cropImage(
          sourcePath: pickedImage.path,
          // Configure cropping settings as needed
        );

        if (croppedImage != null) {
          final croppedBytes = await croppedImage.readAsBytes();
          setState(() {
            _pickedImage = croppedBytes;
            _originalImage = Uint8List.fromList(imageBytes);
            _usedImage = croppedBytes; // Set the used image
            _isContainerVisible = true;
            _showOriginalImage = false;
            _usedImageVisible = true;
          });
        }
      } catch (e) {
        print('Error during cropping: $e');
      }
    }
  }

  void clearImage() {
    setState(() {
      _pickedImage = null;
      _isContainerVisible = false;
      _showOriginalImage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: Color.fromRGBO(8, 129, 121, 1.0),
        ),
        title: Text('Add Image/Icon'),
        titleTextStyle: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 22,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            clearImage();
          },
        ),
        iconTheme: IconThemeData(
          color: Colors.grey.shade600,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _isContainerVisible
                ? Center(
                    child: Dialog(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: 800,
                        height: 400,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    clearImage();
                                  },
                                ),
                              ],
                            ),
                            Text(
                              'Uploaded Image',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: Stack(
                                children: [
                                  if (_pickedImage != null &&
                                      _pickedImageFramePath != null)
                                    _showOriginalImage
                                        ? Image.memory(
                                            _originalImage!,
                                            fit: BoxFit.cover,
                                          )
                                        : WidgetMask(
                                            blendMode: BlendMode.screen,
                                            child: Image.asset(
                                              _pickedImageFramePath,
                                              fit: BoxFit.cover,
                                            ),
                                            mask: Image.memory(
                                              _pickedImage!,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                  else
                                    Container(),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildOriginalButton(),
                                SizedBox(width: 10),
                                _buildImageButton(
                                    'images/user_image_frame_1.png'),
                                SizedBox(width: 10),
                                _buildImageButton(
                                    'images/user_image_frame_2.png'),
                                SizedBox(width: 10),
                                _buildImageButton(
                                    'images/user_image_frame_3.png'),
                                SizedBox(width: 10),
                                _buildImageButton(
                                    'images/user_image_frame_4.png'),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _showSelectedImage = true;
                                  clearImage();
                                });
                              },
                              child: Text('Use This Image'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Upload Image',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              pickImage(context);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Color.fromRGBO(8, 129, 121, 1.0),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                            ),
                            child: Text(
                              'Choose from Device',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            Stack(
              children: [
                SizedBox(height: 20),
                _buildSelectedImageContainer(),
              ],
            ),
            // Add spacing between the two containers
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImageContainer() {
    return _showSelectedImage && _usedImageVisible && _usedImage != null
        ? Container(
            width: double.infinity,
            height: 200,
            child: Center(
              child: _showMaskedImage
                  ? WidgetMask(
                      blendMode: BlendMode.screen,
                      child: Image.asset(
                        _pickedImageFramePath,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                      mask: Image.memory(
                        _usedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : Container(),
            ),
          )
        : SizedBox(
            height: 0); // Use SizedBox to avoid any unintended constraints
  }

  Widget _buildOriginalButton() {
    return Container(
      width: 60,
      height: 30,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _showMaskedImage = true;
            _showOriginalImage = true;
          });
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(5), // Adjust the radius as needed
            side: BorderSide(color: Colors.grey), // Set the border color
          ),
        ),
        child: Text(
          'Original',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 8,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildImageButton(String imagePath) {
    return Container(
      width: 30,
      height: 35,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _pickedImageFramePath = imagePath;
            _showOriginalImage = false;
            _showMaskedImage = true; // Reset masking
          });
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey),
          ),
          primary: Colors.white,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
