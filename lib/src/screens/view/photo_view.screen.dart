import 'package:cuchi/global_constant.dart';
import 'package:cuchi/src/dto/dtos/attachments.dto.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewScreen extends StatefulWidget {
  PhotoViewScreen({this.initialIndex, this.listAttachments})
      : pageController = PageController(initialPage: initialIndex);

  final int initialIndex;
  final List<AttachmentDto> listAttachments;
  final PageController pageController;
  @override
  _PhotoViewScreenState createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  int currentIndex;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onPageChanged(int index) {
      setState(() {
        currentIndex = index;
      });
    }

    return Scaffold(
        key: scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: PhotoViewGallery.builder(
          onPageChanged: onPageChanged,
          pageController: widget.pageController,
          scrollPhysics: const BouncingScrollPhysics(),
          itemCount: widget.listAttachments.length,
          builder: (BuildContext context, int index) {
            return _buildItem(context, index);
          },
        ));
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(urlApi +
          "/api/v1/attachments/download/" +
          widget.listAttachments[index].id.toString()),
      initialScale: PhotoViewComputedScale.contained,
    );
  }
}
