class AttachmentDto {
  final int id;
  final String name;
  final String file;
  final String fileType;
  final int status;
  final int createdAt;
  final int updatedAt;

  AttachmentDto(
      {this.id,
      this.name,
      this.file,
      this.fileType,
      this.status,
      this.createdAt,
      this.updatedAt});

  AttachmentDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        file = json['file'],
        fileType = json['fileType'],
        status = json['status'],
        createdAt = json['createdAt'],
        updatedAt = json['updatedAt'];
}
