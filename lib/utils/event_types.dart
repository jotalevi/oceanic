import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum EventTypes {
  anuncio,
  prueba,
  tarea,
  proyecto,
  clasesCanceladas,
  clasesEnLinea,
}

class EventType {
  static fromInt(int i) {
    switch (i) {
      case 0:
        return EventTypes.anuncio;
      case 1:
        return EventTypes.prueba;
      case 2:
        return EventTypes.tarea;
      case 3:
        return EventTypes.proyecto;
      case 4:
        return EventTypes.clasesCanceladas;
      case 5:
        return EventTypes.clasesEnLinea;
      default:
        return EventTypes.anuncio;
    }
  }

  static fromStrID(String id) {
    switch (id) {
      case "anuncio":
        return EventTypes.anuncio;
      case "prueba":
        return EventTypes.prueba;
      case "tarea":
        return EventTypes.tarea;
      case "proyecto":
        return EventTypes.proyecto;
      case "clasesCanceladas":
        return EventTypes.clasesCanceladas;
      case "clasesEnLinea":
        return EventTypes.clasesEnLinea;
      default:
        return EventTypes.anuncio;
    }
  }

  static String toStringId(EventTypes e) {
    switch (e) {
      case EventTypes.anuncio:
        return "anuncio";
      case EventTypes.prueba:
        return "prueba";
      case EventTypes.tarea:
        return "tarea";
      case EventTypes.proyecto:
        return "proyecto";
      case EventTypes.clasesCanceladas:
        return "clasesCanceladas";
      case EventTypes.clasesEnLinea:
        return "clasesEnLinea";
      default:
        return "anuncio";
    }
  }

  static Color color(EventTypes e) {
    switch (e) {
      case EventTypes.anuncio:
        return Colors.blue;
      case EventTypes.prueba:
        return Colors.yellow;
      case EventTypes.tarea:
        return Colors.green;
      case EventTypes.proyecto:
        return Colors.yellow;
      case EventTypes.clasesCanceladas:
        return Colors.red;
      case EventTypes.clasesEnLinea:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  static String prettyStr(EventTypes e) {
    switch (e) {
      case EventTypes.anuncio:
        return "Anuncio";
      case EventTypes.prueba:
        return "Prueba";
      case EventTypes.tarea:
        return "Tarea";
      case EventTypes.proyecto:
        return "Proyecto";
      case EventTypes.clasesCanceladas:
        return "Clases Canceladas";
      case EventTypes.clasesEnLinea:
        return "Clases en Línea";
      default:
        return "Anuncio";
    }
  }

  static IconData icon(EventTypes e) {
    switch (e) {
      case EventTypes.anuncio:
        return CupertinoIcons.bookmark;

      case EventTypes.prueba:
        return CupertinoIcons.doc;

      case EventTypes.tarea:
        return CupertinoIcons.doc_richtext;

      case EventTypes.proyecto:
        return CupertinoIcons.archivebox;

      case EventTypes.clasesCanceladas:
        return CupertinoIcons.nosign;

      case EventTypes.clasesEnLinea:
        return CupertinoIcons.videocam;
      default:
        return CupertinoIcons.radiowaves_right;
    }
  }
}
