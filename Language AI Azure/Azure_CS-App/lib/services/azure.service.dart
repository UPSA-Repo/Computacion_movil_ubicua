import 'dart:convert';
import 'package:azurecs_app/models/new_message.dart';

import '../models/message.dart';
import 'package:http/http.dart' as http;

class AzureApi {
  static const String _baseUrl = 'https://azurecsapiservice.azurewebsites.net/';

  static Future<List<Message>> getMessages() async {
    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<Message> messages = [];
      jsonResponse.forEach((element) {
        messages.add(Message.fromJson(element));
      });
      return messages;
    }
    throw Exception('Failed to load messages');
  }

  static Future<List<Message>> getMessagesByDataset(int idDataset) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$idDataset/dataset'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      List<Message> messages = [];
      jsonResponse.forEach((element) {
        messages.add(Message.fromJson(element));
      });
      return messages;
    }
    throw Exception('Failed to load messages');
  }

  static Future<Message> getMessageById(String id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return Message.fromJson(jsonResponse);
    }
    throw Exception('Failed to load message');
  }

  static Future<Message> postMessage(NewMessage newMessage) async {
    Map data = {
      "messageContent": newMessage.message,
      "idDataset": newMessage.id,
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/single'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return Message.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to post message');
    }
  }

  static Future<List<Message>> postMessages(List<NewMessage> messages) async {
    List<Map> data = [];
    for (var element in messages) {
      data.add({
        "messageContent": element.message,
        "idDataset": element.id,
      });
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/multiple'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      var jsonResponse = jsonDecode(response.body);
      List<Message> messages = [];
      jsonResponse.forEach((element) {
        messages.add(Message.fromJson(element));
      });
      return messages;
    } else {
      throw Exception('Failed to post message');
    }
  }

  static Future<void> putMessage(NewMessage message) async {
    Map data = {
      "newMessage": message.message,
      "idDataset": message.id,
    };

    final response = await http.put(
      Uri.parse('$_baseUrl/${message.idMessage}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 204) {
      throw UnsupportedError('Failed to put message');
    }
  }

  static Future<void> deleteMessageById(String id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw UnsupportedError('Failed to delete message');
    }
  }

  static Future<void> deleteAllMessages() async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/delete/all'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw UnsupportedError('Failed to delete messages');
    }
  }

  static Future<void> deleteByDataset(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$id/delete'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw UnsupportedError('Failed to delete messages');
    }
  }
}

/*
Ideal para diseño y desarrollo

- Pantalla táctil IPS de 13 pulgadas con resolución 1920x1200
- Refresco de pantalla 60Hz/120Hz
- Intel Evo i7 11°Gen 4.8Ghz
- Gráficos Intel Iris Xe 8Gb
- Ram de 16Gb DDR4
- 512Gb SSD
- Teclado retroiluminado con tres niveles
- 3 modos de velocidad para el ventilador
- Otros: USB-C 4.0 x2, USB-A 3.2, USB-C 3.2, seguro de cámara web, puerto Jack para audífonos, lector de tarjetas SD, lápiz táctil incluido
Etiquetas
Santa Cruz de la Sierra
La ubicación es aproximada
Información del vendedor
Enrique Núñez
*/