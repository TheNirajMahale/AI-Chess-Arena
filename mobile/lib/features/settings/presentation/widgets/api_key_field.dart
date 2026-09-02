import 'package:flutter/material.dart';
import '../../../../data/models/models.dart';

/// Password field for AI provider API key with show/hide toggle and live test ping button.
class ApiKeyField extends StatefulWidget {
  final ProviderType provider;
  final String initialValue;
  final String maskedPreview;
  final ValueChanged<String> onChanged;
  final VoidCallback onTest;
  final ({bool isValid, String message})? testResult;

  const ApiKeyField({
    super.key,
    required this.provider,
    required this.initialValue,
    required this.maskedPreview,
    required this.onChanged,
    required this.onTest,
    this.testResult,
  });

  @override
  State<ApiKeyField> createState() => _ApiKeyFieldState();
}

class _ApiKeyFieldState extends State<ApiKeyField> {
  bool _obscureText = true;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue.isNotEmpty ? widget.initialValue : widget.maskedPreview,
    );
  }

  @override
  void didUpdateWidget(covariant ApiKeyField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue ||
        widget.maskedPreview != oldWidget.maskedPreview) {
      if (_controller.text.isEmpty || _controller.text == oldWidget.maskedPreview) {
        _controller.text =
            widget.initialValue.isNotEmpty ? widget.initialValue : widget.maskedPreview;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final res = widget.testResult;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.provider.displayName} API Key',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              OutlinedButton.icon(
                onPressed: widget.onTest,
                icon: const Icon(Icons.speed_rounded, size: 14),
                label: const Text('Test Key', style: TextStyle(fontSize: 11)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          TextFormField(
            controller: _controller,
            obscureText: _obscureText,
            style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
            decoration: InputDecoration(
              hintText: 'Enter API key...',
              isDense: true,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  size: 18,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
            onChanged: widget.onChanged,
          ),

          // Diagnostic Test Feedback Chip
          if (res != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: res.isValid
                    ? const Color(0xFF10B981).withOpacity(0.12)
                    : const Color(0xFFEF4444).withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: res.isValid
                      ? const Color(0xFF10B981).withOpacity(0.4)
                      : const Color(0xFFEF4444).withOpacity(0.4),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    res.isValid ? Icons.check_circle_rounded : Icons.error_rounded,
                    size: 14,
                    color: res.isValid ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      res.message,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: res.isValid ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
