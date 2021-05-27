import 'package:cuchi/global_constant.dart';
import 'package:cuchi/src/model/models.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ShareLocationScreen extends StatefulWidget {
  static const routeName = '/share-location';

  @override
  _ShareLocationScreenState createState() => _ShareLocationScreenState();
}

class _ShareLocationScreenState extends State<ShareLocationScreen> {
  String text = '';

  String subject = '';

  List<String> imagePaths = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    DetailPlaceScreenDto idPlace = ModalRoute.of(context).settings.arguments;
    text = URL_SHARE_API + idPlace.id.toString();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: 25,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text(
          "Chia sẻ",
          style: Theme.of(context)
              .textTheme
              .headline3
              .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.height,
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                            image: DecorationImage(
                                image: NetworkImage(
                                  idPlace.attachments.length > 0
                                      ? urlApi +
                                          "/api/v1/attachments/download/" +
                                          idPlace.attachments[0].id.toString()
                                      : urlApi +
                                          '/api/v1/attachments/download/1',
                                ),
                                fit: BoxFit.fill),
                          ),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                idPlace.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 16),
                              ),
                              Text(
                                "${idPlace.point.lat} ${idPlace.point.lng}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300, fontSize: 14),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: TextField(
                            controller: TextEditingController(text: text),
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: "Liên kết để chia sẻ ",
                              labelStyle: TextStyle(
                                  color: Colors.black87, fontSize: 24),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Text("Chia sẻ:"),
                    GestureDetector(
                        onTap: () {
                          _onShare(context);
                        },
                        child: Icon(Icons.share))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject();

    if (imagePaths.isNotEmpty) {
      await Share.shareFiles(imagePaths,
          text: text,
          subject: subject,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share(text,
          subject: subject,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }
}
