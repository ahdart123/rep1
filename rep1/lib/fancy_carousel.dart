import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FancySlider extends StatefulWidget {
  final List<String> images;

  const FancySlider({Key key, this.images}) : super(key: key);
  @override
  _FancySliderState createState() => _FancySliderState();
}

class _FancySliderState extends State<FancySlider> {
  List<bool> imageStatusIndicator;

  @override
  void initState() {
    super.initState();
    imageStatusIndicator = List(widget.images.length)
      ..fillRange(0, widget.images.length, false);
    imageStatusIndicator[0] = true;
  }

  Widget _imageErrorBuilder(
      BuildContext context, Object error, StackTrace trace) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
          ),
          SizedBox(
            height: 5,
          ),
          Text('Can\'t Download Image')
        ],
      ),
    );
  }

  Widget _imageFrameBuilder(BuildContext context, Widget child, int frame,
      bool wasSynchronouslyLoaded) {
    if (wasSynchronouslyLoaded) {
      return child;
    }
    return AnimatedOpacity(
      child: child,
      opacity: frame == null ? 0 : 1,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constarints) {
      return Stack(
        children: [
          Container(
            color: Color(0xff4a5562),
          ),
          CarouselSlider.builder(
            itemCount: widget.images.length,
            itemBuilder: (_, index) => Image.network(
              widget.images[index],
              fit: BoxFit.fill,
              frameBuilder: _imageFrameBuilder,
              errorBuilder: _imageErrorBuilder,
            ),
            options: CarouselOptions(
                height: constarints.maxHeight,
                autoPlay: true,
                autoPlayAnimationDuration: Duration(seconds: 1),
                onPageChanged: (pageIndex, _) {
                  setState(() {
                    imageStatusIndicator.fillRange(
                      0,
                      imageStatusIndicator.length,
                      false,
                    );
                    imageStatusIndicator[pageIndex] = true;
                  });
                }),
          ),
          Positioned(
            bottom: 10,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constarints.maxWidth),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...List.generate(
                      widget.images.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: _CarouselIndecator(
                          color: imageStatusIndicator[index] == false
                              ? Colors.orange
                              : Colors.purple,
                          radius: 5,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      );
    });
  }
}

class _CarouselIndecator extends StatelessWidget {
  final double radius;
  final Color color;
  const _CarouselIndecator({this.color, key, this.radius}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2 * radius,
      width: 2 * radius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 10),
        border: Border.all(width: 1, color: color),
      ),
      padding: EdgeInsets.all(radius * 0.15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: color,
        ),
      ),
    );
  }
}
