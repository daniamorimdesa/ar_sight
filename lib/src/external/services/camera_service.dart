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
    void Function(int count)? onFrameCaptured, // Callback para notificar quando um frame é capturado
  }) async {
    // Verifica se a câmera está inicializada
    final frames = <Uint8List>[];
    final startTime = DateTime.now();

    // Loop baseado no número de frames
    for (int i = 0; i < maxFrames; i++) {
      // Calcula quando este frame deveria ser capturado
      final targetTime = startTime.add(interval * i);
      final now = DateTime.now();
      
      // Se passou do tempo de duração, para
      if (now.difference(startTime) >= duration) {
        break;
      }
      
      // Se ainda não chegou na hora deste frame, aguarda
      if (now.isBefore(targetTime)) {
        await Future.delayed(targetTime.difference(now));
      }
      
      // Verifica se a câmera está inicializada
      if (!controller.value.isInitialized) {
        throw Exception('Camera not initialized');
      }
      
      // Verifica se a câmera está ocupada tirando uma foto
      if (controller.value.isTakingPicture) {
        await Future.delayed(const Duration(milliseconds: 50));
        i--; // Tenta novamente
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

        // aqui atualiza progresso
        onFrameCaptured?.call(frames.length);

        debugPrint('Captured frame ${frames.length}/$maxFrames');
        
      } catch (e) {
        debugPrint('Frame capture error: $e');
        break; // Sai do loop em caso de erro para evitar capturas repetidas
      }
    }

    debugPrint('✅ Finished capturing frames: ${frames.length} frames captured');

    return frames;
  }
}
