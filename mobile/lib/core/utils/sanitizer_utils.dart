import 'package:dio/dio.dart';

/// Utility for cleaning and sanitizing live LLM thought tokens and error messages.
class SanitizerUtils {
  SanitizerUtils._();

  static final RegExp _tagPattern = RegExp(
    r'<\/?(think|thought|reasoning|move|fen|board)>',
    caseSensitive: false,
  );

  static final RegExp _fenDumpPattern = RegExp(
    r'(FEN:\s*)?[rnbqkpRNBQKP1-8]{1,8}\/([rnbqkpRNBQKP1-8]{1,8}\/){6}[rnbqkpRNBQKP1-8]{1,8}\s+[wb]\s+([KQkq-]+)\s+([a-h1-8-]+)\s+\d+\s+\d+',
  );

  /// Strips reasoning tags and redundant FEN board dumps from live LLM stream.
  static String sanitizeThoughtText(String text) {
    if (text.isEmpty) return text;
    var cleaned = text.replaceAll(_tagPattern, '');
    cleaned = cleaned.replaceAll(_fenDumpPattern, '');
    return cleaned.trimLeft();
  }

  /// Formats raw API/network errors into concise user-friendly display messages.
  static String formatErrorMessage(dynamic rawError) {
    if (rawError == null) return 'An unexpected error occurred.';

    // Extract detail from DioException response payload
    if (rawError is DioException) {
      final responseData = rawError.response?.data;
      if (responseData is Map && responseData['detail'] != null) {
        return responseData['detail'].toString();
      }
      if (responseData is String && responseData.isNotEmpty) {
        final detailMatch = RegExp(r'"detail":\s*"([^"]+)"').firstMatch(responseData);
        if (detailMatch != null && detailMatch.group(1) != null) {
          return detailMatch.group(1)!;
        }
      }

      if (rawError.type == DioExceptionType.connectionTimeout ||
          rawError.type == DioExceptionType.receiveTimeout) {
        return 'Connection timed out. Check backend server responsiveness.';
      }
      if (rawError.type == DioExceptionType.connectionError) {
        return 'Cannot connect to backend server. Make sure FastAPI is running on port 8000.';
      }
    }

    final str = rawError.toString();
    if (str.isEmpty) return 'An unexpected error occurred.';

    // Extract detail from backend JSON string if present
    final detailMatch = RegExp(r'"detail":\s*"([^"]+)"').firstMatch(str);
    if (detailMatch != null && detailMatch.group(1) != null) {
      return detailMatch.group(1)!;
    }

    final lower = str.toLowerCase();
    if (lower.contains('socketexception') ||
        lower.contains('connection refused') ||
        lower.contains('failed host lookup') ||
        lower.contains('connection closed before full header')) {
      return 'Cannot connect to backend server. Make sure FastAPI is running on port 8000.';
    }
    if (lower.contains('connecttimeout') || lower.contains('receivetimeout')) {
      return 'Connection timed out. Check backend server responsiveness.';
    }
    if (str.contains('401') || lower.contains('unauthorized')) {
      return 'Authentication failed: Invalid API key.';
    }
    if (str.contains('429') || lower.contains('quota') || lower.contains('rate limit')) {
      return 'API Quota exceeded or Rate Limit reached.';
    }
    if (str.contains('500') || lower.contains('internal server error')) {
      return 'Server error encountered during processing.';
    }

    return str;
  }
}
