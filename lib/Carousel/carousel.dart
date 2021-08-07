// import 'package:flutter/material.dart';

// // ignore: must_be_immutable
// class CarouselPage extends StatefulWidget {
//   int? itemCount;
//   double? heigh;
//   PageController? controller;
//   double? abs;
//   Widget? child;
//   CarouselPage(
//       {Key? key,
//       this.itemCount,
//       this.heigh,
//       this.controller,
//       this.abs,
//       this.child})
//       : super(key: key);

//   @override
//   _CarouselPageState createState() => _CarouselPageState();
// }

// class _CarouselPageState extends State<CarouselPage> {
//   int correntpage = 0;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   httpsetdata();
//   //   pageController = PageController(
//   //       initialPage: correntpage, keepPage: false, viewportFraction: 0.7);
//   // }

//   // httpsetdata() async {
//   //   await Provider.of<ProviderData>(context, listen: false).trandingdata();
//   // }

//   animatediteambuilder(int index) {
//     return AnimatedBuilder(
//         animation: widget.controller!,
//         builder: (context, child) {
//           double value = 1;
//           if (widget.controller!.position.haveDimensions) {
//             value = widget.controller!.page! - index;
//             value = (1 - (value.abs() * widget.abs!)).clamp(0.0, 1.0);
//           }
//           return Center(
//             child: SizedBox(
//               height: Curves.easeOut.transform(value) * 200,
//               width: 400.0,
//               child: child,
//             ),
//           );
//         },
//         child: widget.child);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final providerdata = Provider.of<ProviderData>(context);
//     return Container(
//       height: widget.heigh,
//       width: double.infinity,
//       child: PageView.builder(
//         onPageChanged: (value) {
//           setState(() {
//             correntpage = value;
//           });
//         },
//         controller: widget.controller!,
//         itemCount: widget.itemCount,
//         itemBuilder: (context, index) {
//           return animatediteambuilder(index);
//         },
//       ),
//     );
//   }
// }
