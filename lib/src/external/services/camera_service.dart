// camera_service.dart: Serviço para captura de frames da câmera -> devolve uma lista de bytes de imagem
import 'dart:async'; // Para controle de tempo
import 'dart:typed_data'; // Para manipulação de bytes de imagem
import 'package:camera/camera.dart';
import 'package:flutter/material.dart'; // Para controle da câmera

class CameraService {
  final CameraController controller; // Controlador da câmera

  CameraService(this.controller);

  // Método para capturar frames por um período de tempo com intervalos definidos
  Future<List<Uint8List>> captureFor({
    required Duration duration, // Duração total da captura
    required Duration interval, // Intervalo entre cada captura
    int maxFrames = 10, // Número máximo de frames a serem capturados
  }) async {
    // Verifica se a câmera está inicializada
    final frames = <Uint8List>[];

    // Define o tempo de término da captura
    final endAt = DateTime.now().add(duration);

    // Loop de captura de frames
    while (DateTime.now().isBefore(endAt) && frames.length < maxFrames) {
      // Evita chamar takePicture simultâneo
      if (!controller.value.isInitialized) {
        throw Exception('Camera not initialized');
      }
      // Verifica se a câmera está ocupada tirando uma foto
      if (controller.value.isTakingPicture) {
        // Aguarda um curto período antes de tentar novamente
        await Future.delayed(const Duration(milliseconds: 50));
        continue;
      }
      // Captura um frame
      try {
        // Captura a imagem e obtém o arquivo temporário
        final file = await controller.takePicture();

        // Lê os bytes da imagem capturada
        final bytes = await file.readAsBytes();

        // Adiciona os bytes do frame à lista de frames capturados
        frames.add(bytes);

        debugPrint('Captured frame ${frames.length}/$maxFrames');

      } catch (e) {
        debugPrint('Frame capture error: $e');
        break; // Sai do loop em caso de erro para evitar capturas repetidas
      }
      // Aguarda o intervalo definido antes de capturar o próximo frame
      await Future.delayed(interval);
    }

    debugPrint('✅ Finished capturing frames: ${frames.length} frames captured');

    return frames;
  }
}
