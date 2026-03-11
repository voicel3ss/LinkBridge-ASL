import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

class GestureClassifier {
  late Interpreter _interpreter;
  late List<String> _labels;
  late List<int> _inputShape;
  late List<int> _outputShape;
  var _isLoaded = false;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('assets/model.tflite');
    _inputShape = _interpreter.getInputTensor(0).shape;
    _outputShape = _interpreter.getOutputTensor(0).shape;

    final labelsData = await rootBundle.loadString('assets/label.txt');
    _labels = labelsData
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    _isLoaded = true;
    print('[ASL] Model loaded. Input shape: $_inputShape, Output shape: $_outputShape, Labels count: ${_labels.length}');
  }

  Future<String> predict(CameraImage image) async {
    if (!_isLoaded) {
      return 'Loading model...';
    }

    try {
      final normalized = _preprocess(image, 224, 224);
      final input = _buildInputTensor(normalized, 224, 224);
      final output = _buildOutputTensor(_outputShape);

      _interpreter.run(input, output);

      final scores = <double>[];
      _flattenToDoubles(output, scores);
      if (scores.isEmpty) {
        return '';
      }

      var maxIndex = 0;
      var maxScore = -1.0;
      final limit = scores.length < _labels.length ? scores.length : _labels.length;

      for (int i = 0; i < limit; i++) {
        if (scores[i] > maxScore) {
          maxScore = scores[i];
          maxIndex = i;
        }
      }

      final label = _labels[maxIndex];
      final result = label.contains(' ') ? label.split(' ').last : label;
      print('[ASL] Confidence: $maxScore (index: $maxIndex, label: $result), top 5: ${scores.take(5).toList()}');
      return result;
    } catch (e) {
      return '';
    }
  }

  dynamic _buildInputTensor(Float32List normalized, int width, int height) {
    if (_inputShape.length == 4) {
      return [
        List.generate(
          height,
          (y) => List.generate(
            width,
            (x) {
              final idx = (y * width + x) * 3;
              return [normalized[idx], normalized[idx + 1], normalized[idx + 2]];
            },
          ),
        ),
      ];
    }

    if (_inputShape.length == 2) {
      return [normalized.toList()];
    }

    throw StateError('Unsupported model input shape: $_inputShape');
  }

  dynamic _buildOutputTensor(List<int> shape) {
    if (shape.isEmpty) {
      return 0.0;
    }
    if (shape.length == 1) {
      return List.filled(shape[0], 0.0);
    }
    return List.generate(shape[0], (_) => _buildOutputTensor(shape.sublist(1)));
  }

  void _flattenToDoubles(dynamic value, List<double> out) {
    if (value is num) {
      out.add(value.toDouble());
      return;
    }
    if (value is List) {
      for (final item in value) {
        _flattenToDoubles(item, out);
      }
    }
  }

  Float32List _preprocess(CameraImage image, int targetWidth, int targetHeight) {
    final rgb = _yuv420ToRgb(image);
    return _resizeAndNormalize(
      rgb,
      image.width,
      image.height,
      targetWidth,
      targetHeight,
    );
  }

  Uint8List _yuv420ToRgb(CameraImage image) {
    final width = image.width;
    final height = image.height;

    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];

    final yBytes = yPlane.bytes;
    final uBytes = uPlane.bytes;
    final vBytes = vPlane.bytes;

    final uvRowStride = uPlane.bytesPerRow;
    final uvPixelStride = uPlane.bytesPerPixel ?? 1;

    final out = Uint8List(width * height * 3);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final yIndex = y * yPlane.bytesPerRow + x;
        final uvIndex = (y ~/ 2) * uvRowStride + (x ~/ 2) * uvPixelStride;

        final yValue = yBytes[yIndex].toDouble();
        final uValue = uBytes[uvIndex].toDouble() - 128.0;
        final vValue = vBytes[uvIndex].toDouble() - 128.0;

        final r = (yValue + 1.402 * vValue).round().clamp(0, 255);
        final g = (yValue - 0.344136 * uValue - 0.714136 * vValue)
            .round()
            .clamp(0, 255);
        final b = (yValue + 1.772 * uValue).round().clamp(0, 255);

        final outIndex = (y * width + x) * 3;
        out[outIndex] = r;
        out[outIndex + 1] = g;
        out[outIndex + 2] = b;
      }
    }

    return out;
  }

  Float32List _resizeAndNormalize(
    Uint8List rgb,
    int srcWidth,
    int srcHeight,
    int dstWidth,
    int dstHeight,
  ) {
    final out = Float32List(dstWidth * dstHeight * 3);

    for (int y = 0; y < dstHeight; y++) {
      final srcY = ((y * srcHeight) / dstHeight).floor();
      for (int x = 0; x < dstWidth; x++) {
        final srcX = ((x * srcWidth) / dstWidth).floor();
        final srcIndex = (srcY * srcWidth + srcX) * 3;
        final dstIndex = (y * dstWidth + x) * 3;

        out[dstIndex] = rgb[srcIndex] / 255.0;
        out[dstIndex + 1] = rgb[srcIndex + 1] / 255.0;
        out[dstIndex + 2] = rgb[srcIndex + 2] / 255.0;
      }
    }

    return out;
  }
}