import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr/models/scan_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  Completer<GoogleMapController> _controller = Completer();
  MapType mapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    //Leer argumentos desde la navegacion
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    //Posicion inicial de la camara
    final CameraPosition puntoInicial = CameraPosition(
      //Latitud y longitud
      target: scan.getLatLng(),
      zoom: 14.4746,
      tilt: 50,
    );
    //Marcadores
    Set<Marker> markers = new Set<Marker>();
    markers.add(
        Marker(markerId: MarkerId('geo-location'), position: scan.getLatLng()));
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        actions: [
          IconButton(
            icon: Icon(Icons.location_disabled),
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: scan.getLatLng(), zoom: 14.5, tilt: 50)));
            },
          )
        ],
      ),
      body:
          //Widget de GoogleMap
          GoogleMap(
        mapType: mapType,
        markers: markers,
        initialCameraPosition: puntoInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      //Boton para cambiar el tipo de mapa
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.layers),
        onPressed: () {
          if (mapType == MapType.normal) {
            mapType = MapType.satellite;
          } else {
            mapType = MapType.normal;
          }
          //Redibujar el widget
          setState(() {});
        },
      ),
    );
  }
}
