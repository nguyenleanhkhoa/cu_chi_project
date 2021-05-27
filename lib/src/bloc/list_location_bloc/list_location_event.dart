part of 'list_location_bloc.dart';

@immutable
abstract class ListLocationEvent {}

class SearchLocationEvent extends ListLocationEvent {
  final String q;
  final bool loadMore;
  final int offset;
  SearchLocationEvent(this.q, this.loadMore, this.offset);
}

class InitSearchLocationEvent extends ListLocationEvent {}
