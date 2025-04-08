import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A dropdown that loads/saves its value to SharedPreferences,
/// and guards against missing/duplicate options.
class PreferenceDropdown extends StatefulWidget {
  /// The SharedPreferences key to read/write.
  final String prefsKey;

  /// The list of allowed values. Must be unique.
  final List<String> options;

  /// An optional label for the dropdown.
  final String? label;

  const PreferenceDropdown({
    Key? key,
    required this.prefsKey,
    required this.options,
    this.label,
  }) : super(key: key);

  @override
  _PreferenceDropdownState createState() =>
      _PreferenceDropdownState();
}

class _PreferenceDropdownState
    extends State<PreferenceDropdown> {
  late SharedPreferences _prefs;
  String? _currentValue;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAndValidatePreference();
  }

  Future<void> _loadAndValidatePreference() async {
    _prefs = await SharedPreferences.getInstance();

    final stored = _prefs.getString(widget.prefsKey);
    String initial;

    if (stored != null && widget.options.contains(stored)) {
      // stored value is valid
      initial = stored;
    } else {
      // stored is null or invalid → fallback to first option
      initial = widget.options.first;
      await _prefs.setString(widget.prefsKey, initial);
    }

    setState(() {
      _currentValue = initial;
      _loading = false;
    });
  }

  Future<void> _onChanged(String? newValue) async {
    if (newValue == null) return;
    setState(() => _currentValue = newValue);
    await _prefs.setString(widget.prefsKey, newValue);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
      ),
      value: _currentValue,
      items:
          widget.options
              .map(
                (opt) => DropdownMenuItem(
                  value: opt,
                  child: Text(
                    opt,
                    style:
                        Theme.of(
                          context,
                        ).textTheme.bodyLarge,
                  ),
                ),
              )
              .toList(),
      onChanged: _onChanged,
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const weightOptions = [
    'light packer',
    'normal packer',
    'heavy packer',
  ];
  static const outdoorsOptions = ['yes', 'no'];
  static const snackerOptions = ['no', 'sometimes', 'yes'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 8.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PreferenceDropdown(
              prefsKey: "weight",
              options: weightOptions,
              label: "What type of packer are you?",
            ),
            SizedBox(height: 16),
            PreferenceDropdown(
              prefsKey: 'outdoors',
              options: outdoorsOptions,
              label: 'Do you like traveling outdoors?',
            ),
            SizedBox(height: 16),
            PreferenceDropdown(
              prefsKey: 'snacker',
              options: snackerOptions,
              label: 'Are you a snacker?',
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreenAppBar extends StatelessWidget {
  const ProfileScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "PROFILE",
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }
}
