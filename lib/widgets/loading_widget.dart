import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../theme/colors_theme.dart';

class LoadingWiget extends StatelessWidget {
  final bool color;
  const LoadingWiget({
    Key? key,
    this.color = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SpinKitFadingCube(
        key: const Key('animationLoading'),
        color: color ? MainColor.primary : MainColor.bgPrimary,
        size: size.height * 0.03,
      ),
    );
  }
}
