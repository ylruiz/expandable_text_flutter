import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light().copyWith(
        checkboxTheme: const CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3)),
          ),
          splashRadius: 0,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ExpandableText'),
        ),
        body: const MyForm(),
      ),
    );
  }
}

class MyForm extends StatelessWidget {
  const MyForm({super.key});

  static const List<String> _checkboxListTileTitles = [
    'Lorem ipsum dolor sit amet,',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed lacinia massa eget nisl vestibulum, eget semper mauris ultricies. Phasellus fermentum sodales est, nec congue magna ...',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed lacinia massa eget nisl vestibulum, eget semper mauris ultricies. Phasellus fermentum sodales est, nec congue magna bibendum nec. Praesent aliquet erat sit amet justo egestas hendrerit. Vivamus imperdiet ex in eros faucibus, sed malesuada nibh interdum. Integer suscipit imperdiet odio, a auctor neque hendrerit eget. Sed in aliquam justo, non fringilla odio. Sed malesuada id lectus eget suscipit. Aliquam consequat nunc eu mauris ullamcorper, ac rutrum quam lobortis. Donec eu elit eget elit sollicitudin gravida. Quisque aliquet purus',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed lacinia massa eget nisl vestibulum, eget semper mauris ultricies. Phasellus fermentum sodales est, nec congue magna bibendum nec. Praesent aliquet erat sit amet justo egestas hendrerit. Vivamus imperdiet ex in eros faucibus, sed malesuada nibh interdum. Integer suscipit imperdiet odio, a auctor neque hendrerit eget. Sed in aliquam justo, non fringilla odio. Sed malesuada id lectus eget suscipit. Aliquam consequat nunc eu mauris ullamcorper, ac rutrum quam lobortis. Donec eu elit eget elit sollicitudin gravida. Quisque aliquet purus non enim malesuada rhoncus. Suspendisse fringilla lorem non quam lobortis, eu auctor tortor lobortis. Proin in dui vel dolor malesuada lobortis. Integer lobortis lectus vel pharetra ullamcorper. Sed nec mi vitae ipsum ultricies posuere eget at augue. Aenean vestibulum interdum ipsum, a aliquam magna pharetra eu.',
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _CheckboxListTileWithExpandableText(
                text: _checkboxListTileTitles[index],
              );
            },
            childCount: _checkboxListTileTitles.length,
          ),
        ),
      ],
    );
  }
}

class _CheckboxListTileWithExpandableText extends StatefulWidget {
  const _CheckboxListTileWithExpandableText({required this.text});

  final String text;

  @override
  State<_CheckboxListTileWithExpandableText> createState() =>
      _CheckboxListTileWithExpandableTextState();
}

class _CheckboxListTileWithExpandableTextState
    extends State<_CheckboxListTileWithExpandableText> {
  bool _isExpanded = false;
  bool _checkboxValue = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _checkboxValue,
          onChanged: (_) => setState(() {
            _checkboxValue = !_checkboxValue;
          }),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 12, 8),
            child: LayoutBuilder(
              builder: (_, constraints) {
                final text = widget.text;

                TextPainter textPainter = TextPainter(
                  text: TextSpan(text: text),
                  textAlign: TextAlign.start,
                  textDirection: Directionality.of(context),
                  textScaleFactor: MediaQuery.textScaleFactorOf(context),
                );
                textPainter.layout(
                  minWidth: constraints.minWidth,
                  maxWidth: constraints.maxWidth,
                );
                final lineHeight = textPainter.preferredLineHeight;
                final textHeight = textPainter.size.height;
                final hasTextMoreThanThreeLines = textHeight >= lineHeight * 4;

                const textStyle = TextStyle(color: Colors.black);

                if (!hasTextMoreThanThreeLines) {
                  return Text(
                    text,
                    style: textStyle,
                  );
                }

                return GestureDetector(
                  onTap: () => setState(() {
                    _isExpanded = !_isExpanded;
                  }),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.fastLinearToSlowEaseIn,
                    alignment: Alignment.topLeft,
                    child: _isExpanded
                        ? Text(
                            text,
                            style: textStyle,
                          )
                        : ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black,
                                  Colors.transparent,
                                ],
                                tileMode: TileMode.mirror,
                              ).createShader(bounds);
                            },
                            child: Text(
                              text,
                              style: textStyle,
                              maxLines: _isExpanded ? null : 3,
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
