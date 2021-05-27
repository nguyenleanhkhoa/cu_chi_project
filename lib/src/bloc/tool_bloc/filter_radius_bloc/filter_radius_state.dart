part of 'filter_radius_bloc.dart';

@immutable
abstract class FilterRadiusState {}

class FilterRadiusInitial extends FilterRadiusState {}

class DisPlayFilterRadiusState extends FilterRadiusState {
  final bool show;
  final String radius;
  DisPlayFilterRadiusState(this.show, this.radius);
}
