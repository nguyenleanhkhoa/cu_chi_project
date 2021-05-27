part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class LoadSuccessSearchAddressState extends SearchState {
  final String textHistory;
  final Result listPlace;
  final bool show;

  LoadSuccessSearchAddressState(this.listPlace, this.show, this.textHistory);
}

class LoadMoreSearchAddressState extends SearchState {
  final Result listPlace;
  final bool show;
  LoadMoreSearchAddressState(this.listPlace, this.show);
}

class LoadMoreSearchRadiusState extends SearchState {
  final Result listPlace;
  final bool show;
  LoadMoreSearchRadiusState(this.listPlace, this.show);
}

class LoadMoreSuccessSearchRadiusState extends SearchState {
  final Result listPlace;
  final bool show;
  final String textHistory;
  LoadMoreSuccessSearchRadiusState(this.listPlace, this.textHistory, this.show);
}

class LoadSuccessSearchRadiusState extends SearchState {
  final Result listPlace;
  final bool show;
  final String textHistory;
  LoadSuccessSearchRadiusState(this.listPlace, this.textHistory, this.show);
}

class LoadFailSearchRadiusState extends SearchState {
  final String message;
  LoadFailSearchRadiusState(this.message);
}

class DeleteSearchSuccessAddressState extends SearchState {
  final bool show;
  final String value;
  DeleteSearchSuccessAddressState(this.value, this.show);
}

class LoadFailSearchAddressState extends SearchState {
  final String error;
  LoadFailSearchAddressState(this.error);
}

class BindingDataShareState extends SearchState {
  final Result listPlace;
  final bool show;
  final String textHistory;
  final bool dataShare;
  BindingDataShareState(
      this.listPlace, this.textHistory, this.show, this.dataShare);
}

class LoadSuccessMarkerHisState extends SearchState {
  final List<PlaceListPoinModel> place;
  final bool show;
  final String textHis;
  LoadSuccessMarkerHisState(this.place, this.show, this.textHis);
}

class LoadSuccessPolygonHisState extends SearchState {
  final List<PlaceListPoinModel> data;
  final bool show;
  final String textHis;
  LoadSuccessPolygonHisState(this.data, this.show, this.textHis);
}

class LoadSuccessPolylineHisState extends SearchState {
  final List<PlaceListPoinModel> data;
  final bool show;
  final String textHis;
  LoadSuccessPolylineHisState(this.data, this.show, this.textHis);
}

class LoadFailMarkerHisState extends SearchState {
  final String error;
  LoadFailMarkerHisState(this.error);
}

class DeleteSuccessPolylineHisState extends SearchState {
  DeleteSuccessPolylineHisState();
}

class DeleteSuccessPolygonHisState extends SearchState {
  final int typeId;
  DeleteSuccessPolygonHisState(this.typeId);
}

class DeleteSuccessMarkerHisState extends SearchState {
  DeleteSuccessMarkerHisState();
}
