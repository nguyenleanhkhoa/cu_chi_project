class CurrentPositionDto {
  final double lat;
  final double lng;
  final bool isCurrentValid;

  CurrentPositionDto({this.lat, this.lng, this.isCurrentValid = false});
}
