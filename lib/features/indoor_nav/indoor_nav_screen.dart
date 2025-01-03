import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hsbc/features/indoor_nav/indoor_nav_bloc.dart';
import 'package:hsbc/utils/app_colors.dart';
import 'package:hsbc/utils/app_stirngs.dart';
import 'package:webview_flutter/webview_flutter.dart';

// region IndoorNavScreen
class IndoorNavScreen extends StatefulWidget {
  final String navigateToId;
  final String floorId;

  const IndoorNavScreen({super.key, required this.navigateToId, required this.floorId});

  @override
  State<IndoorNavScreen> createState() => _IndoorNavScreenState();
}
// endregion

class _IndoorNavScreenState extends State<IndoorNavScreen> {
  // region Bloc
  late IndoorNavBloc indoorNavBloc;

  // endregion

  // region Init
  @override
  void initState() {
    indoorNavBloc = IndoorNavBloc(context, widget.navigateToId, widget.floorId);
    indoorNavBloc.init();
    super.initState();
  }

  // endregion

  // region Dispose
  @override
  void dispose() {
    indoorNavBloc.dispose();
    super.dispose();
  }

  // endregion

  // region Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AvatarAppStrings.indoorMap)),
      body: body(),
    );
  }

  // endregion

  // region body
  Widget body() {
    return StreamBuilder<bool>(
        stream: indoorNavBloc.webLoadingCtrl.stream,
        initialData: true,
        builder: (context, snapshot) {
          if (snapshot.data!) {
            return const Center(
              child: SpinKitRipple(color: AppColors.primaryColor, size: 150),
            );
          }
          return WebViewWidget(controller: indoorNavBloc.webViewController);
        });
  }
// endregion
}
