part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class LoadingSearchAddressEvent extends SearchEvent {
  final String q;
  final bool loadMore;
  final int offset;
  final List<String> type;
  LoadingSearchAddressEvent(this.q, this.type, this.loadMore, this.offset);
}

class DeleteSearchAddressEvent extends SearchEvent {
  final String text;
  final bool showDelete;
  DeleteSearchAddressEvent(this.text, this.showDelete);
}

class SearchRadiusEvent extends SearchEvent {
  final double lnglocal;
  final double latlocal;
  final int radius;
  final String q;
  final bool loadMore;
  final int offset;
  SearchRadiusEvent(this.latlocal, this.lnglocal, this.radius, this.q,
      this.offset, this.loadMore);
}

class BindingDataShareEvent extends SearchEvent {
  final List<PlaceListPoinModel> data;
  BindingDataShareEvent(this.data);
}

class LoaddingMarkerHisEvent extends SearchEvent {
  final String q;
  LoaddingMarkerHisEvent(this.q);
}

class DeleteMarkerHisEvent extends SearchEvent {
  DeleteMarkerHisEvent();
}

class LoadingPolylineHisEvent extends SearchEvent {
  final String q;
  LoadingPolylineHisEvent(this.q);
}

class DeletePolylineHisEvent extends SearchEvent {}

class LoadingPolygonIdHisEvent extends SearchEvent {
  final String q;
  final int typeId;
  LoadingPolygonIdHisEvent(this.typeId, this.q);
}

class DeletePolygonIdHisEvent extends SearchEvent {
  final int typeId;
  DeletePolygonIdHisEvent(this.typeId);
}
