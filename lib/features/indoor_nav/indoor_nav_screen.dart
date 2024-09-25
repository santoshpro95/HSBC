import 'package:flutter/material.dart';
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
      backgroundColor: Colors.white,
      body: body(),
    );
  }

  // endregion

  // region body
  Widget body() {
    return Column(
      children: [
        loadingProgress(),
        Expanded(
          child: StreamBuilder<bool>(
            stream: indoorNavBloc.webLoadingCtrl.stream,
            builder: (context, snapshot) {
              return WebViewWidget(controller: indoorNavBloc.webViewController);
            }
          ),
        ),
      ],
    );
  }
// endregion

// region loadingProgress
Widget loadingProgress(){
    return StreamBuilder<int>(
      stream: indoorNavBloc.progressLoadingCtrl.stream,
      initialData: 1,
      builder: (context, snapshot) {
        return SizedBox(
            height: 2,
            child: LinearProgressIndicator(color: AppColors.purpleColor,
            backgroundColor: AppColors.greyColor,
              value: snapshot.data!/10,
            ));
      }
    );
}
// endregion
}
