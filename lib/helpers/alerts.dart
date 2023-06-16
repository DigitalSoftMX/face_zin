part of 'helpers.dart';

Future<bool> showAlert({
  required BuildContext context,
  required String title,
  required String message,
  int value = 1,
  bool verify = false,
  bool showcontinue = false,
}) async {
  final size = MediaQuery.of(context).size;
  return await showDialog(
    useSafeArea: false,
    context: context,
    builder: (_) => Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.transparent,
        child: FadeIn(
          duration: const Duration(milliseconds: 300),
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Stack(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height,
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(
                      sigmaX: 8.0,
                      sigmaY: 8.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0, 0),
                  child: Container(
                    width: size.width * 0.65,
                    height: size.height * 0.45,
                    decoration: BoxDecoration(
                      color: MainColor.bgPrimary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: const Alignment(0.4, -0.7),
                          child: Container(
                            decoration: BoxDecoration(
                              color: MainColor.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                size.width * 0.25,
                              ),
                            ),
                            width: size.width * 0.25,
                            height: size.width * 0.25,
                          ),
                        ),
                        Align(
                          alignment: const Alignment(-0.4, -0.4),
                          child: Container(
                            decoration: BoxDecoration(
                              color: MainColor.bgSecondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                size.width * 0.25,
                              ),
                            ),
                            width: size.width * 0.25,
                            height: size.width * 0.25,
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0, -0.55),
                          child: SizedBox(
                            width: size.width * 0.65,
                            height: size.height * (value == 2 ? 0.12 : 0.15),
                            // child: SvgPicture.asset(
                            //   'assets/svg/case_$value.svg',
                            // ),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0.925, -0.925),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Container(
                              width: size.height * 0.04,
                              height: size.height * 0.04,
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.close,
                                color: MainColor.bgSecondary,
                                size: size.height * 0.03,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const Alignment(0, 0.9),
                          child: Container(
                            alignment: Alignment.center,
                            width: size.width * 0.6,
                            height: size.height * 0.15,
                            child: Column(
                              children: [
                                CustomText(
                                  string: title,
                                  textAlign: TextAlign.center,
                                  color: MainColor.bgSecondary,
                                  overflow: TextOverflow.visible,
                                  fontWeight: FontWeight.w900,
                                  fontsize: size.height * 0.02,
                                ),
                                SizedBox(
                                  width: size.width * 0.6,
                                  height: size.height * 0.05,
                                  child: CustomText(
                                    string: message,
                                    textAlign: TextAlign.center,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontsize: size.height * 0.018,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                                if (verify) ...[
                                  SizedBox(
                                    height: size.height * 0.05,
                                    width: size.width * 0.8,
                                    child: Center(
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'Verificala',
                                          style: TextStyle(
                                            color: MainColor.light,
                                            fontSize: size.height * 0.018,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          children: [
                                            TextSpan(
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context,
                                                          'verification');
                                                },
                                              text: ' aquí',
                                              style: TextStyle(
                                                fontSize: size.height * 0.018,
                                                fontWeight: FontWeight.bold,
                                                color: MainColor.bgSecondary
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ],
                            ),
                          ),
                        ),
                        if (showcontinue) ...[
                          Align(
                            alignment: const Alignment(
                              0,
                              0.9,
                            ),
                            child: SizedBox(
                              height: size.height * 0.05,
                              width: size.width * 0.3,
                              child: Center(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: CustomText(
                                    color: MainColor.primary,
                                    string: "Continuar",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

showLoading(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return showDialog(
    context: context,
    builder: (_) => Material(
      color: Colors.transparent,
      child: FadeIn(
        duration: const Duration(milliseconds: 300),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                clipBehavior: Clip.hardEdge,
                width: size.width * 0.4,
                height: size.height * 0.2,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 10.0),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingWiget(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
