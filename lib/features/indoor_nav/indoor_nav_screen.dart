import 'package:flutter/material.dart';
import 'package:hsbc/features/indoor_nav/indoor_nav_bloc.dart';
import 'package:hsbc/utils/app_constants.dart';
import 'package:hsbc/utils/app_stirngs.dart';
import 'package:situm_flutter/wayfinding.dart';

// region IndoorNavScreen
class IndoorNavScreen extends StatefulWidget {
 final Function? mapViewLoadAction;
 final String content;
  const IndoorNavScreen({super.key, this.mapViewLoadAction, required this.content});

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
    indoorNavBloc = IndoorNavBloc(context, widget.mapViewLoadAction, widget.content);
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
    return Stack(children: [
      StreamBuilder<bool>(
          stream: indoorNavBloc.loadingCtrl.stream,
          builder: (context, snapshot) {
            return MapView(
              key: const Key("situm_map"),
              configuration: MapViewConfiguration(
                // Your Situm credentials.
                // Copy config.dart.example if you haven't already.
                situmApiKey: AvatarAppConstants.situmApiKey,
                // Set your building identifier:
                buildingIdentifier: AvatarAppConstants.buildingIdentifier,
                // Your remote identifier, if any:
                remoteIdentifier: AvatarAppConstants.remoteIdentifier,
                // The viewer domain:
                viewerDomain: AvatarAppConstants.viewerDomain,
              ),
              // Load callback:
              onLoad: indoorNavBloc.onLoad,
            );
          }),
      Container(height: 40, color: Colors.white)
    ]);
  }
// endregion
}
