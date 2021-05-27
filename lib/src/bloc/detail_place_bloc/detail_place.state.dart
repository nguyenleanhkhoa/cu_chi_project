part of 'detail_place.bloc.dart';

class DetailPlaceStateLoadInProgress extends DetailPlaceState {}

class DetailPlaceStateLoadInFailure extends DetailPlaceState {}

class DetailPlaceState {
  final bool isLoading;
  final bool isGetFail;
  final bool isGetSuccess;
  final bool isBookMarked;
  final DetailPlaceScreenDto detailPlaceContent;
  final int placeId;
  final String messageError;
  final bool isGetDirectionSuccess;

  DetailPlaceState({
    this.isLoading,
    this.isGetFail,
    this.isGetSuccess,
    this.isBookMarked,
    this.detailPlaceContent,
    this.messageError,
    this.placeId,
    this.isGetDirectionSuccess,
  });
  factory DetailPlaceState.initial() {
    return DetailPlaceState(
      isLoading: true,
      isBookMarked: false,
      isGetFail: false,
      isGetSuccess: false,
    );
  }
  factory DetailPlaceState.loading() {
    return DetailPlaceState(
      isBookMarked: false,
      isGetFail: false,
      isGetSuccess: false,
      isLoading: true,
    );
  }
  factory DetailPlaceState.getDataSuccess(content) {
    return DetailPlaceState(
      detailPlaceContent: content,
      isBookMarked: true,
      isLoading: false,
      isGetFail: false,
      isGetSuccess: true,
    );
  }
  factory DetailPlaceState.getDateFail(messageError) {
    return DetailPlaceState(
      messageError: messageError,
      isLoading: false,
      isBookMarked: false,
      isGetFail: true,
      isGetSuccess: false,
    );
  }
}
