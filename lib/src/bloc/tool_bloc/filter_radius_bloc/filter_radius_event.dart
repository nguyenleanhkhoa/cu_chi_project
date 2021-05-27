part of 'filter_radius_bloc.dart';

@immutable
abstract class FilterRadiusEvent {}

class DisPlayFilterRadiusEvent extends FilterRadiusEvent {
  final bool show;
  final String radius;
  DisPlayFilterRadiusEvent(this.show, this.radius);
}
