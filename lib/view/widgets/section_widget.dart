// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// // viewForHeaderInSection 每个section的Header
// typedef ViewForHeaderInSection = Widget Function(
//     BuildContext context, int section);
//
// // heightForHeaderInSection 每个sectionHeader的高度
// typedef HeightForHeaderInSection = double Function(int section);
//
// // numberOfRowsInSection 当前section的item个数
// typedef NumberOfRowsInSection = int Function(int section);
//
// // cellForRowAtIndexPath 每个section的item
// typedef CellForRowAtIndexPath = Widget Function(
//     BuildContext context, IndexPath indexPath);
//
// class IndexPath {
//   int section;
//   int row;
//
//   IndexPath(this.section, this.row);
// }
//
// class SectionTableView extends StatefulWidget {
//   final ViewForHeaderInSection viewForHeaderInSection;
//   final HeightForHeaderInSection heightForHeaderInSection;
//   final CellForRowAtIndexPath cellForRowAtIndexPath;
//   final int numberOfSections; // section个数
//   final NumberOfRowsInSection numberOfRowsInSection;
//   const SectionTableView({
//     required this.viewForHeaderInSection,
//     required this.heightForHeaderInSection,
//     required this.cellForRowAtIndexPath,
//     required this.numberOfSections,
//     required this.numberOfRowsInSection,
//   });
//
//   @override
//   _SectionTableViewState createState() => _SectionTableViewState();
// }
//
// class _SectionTableViewState extends State<SectionTableView> {
//   List<Widget> slivers = []; // CustomScrollView子组件
//   ScrollController scrollController = ScrollController();
//   GlobalKey tableKey = GlobalKey(); // CustomScrollView Key
//   List<GlobalKey> headerKeys = []; // 所有sectionHeader的Key
//   var curHeaderIndex = 0.obs; // 当前悬浮的sectionHeader下标
//   var curHeaderTransY = 0.0.obs;
//
//   @override
//   void initState() {
//     // 准备组件
//     initSlivers();
//     scrollController.addListener(() {
//       // CustomScrollView 在屏幕中Y坐标
//       double tableY = getWidgetOffsetY(tableKey);
//       // print('tableY: $tableY');
//
//       for (int i = 0; i < headerKeys.length; i++) {
//         // i
//         double curHeaderY = getWidgetOffsetY(headerKeys[i]);
//
//         // i + 1
//         double nextHeaderY = scrollController.position.maxScrollExtent;
//         if ((i + 1) < headerKeys.length) {
//           nextHeaderY = getWidgetOffsetY(headerKeys[i + 1]);
//         }
//
//         // 当前section高度
//         double curSectionHeight = nextHeaderY - curHeaderY;
//
//         if (((tableY - curSectionHeight) <= curHeaderY) &&
//             (curHeaderY <= tableY)) {
//           // 当前header在ScrollView中的OffsetY
//           double curHeaderOffsetY = curHeaderY - tableY;
//           // 当前section剩余高度（完全上划走前）
//           double bottomMargin = curHeaderOffsetY + curSectionHeight;
//           // 当前header size
//           Size headerSize = getWidgetSize(headerKeys[i]) ?? Size(0, 0);
//           if (bottomMargin < headerSize.height) {
//             curHeaderTransY.value = headerSize.height - bottomMargin;
//           } else {
//             curHeaderTransY.value = 0.0;
//           }
//           // print(curHeaderTransY.value);
//
//           if (curHeaderIndex.value != i) {
//             curHeaderIndex.value = i;
//             // print('第 ${curHeaderIndex.value} 个header悬浮');
//           }
//         }
//       }
//     });
//
//     super.initState();
//   }
//
//   // 获取组件offset.Y
//   double getWidgetOffsetY(GlobalKey key) {
//     RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
//     double offsetY = renderBox!.localToGlobal(Offset.zero).dy;
//     return offsetY;
//   }
//
//   // 获取组件size
//   Size? getWidgetSize(GlobalKey key) {
//     RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
//     return renderBox?.size;
//   }
//
//   @override
//   void dispose() {
//     scrollController.dispose();
//     super.dispose();
//   }
//
//   void initSlivers() {
//     headerKeys.clear();
//     slivers.clear();
//
//     List.generate(widget.numberOfSections, (section) {
//       // section header
//       GlobalKey headerKey = GlobalKey();
//       Widget sectionHeader = SliverToBoxAdapter(
//         child: Container(
//           key: headerKey,
//           child: widget.viewForHeaderInSection(context, section),
//         ),
//       );
//
//       headerKeys.add(headerKey);
//       slivers.add(sectionHeader);
//
//       int rowCount = widget.numberOfRowsInSection(section);
//       if (rowCount > 0) {
//         // 当前section有item
//         List<Widget> rows = [];
//         rows = List.generate(rowCount, (row) {
//           return SliverToBoxAdapter(
//             child:
//                 widget.cellForRowAtIndexPath(context, IndexPath(section, row)),
//           );
//         });
//         slivers.addAll(rows);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _initSubviews(),
//     );
//   }
//
//   Widget _initSubviews() {
//     return Stack(
//       children: [
//         CustomScrollView(
//           key: tableKey,
//           shrinkWrap: true,
//           controller: scrollController,
//           slivers: slivers,
//           physics: ClampingScrollPhysics(), // 禁用弹簧效果
//         ),
//         Obx(() {
//           return Positioned(
//             top: -curHeaderTransY.value,
//             child: widget.viewForHeaderInSection(context, curHeaderIndex.value),
//           );
//         }),
//       ],
//     );
//   }
// }
//
// Widget tableWidget() {
//   return SectionTableView(
//     viewForHeaderInSection: (BuildContext context, int section) {
//       return Container(
//         height: 50,
//         color: Colors.white,
//         child: Center(
//           child: Text(
//             'Header ${services[section].uuid}',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       );
//     },
//     numberOfRowsInSection: (section) {
//       return services[section].characteristics.length;
//     },
//     numberOfSections: services.length,
//     heightForHeaderInSection: (int section) {
//       return 100;
//     },
//     cellForRowAtIndexPath: (BuildContext context, IndexPath indexPath) {
//       return tableCell(indexPath.section, indexPath.row);
//     },
//   );
//   // SectionTableView(
//   //     sectionCount: this.services.length,
//   //     numOfRowInSection: (section){
//   //   return this.services[section].characteristics.length;
//   // },
//   // cellAtIndexPath: (section, row) {
//   // return tableCell(section, row);
//   // },
//   // headerInSection: (section) {
//   // return tableSectionHeader(section);
//   // },
//   // divider: Container(
//   // color: Colors.black38,
//   // height: 0.5,
//   // ),
// }
//
// Widget tableCell(section, row) {
//   BluetoothCharacteristic c = this.services[section].characteristics[row];
//   String uuid = c.uuid.toString();
//   String property = '';
//   if (c.properties.read) {
//     property += 'Read,';
//   }
//   if (c.properties.write) {
//     property += 'Write,';
//   }
//   if (c.properties.writeWithoutResponse) {
//     property += 'WriteWithoutResponse,';
//   }
//   if (c.properties.notify) {
//     property += 'Notify,';
//   }
//   if (c.properties.indicate) {
//     property += 'Indicate';
//   }
//   return Container(
//     color: Colors.white,
//     height: 70,
//     child: Stack(
//       children: <Widget>[
//         Container(),
//         Positioned(
//           left: 15,
//           top: 15,
//           child: Text(uuid,
//               style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xff666666))),
//         ),
//         Positioned(
//           left: 15,
//           top: 40,
//           child: Text('Properties: $property',
//               style: TextStyle(fontSize: 14, color: Color(0xff666666))),
//         ),
//       ],
//     ),
//   );
// }
// // Widget tableHeaderView() {
// //   var deviceId = widget.device.id.id;
// //   return Stack(
// //     children: <Widget>[
// //       Positioned(
// //         left: 15,
// //         top: 15,
// //         child: Text(
// //             widget.device.name,
// //             style: TextStyle(
// //                 fontSize: 19,
// //                 fontWeight: FontWeight.w700,
// //                 color: Color(0xff1a1a1a))),
// //       ),
// //       Positioned(
// //         left: 15,
// //         top: 43,
// //         child: Text('UUID:$deviceId',
// //             style: TextStyle(fontSize: 14, color: Color(0xff1a1a1a))),
// //       ),
// //       const Positioned(
// //         left: 15,
// //         top: 70,
// //         child: Text('Advertisement Data',
// //             style: TextStyle(fontSize: 14, color: Color(0xff1a1a1a))),
// //       ),
// //       Positioned(
// //         left: 15,
// //         top: 93,
// //         child: Text('123',
// //             style: TextStyle(fontSize: 14, color: Color(0xff1a1a1a))),
// //       )
// //     ],
// //   );
// // }
