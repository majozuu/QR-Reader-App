//Proveedor de informacion
//Singleton
//No importa donde lo instancie, siempre va a ser la misma instancia de la base de datos
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:qr/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  //Instancia de la base de datos
  static Database _database;
  //Instancia de la clase personalizada
  //Construtor privado
  static final DBProvider db = DBProvider._();
  DBProvider._();
  Future<Database> get database async {
    //Si ya se ha instanciado antes, se regresa la misma
    if (_database != null) return _database;
    //Si es la primera vez
    //Lectura de la base de datos no es sincrona (debo esperar a la respuesta)
    _database = await initDB();
    return _database;
  }

  //Creacion de base de datos en el dispositivo
  Future<Database> initDB() async {
    //Path de donde almacenaremos la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    //Construccion del path
    //Nombre de la base de datos con la extension necesaria
    final path = join(documentsDirectory.path, 'ScansDB.db');
    //Creacion de la base de datos
    //Se cambia la version cuando se hacen cambios en las tablas
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      //Aqui mismo se pueden ejecutar mas comandos
      await db.execute('''
          CREATE TABLE Scans(
            id INTEGER PRIMARY KEY,
            tipo TEXT,
            valor TEXT
            
          )
          ''');
    });
  }

  //Insercion en la base de datos usando rawInsert
  nuevoScanRaw(ScanModel nuevoScan) async {
    //Obtener informacion del scan
    final id = nuevoScan.id;
    final tipo = nuevoScan.tipo;
    final valor = nuevoScan.valor;

    //Puede o no que la base de datos este lista
    //Uso del getter
    final db = await database;
    //Insercion en la tabla
    final res = await db.rawInsert('''
      INSERT INTO Scans(id,tipo,valor)
        VALUES($id,$tipo,$valor)
    ''');
    return res;
  }

  //Insercion en la base de datos usando solo insert (más sencillo)
  Future<int> nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.insert('Scans', nuevoScan.toJson());
    //ID del ultimo registro insertado
    return res;
  }

  //Obtener registros (SELECT)
  Future<ScanModel> getScanByID(int id) async {
    final db = await database;
    //Obtiene algunos de los registros (con condiciones segun WHERE)
    final res = await db.query('Scans', where: 'id=?', whereArgs: [id]);
    //Regresa una lista de mapa (puede retornar mas de un elemento)
    return res.isNotEmpty
        //Propiedad para obtener la primera respuesta
        ? ScanModel.fromJson(res.first)
        //Si esta vacio no retorno nada
        : null;
  }

  //Obtener todos los registros
  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    //Obtiene todos los registros
    final res = await db.query('Scans');
    //Regresa una lista de mapa (puede retornar mas de un elemento)
    return res.isNotEmpty
        //Propiedad para obtener la primera respuesta
        ? res.map((scan) => ScanModel.fromJson(scan)).toList()
        //Si esta vacio no retorno nada
        : [];
  }

  //Obtener los registros por tipo
  Future<List<ScanModel>> getScansByType(String tipo) async {
    final db = await database;
    //Obtiene algunos de los registros (con condiciones segun WHERE)
    final res = await db.rawQuery('''
      SELECT * FROM Scans WHERE tipo = '$tipo'
    ''');
    //Regresa una lista de mapa (puede retornar mas de un elemento)
    return res.isNotEmpty
        //Propiedad para obtener la primera respuesta
        ? res.map((scan) => ScanModel.fromJson(scan)).toList()
        //Si esta vacio no retorno nada
        : [];
  }

  //Actualizar scan
  Future<int> updateScan(ScanModel scan) async {
    final db = await database;
    //La tabla y los registros que quiero actualizar como argumentos
    //Puede o no tener WHERE (Actualizar todo o con condiciones)
    final res = await db
        .update('Scans', scan.toJson(), where: 'id=?', whereArgs: [scan.id]);
    return res;
  }

  //Borrar registros segun ID
  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id=?', whereArgs: [id]);
    return res;
  }

  //Borrar todos los registros
  Future<int> deleteAllScans() async {
    final db = await database;
    final res = await db.delete('Scans');
    return res;
  }
}
