import 'package:cached_network_image/cached_network_image.dart';
import 'package:cuchi/global_constant.dart';
import 'package:cuchi/src/bloc/bloc.g.dart';

import 'package:cuchi/src/model/models.dart';
import 'package:cuchi/src/screens/view/detail_place.screen.dart';
import 'package:cuchi/src/utils/UtilsCommon.dart';
import 'package:cuchi/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DescriptionPlaceWidget extends StatefulWidget {
  final GestureTapCallback onTap;

  const DescriptionPlaceWidget({Key key, this.onTap}) : super(key: key);

  @override
  _DescriptionPlaceWidgetState createState() => _DescriptionPlaceWidgetState();
}

class _DescriptionPlaceWidgetState extends State<DescriptionPlaceWidget>
    with TickerProviderStateMixin {
  bool onShow = false;

  UserInforBloc userInforBloc;

  DetailPlaceListModel detailInMap;
  Animation<double> descriptionAnimation;
  AnimationController descriptionAnimationController;

  void initAnimation() {
    descriptionAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    descriptionAnimation = Tween(begin: 0.0, end: 150.0).animate(
        CurvedAnimation(
            parent: descriptionAnimationController, curve: Curves.ease));
  }

  @override
  void initState() {
    initAnimation();
    userInforBloc = BlocProvider.of<UserInforBloc>(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailMapBloc, DetailMapState>(
        builder: (context, state) {
      if (state is LoadSuccessDetailPlaceInMapState) {
        onShow = true;

        detailInMap = state.detail;
      } else if (state is ShowDescriptionState) {
        onShow = state.show;
      }
      return onShow
          ? Padding(
              padding:
                  const EdgeInsets.only(bottom: 20.0, left: 15.0, right: 15.0),
              child: Container(
                height: 140.0,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Card(
                        child: Column(
                          children: [
                            Expanded(
                              child: informationDetail(
                                  context, detailInMap, userInforBloc),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: -15.0,
                      top: -6.0,
                      child: TextButton(
                        onPressed: widget.onTap,
                        child: Icon(Icons.clear, size: 20, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              height: 0,
              width: 0,
            );
    });
  }
}

Widget informationDetail(
    BuildContext context, detailInMap, UserInforBloc userInforBloc) {
  return Padding(
    padding: const EdgeInsets.only(left: 15, top: 5.0, bottom: 5.0),
    child: Row(children: [
      Expanded(
        flex: 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            height: 100,
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: urlApi +
                  "/api/v1/attachments/download/" +
                  detailInMap.attachments[0].id.toString(),
              placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                backgroundColor: LightTheme.colorMain,
              )),
              errorWidget: (context, url, error) =>
                  Container(color: Colors.black12, child: Icon(Icons.warning)),
            ),
          ),
        ),
      ),
      Expanded(
        flex: 5,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 20.0, top: 15.0, bottom: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                detailInMap == null ? "" : detailInMap.name,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline3.copyWith(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.aspect_ratio_rounded,
                            color: Colors.black45,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            (detailInMap.area == null
                                    ? "Đang cập nhật"
                                    : detailInMap.area.toString() + " ") +
                                UtilsCommon.convertType(detailInMap.type),
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.black45,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  detailInMap == null
                                      ? ""
                                      : detailInMap.points[0].lat.toString() +
                                          ", " +
                                          detailInMap.points[0].lng.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 20,
                          color: Colors.black45,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                DetailPlaceScreen.routeName,
                                arguments: PlaceDetailModel(
                                    id: detailInMap.id,
                                    type: detailInMap.type));
                            userInforBloc
                                .add(CloseDialogUserInformationEvent());
                          },
                          child: Text(
                            "Xem chi tiết",
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.orange[800]),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    ]),
  );
}
