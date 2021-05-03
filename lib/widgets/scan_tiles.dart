import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr/providers/scan_list_provider.dart';
import 'package:qr/utils/utils.dart';

class ScanTiles extends StatelessWidget {
  final String tipo;
  const ScanTiles({Key key, this.tipo});
  @override
  Widget build(BuildContext context) {
    //Aqui si quiero que se redibuje, entonces aqui listen es true (default)
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.scans;
    return ListView.builder(
      itemBuilder: (_, i) {
        return Dismissible(
          //Le indica que elemento tiene que borrarse
          key: UniqueKey(),
          background: Container(color: Colors.red),
          onDismissed: (DismissDirection direction) {
            //No queremos redibujar, no estamos dentro del arbol de widgets
            Provider.of<ScanListProvider>(context, listen: false)
                .borrarScanPorId(scans[i].id);
          },
          child: ListTile(
            leading: Icon(
              //icono segun el tipo de pagina
              this.tipo == 'http' ? Icons.home_outlined : Icons.map,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(scans[i].valor),
            subtitle: Text(scans[i].id.toString()),
            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey),
            onTap: () => {launchURL(scans[i], context)},
          ),
        );
      },
      itemCount: scans.length,
    );
  }
}
