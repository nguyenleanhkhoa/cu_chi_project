import 'package:cuchi/src/bloc/base_observer/base_observe.dart';
import 'package:cuchi/src/bloc/tool_bloc/filter_radius_bloc/filter_radius_bloc.dart';
import 'package:cuchi/src/dto/dtos/current_postion.dto.dart';
import 'package:cuchi/src/utils/googleMapUtils.dart';
import 'package:cuchi/src/utils/resources/global_string.resource.dart';
import 'package:cuchi/src/widgets/dialog/dialog_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_radio_button/group_radio_button.dart';

class FilterRadiusWidget extends StatefulWidget {
  Function retreivedValue;
  FilterRadiusWidget({Key key, this.retreivedValue}) : super(key: key);

  @override
  _FilterRadiusWidgetState createState() => _FilterRadiusWidgetState();
}

class _FilterRadiusWidgetState extends State<FilterRadiusWidget> {
  String radiusNumByFilterMeters = "";
  String radiusNumByFilterKiloMeters = "";
  List<Map<String, dynamic>> listRadiusMeters = [
    {"id": 1, "value": "100"},
    {"id": 2, "value": "200"},
    {"id": 3, "value": "400"},
    {"id": 4, "value": "600"},
  ];
  final bloc = BaseObserver();
  @override
  void initState() {
    super.initState();
  }

  void onEventRadioButtonMeterClick(value) {
    setState(() {
      radiusNumByFilterMeters = value;
      onRetreivedValue(radiusNumByFilterMeters);
    });
  }

  void onEventRadioButtonKiloMeterClick(value) {
    setState(() {
      radiusNumByFilterKiloMeters = value;
      onRetreivedValue(radiusNumByFilterKiloMeters);
    });
  }

  Future<void> onRetreivedValue(value) async {
    CurrentPositionDto currentPositionDto;
    await bloc.callFunctionFuture(func: () async {
      currentPositionDto = await GoogleMapUtils.getCurrentPosition();
      if (!currentPositionDto.isCurrentValid) {
        bloc.error(message: AppString.ALERT_MESSAGE_CHECK_LOCATION);
      }
    });

    if (currentPositionDto.isCurrentValid) {
      widget.retreivedValue(value);
    }
  }

  List<Widget> addGroupRadioButtonMeters(String radius) {
    List<Widget> listRdbtn = [];
    for (var item in listRadiusMeters.where((element) => element["id"] <= 2)) {
      listRdbtn.add(RadioButton(
          description: item['value'] + "m",
          value: item['value'],
          groupValue: radius,
          onChanged: onEventRadioButtonMeterClick));
    }
    return listRdbtn;
  }

  List<Widget> addGroupRadioButtonKiloMeters(String radius) {
    List<Widget> listRdbtn = [];
    for (var item in listRadiusMeters.where((element) => element["id"] > 2)) {
      listRdbtn.add(RadioButton(
          description: item['value'] + "m",
          value: item['value'],
          groupValue: radius,
          onChanged: onEventRadioButtonKiloMeterClick));
    }
    return listRdbtn;
  }

  @override
  Widget build(BuildContext context) {
    bool show = false;
    String radius = "";
    return BlocConsumer<FilterRadiusBloc, FilterRadiusState>(
      listener: (context, state) {
        //
      },
      builder: (context, state) {
        if (state is DisPlayFilterRadiusState) {
          show = state.show;
          radius = state.radius;
        }
        return show
            ? Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 0.5, color: Colors.grey),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(AppString.FILTER_BY_RADIUS),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: addGroupRadioButtonMeters(radius),
                        ),
                        Column(
                          children: addGroupRadioButtonKiloMeters(radius),
                        ),
                      ],
                    )
                  ],
                ),
              )
            : Container(
                height: 0,
                width: 0,
              );
      },
    );
  }
}
