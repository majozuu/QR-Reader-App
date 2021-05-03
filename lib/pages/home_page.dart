import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr/providers/scan_list_provider.dart';
import 'package:qr/providers/ui_provider.dart';
import 'package:qr/widgets/custom_navigatorbar.dart';
import 'package:qr/widgets/scan_button.dart';

import 'direcciones_page.dart';
import 'mapas_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Historial'),
        actions: [
          IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                //Provider dentro de un metodo (no en build directamente)->listen:false
                Provider.of<ScanListProvider>(context).borrarTodos();
              })
        ],
      ),
      body: _HomePageBody(),
      //Cambio condicional del body
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Obtener el selected menu opt
    //Acceso a todas las propiedades y metodos de uiprovider
    final uiProvider = Provider.of<UiProvider>(context);
    //Uso de ScanListProvider
    //No se redibuja aqui
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);
    //Cambiar para mostrar la pagina deseada
    //Carga los scans segun el tipo (definido en el modelo)
    final currentIndex = uiProvider.selectedMenuOpt;
    switch (currentIndex) {
      case 0:
        scanListProvider.cargarScansPorTipo('geo');
        return MapasPage();
      case 1:
        scanListProvider.cargarScansPorTipo('http');
        return DireccionesPage();
      default:
        return MapasPage();
    }
  }
}
