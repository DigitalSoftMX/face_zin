part of 'widgets.dart';

class CustomText extends StatelessWidget {
  final String string;
  final Size? size;
  final Color color;
  final FontWeight fontWeight;
  final double? fontsize;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final int? maxLines;
  const CustomText({
    Key? key,
    required this.string,
    this.size,
    required this.color,
    required this.fontWeight,
    this.fontsize,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      string,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlign,
      style: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: size == null ? fontsize : size!.height * 0.014,
          color: color,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
