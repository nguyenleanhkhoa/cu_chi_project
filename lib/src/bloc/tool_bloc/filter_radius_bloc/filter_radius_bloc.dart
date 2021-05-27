import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'filter_radius_event.dart';
part 'filter_radius_state.dart';

class FilterRadiusBloc extends Bloc<FilterRadiusEvent, FilterRadiusState> {
  FilterRadiusBloc() : super(FilterRadiusInitial());

  @override
  Stream<FilterRadiusState> mapEventToState(
    FilterRadiusEvent event,
  ) async* {
    if (event is DisPlayFilterRadiusEvent) {
      yield await eventDisPlayFilter(event.show, event.radius);
    }
  }

  Future<FilterRadiusState> eventDisPlayFilter(bool show, String radius) async {
    return DisPlayFilterRadiusState(show, radius);
  }
}
