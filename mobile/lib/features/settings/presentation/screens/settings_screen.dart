import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../../../../data/models/models.dart';
import '../../../shared_widgets/theme_picker_sheet.dart';
import '../../application/settings_provider.dart';
import '../widgets/api_key_field.dart';

/// Application settings screen for managing API keys, backend host URL, and token economy.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _baseUrlController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final currentBaseUrl = ref.read(appSettingsProvider).baseUrl;
    _baseUrlController = TextEditingController(text: currentBaseUrl);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _baseUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = ref.watch(settingsNotifierProvider);
    final settingsNotifier = ref.read(settingsNotifierProvider.notifier);
    final appSettingsNotifier = ref.read(appSettingsProvider.notifier);
    final theme = Theme.of(context);

    final keys = settingsState.settings.keys;
    final masked = settingsState.maskedKeys;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Themes',
            onPressed: () => ThemePickerSheet.show(context),
          ),
          IconButton(
            icon: const Icon(Icons.save_rounded),
            tooltip: 'Save Settings',
            onPressed: () => settingsNotifier.saveSettings(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reload',
            onPressed: () => settingsNotifier.loadSettings(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          tabs: const [
            Tab(text: 'API Keys & Server'),
            Tab(text: 'Token Economy'),
          ],
        ),
      ),
      body: settingsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Status / Confirmation Banner
                if (settingsState.statusMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    color: theme.colorScheme.primary.withOpacity(0.15),
                    child: Text(
                      settingsState.statusMessage!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // -------------------------------------------------------------
                      // Tab 1: API Keys & Connection Host
                      // -------------------------------------------------------------
                      ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // 1. Backend Host URL
                          Container(
                            padding: const EdgeInsets.all(14),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'FastAPI Server URL',
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _baseUrlController,
                                        style: const TextStyle(fontSize: 13),
                                        decoration: const InputDecoration(
                                          hintText: 'http://127.0.0.1:8000',
                                          isDense: true,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        final newUrl = _baseUrlController.text.trim();
                                        if (newUrl.isNotEmpty) {
                                          appSettingsNotifier.setBaseUrl(newUrl);
                                          settingsNotifier.loadSettings();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Updated backend URL to $newUrl')),
                                          );
                                        }
                                      },
                                      child: const Text('Save URL'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // 2. Sync All Configured Models Action
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: OutlinedButton.icon(
                              onPressed: settingsState.isSyncing
                                  ? null
                                  : () => settingsNotifier.syncAllModels(),
                              icon: settingsState.isSyncing
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.sync_rounded),
                              label: const Text('Sync All Configured Providers'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),

                          // 3. API Key Fields (6 Providers)
                          ApiKeyField(
                            provider: ProviderType.deepseek,
                            initialValue: keys.deepseekKey,
                            maskedPreview: masked.deepseekKey,
                            testResult: settingsState.keyTestResults[ProviderType.deepseek],
                            onChanged: (k) => settingsNotifier.updateKeys(keys.copyWith(deepseekKey: k)),
                            onTest: () => settingsNotifier.testKey(ProviderType.deepseek, keys.deepseekKey),
                          ),
                          ApiKeyField(
                            provider: ProviderType.openai,
                            initialValue: keys.openaiKey,
                            maskedPreview: masked.openaiKey,
                            testResult: settingsState.keyTestResults[ProviderType.openai],
                            onChanged: (k) => settingsNotifier.updateKeys(keys.copyWith(openaiKey: k)),
                            onTest: () => settingsNotifier.testKey(ProviderType.openai, keys.openaiKey),
                          ),
                          ApiKeyField(
                            provider: ProviderType.gemini,
                            initialValue: keys.geminiKey,
                            maskedPreview: masked.geminiKey,
                            testResult: settingsState.keyTestResults[ProviderType.gemini],
                            onChanged: (k) => settingsNotifier.updateKeys(keys.copyWith(geminiKey: k)),
                            onTest: () => settingsNotifier.testKey(ProviderType.gemini, keys.geminiKey),
                          ),
                          ApiKeyField(
                            provider: ProviderType.anthropic,
                            initialValue: keys.anthropicKey,
                            maskedPreview: masked.anthropicKey,
                            testResult: settingsState.keyTestResults[ProviderType.anthropic],
                            onChanged: (k) => settingsNotifier.updateKeys(keys.copyWith(anthropicKey: k)),
                            onTest: () => settingsNotifier.testKey(ProviderType.anthropic, keys.anthropicKey),
                          ),
                          ApiKeyField(
                            provider: ProviderType.groq,
                            initialValue: keys.groqKey,
                            maskedPreview: masked.groqKey,
                            testResult: settingsState.keyTestResults[ProviderType.groq],
                            onChanged: (k) => settingsNotifier.updateKeys(keys.copyWith(groqKey: k)),
                            onTest: () => settingsNotifier.testKey(ProviderType.groq, keys.groqKey),
                          ),
                          ApiKeyField(
                            provider: ProviderType.openrouter,
                            initialValue: keys.openrouterKey,
                            maskedPreview: masked.openrouterKey,
                            testResult: settingsState.keyTestResults[ProviderType.openrouter],
                            onChanged: (k) => settingsNotifier.updateKeys(keys.copyWith(openrouterKey: k)),
                            onTest: () => settingsNotifier.testKey(ProviderType.openrouter, keys.openrouterKey),
                          ),
                          const SizedBox(height: 12),

                          // Save Keys Button
                          ElevatedButton.icon(
                            onPressed: settingsState.isSaving
                                ? null
                                : () => settingsNotifier.saveSettings(),
                            icon: const Icon(Icons.save_rounded),
                            label: Text(settingsState.isSaving ? 'Saving...' : 'Save API Settings'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),

                      // -------------------------------------------------------------
                      // Tab 2: Token Economy & Prompt Tuning
                      // -------------------------------------------------------------
                      ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // 1. ASCII Board Toggle
                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent),
                            ),
                            child: SwitchListTile(
                              title: const Text(
                                'Include ASCII Board Diagram',
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                              ),
                              subtitle: const Text(
                                'Sends visual 8x8 ASCII board diagram in prompt to assist spatial reasoning.',
                                style: TextStyle(fontSize: 11),
                              ),
                              value: settingsState.settings.includeAsciiBoard,
                              onChanged: (val) => settingsNotifier.updateIncludeAscii(val),
                            ),
                          ),

                          // 2. History Context Limit
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: theme.dividerTheme.color ?? Colors.transparent),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Move History Context Limit',
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Limits move history sent to the LLM to save input token consumption.',
                                  style: TextStyle(fontSize: 11),
                                ),
                                const SizedBox(height: 10),
                                DropdownButtonFormField<int>(
                                  value: settingsState.settings.historyContextLimit,
                                  decoration: const InputDecoration(isDense: true),
                                  items: const [
                                    DropdownMenuItem(value: 0, child: Text('Full Match History (Default)')),
                                    DropdownMenuItem(value: 6, child: Text('Last 6 Moves')),
                                    DropdownMenuItem(value: 10, child: Text('Last 10 Moves')),
                                    DropdownMenuItem(value: 15, child: Text('Last 15 Moves')),
                                    DropdownMenuItem(value: 20, child: Text('Last 20 Moves')),
                                  ],
                                  onChanged: (limit) {
                                    if (limit != null) {
                                      settingsNotifier.updateContextLimit(limit);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),

                          // 3. Max Output Generation Tokens
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 16),
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
                                    const Text(
                                      'Max Output Generation Tokens',
                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                                    ),
                                    Text(
                                      '${settingsState.settings.maxOutputTokens} tokens',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Maximum generation token cap per move reasoning turn.',
                                  style: TextStyle(fontSize: 11),
                                ),
                                Slider(
                                  value: settingsState.settings.maxOutputTokens.toDouble(),
                                  min: 100,
                                  max: 2000,
                                  divisions: 19,
                                  onChanged: (val) {
                                    settingsNotifier.updateMaxOutputTokens(val.round());
                                  },
                                ),
                              ],
                            ),
                          ),

                          // Save Settings Action
                          ElevatedButton.icon(
                            onPressed: settingsState.isSaving
                                ? null
                                : () => settingsNotifier.saveSettings(),
                            icon: const Icon(Icons.save_rounded),
                            label: Text(settingsState.isSaving ? 'Saving...' : 'Save Token Settings'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
