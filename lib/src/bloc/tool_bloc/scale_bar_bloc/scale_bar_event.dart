part of 'scale_bar_bloc.dart';

@immutable
abstract class ScaleBarEvent {}

class ChangeScaleBarValueEvent extends ScaleBarEvent {
  final CameraPosition currentPos;
  final double zoomTmp;
  ChangeScaleBarValueEvent(this.currentPos, this.zoomTmp);
}
