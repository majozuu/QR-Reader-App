import 'package:flutter/cupertino.dart';
import 'package:qr/models/scan_model.dart';
import 'package:qr/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String tipoSeleccionado = 'http';
  //Usa el valor desde el QR Reader
  Future<ScanModel> nuevoScan(String valor) async {
    //Generacion de un objeto ScanModel
    final nuevoScan = new ScanModel(valor: valor);
    //ID del registro en tabla del nuevo Scan
    final id = await DBProvider.db.nuevoScan(nuevoScan);
    //Asignar el ID de la base de datos al modelo
    nuevoScan.id = id;
    //Sólo se muestra en la IU si es del tipo seleccionado (http)
    if (this.tipoSeleccionado == nuevoScan.tipo) {
      this.scans.add(nuevoScan);
      //Notifica para actualizar la IU
      notifyListeners();
    }
    return nuevoScan;
  }

  //Cargar Scans
  cargarScans() async {
    //Obtiene todos los scans de la base de datos
    final scans = await DBProvider.db.getAllScans();
    //Reemplazo del listado
    this.scans = [...scans];
    notifyListeners();
  }

  //Cargar Scans por tipo
  cargarScansPorTipo(String tipo) async {
    final scans = await DBProvider.db.getScansByType(tipo);
    //Reemplazo del listado
    this.scans = [...scans];
    //Actualizacion del tipo
    this.tipoSeleccionado = tipo;
    notifyListeners();
  }

  borrarTodos() async {
    //Borrar de la base de datos
    await DBProvider.db.deleteAllScans();
    //Actualizar scans
    this.scans = [];
    notifyListeners();
  }

  borrarScanPorId(int id) async {
    //Borrar de la base de datos
    await DBProvider.db.deleteScan(id);
    //Actualizar scans
    this.cargarScansPorTipo(this.tipoSeleccionado);
    //Dentro del metodo ya hace notify
  }
}
