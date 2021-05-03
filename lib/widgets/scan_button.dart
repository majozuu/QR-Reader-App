import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr/providers/scan_list_provider.dart';
import 'package:qr/utils/utils.dart';

class ScanButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      onPressed: () async {
        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#3D8BEF', 'Cancelar', false, ScanMode.QR);
        if (barcodeScanRes == '-1') {
          //El usuario ha cancelado la accion
          return;
        }
        //Le indico que busque en el arbol de widgets este tipo de provider
        final scanListProvider =
            Provider.of<ScanListProvider>(context, listen: false);
        //Imprimir scan
        print(barcodeScanRes);
        //Guardar nuevo scan
        final nuevoScan = await scanListProvider.nuevoScan(barcodeScanRes);
        launchURL(nuevoScan, context);
      },
      child: Icon(Icons.filter_center_focus),
    );
  }
}
