import 'package:cuchi/global_constant.dart';
import 'package:cuchi/src/model/models.dart';
import 'package:cuchi/src/screens/view/map_overview_detail.screen.dart';
import 'package:flutter/material.dart';

List<PlaceAttachmentModel> listplace = [];

class NearByLocationWidget extends StatelessWidget {
  final GestureTapCallback onShowAllList;
  final Function onNavigateTo;
  Function getGetId;
  List<PlaceAttachmentModel> listplace;
  NearByLocationWidget(
      {Key key,
      this.onShowAllList,
      this.onNavigateTo,
      this.getGetId,
      this.listplace})
      : super(key: key);
  void onNavigateToDetail(id) {
    onNavigateTo(id);
  }

  void triggerGetId(index) {
    getGetId(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.5, color: Colors.grey),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Những điểm gần đây',
            style: TextStyle(
                fontSize: 14 * MediaQuery.of(context).textScaleFactor),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            height: (MediaQuery.of(context).size.height / 8.5),
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listplace.length,
              itemBuilder: (context, item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: renderImage(item, context),
                );
              },
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onShowAllList,
              child: Text(
                'Hiển thị danh sách',
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget renderImage(item, context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(MapOverviewDetail.routeName,
            arguments: ParamMapDetail(
                paramRequest: ParamRequest(
                    id: listplace[item].id,
                    type: listplace[item].type,
                    idPlace: 0),
                type: 1));
      },
      child: Container(
        width: (MediaQuery.of(context).size.height * 0.2) - 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          image: DecorationImage(
            image: NetworkImage(listplace[item].attachments.length > 0
                ? urlApi +
                    "/api/v1/attachments/download/" +
                    listplace[item].attachments[0].id.toString()
                : urlApi + "/api/v1/attachments/download/1"),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          width: (MediaQuery.of(context).size.height * 0.2) - 40,
          height: (MediaQuery.of(context).size.height * 0.2) - 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.black,
              Colors.transparent,
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
          ),
          padding: EdgeInsets.only(left: 5, bottom: 5, right: 5),
          child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                listplace[item].name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14 * MediaQuery.of(context).textScaleFactor),
              )),
        ),
      ),
    );
  }
}
