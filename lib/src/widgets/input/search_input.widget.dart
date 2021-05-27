import 'package:cuchi/src/utils/resources/global_string.resource.dart';
import 'package:cuchi/styles/theme.dart';
import 'package:flutter/material.dart';

class SearchInputWidget extends StatelessWidget {
  final GestureTapCallback onFocus;
  final Function(String) onSubmitted;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final bool readonly;
  final bool autoFocus;
  final Function(String) onChanged;

  final TextEditingController controller;
  final FocusNode focusNode;
  bool hasShadowBox = false;

  SearchInputWidget(
      {Key key,
      this.readonly = false,
      this.autoFocus = false,
      this.onFocus,
      this.prefixIcon,
      this.controller,
      this.focusNode,
      this.suffixIcon,
      this.hasShadowBox,
      this.onSubmitted,
      this.onChanged})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    // Future<void> _getRadius(String value, SearchBloc searchBloc) async {
    //   final SharedPreferences prefs = await _prefs;
    //   final int radius = (prefs.getInt('radiusValue') ?? 0);
    //   final double latLng = prefs.getDouble('latlocal') ?? 0;
    //   final double lng = prefs.getDouble('lnglocal') ?? 0;
    //   List<String> type = [];
    //   Data.listTab.map((element) {
    //     if (element["checked"] == true) {
    //       type.add(element["id"].toString());
    //     }
    //   }).toList();
    //   if (radius != 0 && latLng != 0.0 && lng != 0.0) {
    //     searchBloc.add(SearchRadiusEvent(latLng, lng, radius, value, 0, false));
    //   } else {
    //     searchBloc.add(
    //         LoadingSearchAddressEvent(value, UtilsCommon.getTab(), false, 0));
    //   }
    // }

    // SearchBloc searchBloc = BlocProvider.of<SearchBloc>(context);

    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 10.0),
      decoration: BoxDecoration(
          boxShadow: [
            hasShadowBox
                ? BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 2), // changes position of shadow
                  )
                : null,
          ].where((element) => element != null).toList(),
          color: Colors.white,
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          prefixIcon != null
              ? Expanded(
                  flex: 1,
                  child: Center(
                    child: prefixIcon,
                  ))
              : const SizedBox(
                  width: 20.0,
                ),
          Expanded(
            flex: 6,
            child: TextField(
              autofocus: autoFocus,
              readOnly: readonly,
              focusNode: focusNode,
              controller: controller,
              onChanged: onChanged,
              onTap: onFocus,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 13),
                hintText: AppString.TITLE_INPUT,
                border: InputBorder.none,
                // contentPadding: EdgeInsets.only(left: 10.0),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [suffixIcon],
                )),
          )
        ],
      ),
    );
  }
}
