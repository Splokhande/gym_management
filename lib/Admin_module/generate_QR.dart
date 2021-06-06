//
// import 'package:barcode_widget/barcode_widget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter/material.dart';
// import 'package:paldes/User_module/riverpod/home.dart';
// import 'package:paldes/Widgets/text.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// class GenerateQR extends HookWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     var getBranch = useProvider(attendanceProvider);
//
//     return Scaffold(
//       body:
//       Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox (
//             height: 0.05.sh,
//           ),
//           if(getBranch.selectedBranch.branchName != null)
//           BarcodeWidget(
//             barcode: Barcode.qrCode(),
//             data:"${getBranch.selectedBranch.branchName}%${getBranch.selectedBranch.branchId}",
//
//           ),
//           SizedBox (
//             height: 0.05.sh,
//           ),
//           if(getBranch.branchList.length >0)
//             ListView.separated(
//                 shrinkWrap: true,
//                 scrollDirection: Axis.vertical,
//                 itemBuilder: (_,i){
//
//               return CheckboxListTile(value:getBranch.selectedBranch.branchId ==getBranch.branchList[i].branchId  ,
//                   title: PText(
//                     text: getBranch.branchList[i].branchName,
//                     isMd: true,
//                     isWhite: false,
//                   ),
//                   onChanged: (value){
//                     getBranch.onBranchSelected(i);
//                   });
//
//             }, separatorBuilder: (_,i){
//               return SizedBox(height: 0.02.sh,);
//             }, itemCount:getBranch.branchList.length )
//         ],
//       ),
//     );
//   }
// }
