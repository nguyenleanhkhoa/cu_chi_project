import 'package:cuchi/src/dto/dtos/attachments.dto.dart';

class PhotoGalleryDto {
  List<AttachmentDto> listAttachments;
  int currentIndex;
  PhotoGalleryDto({this.listAttachments, this.currentIndex});

  PhotoGalleryDto.fromJson(Map<String, dynamic> json)
      : listAttachments = json['listAttachments'],
        currentIndex = json['currentIndex'];
}
