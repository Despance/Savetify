// import 'package:flutter/material.dart';
// import 'package:savetify/src/features/investment/view_model/InvestmentViewModel.dart';

// class InvestmentPortfolio extends StatelessWidget {

//   final InvestmentViewModel viewModel = InvestmentViewModel();  

//   @override
//   Widget build(BuildContext context) {
//         return Column(
//           children: [
//             ListTile(
//               title: const Text('Total Investments'),
//               trailing: IconButton(
//                 icon: Icon(viewModel.obscureTotalValue
//                     ? Icons.visibility_off
//                     : Icons.visibility),
//                 onPressed: () {
//                   viewModel.toggleTotalValueVisibility();
//                 },
//               ),
//               subtitle: Text(
//                 viewModel.obscureTotalValue
//                     ? '***'
//                     : '\$${viewModel.getTotalInvestmentModelsValue().toStringAsFixed(2)}',
//               ),
//             ),
//             const Divider(),
//           ],
//         );
//   }
// }
