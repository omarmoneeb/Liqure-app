import 'package:flutter/material.dart';

class CountryFilter extends StatefulWidget {
  final List<String>? selectedCountries;
  final Function(List<String>?) onChanged;
  final List<String> availableCountries;

  const CountryFilter({
    super.key,
    this.selectedCountries,
    required this.onChanged,
    required this.availableCountries,
  });

  @override
  State<CountryFilter> createState() => _CountryFilterState();
}

class _CountryFilterState extends State<CountryFilter> {
  late List<String> _selectedCountries;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedCountries = List.from(widget.selectedCountries ?? []);
  }

  @override
  void didUpdateWidget(CountryFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCountries != widget.selectedCountries) {
      _selectedCountries = List.from(widget.selectedCountries ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Country',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      if (_selectedCountries.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_selectedCountries.length}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.amber.shade800,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Selected countries preview
          if (_selectedCountries.isNotEmpty && !_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _selectedCountries.take(3).map((country) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          country,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if (_selectedCountries.length > 3)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '+ ${_selectedCountries.length - 3} more',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          
          // Expanded country list
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Clear all button
                  if (_selectedCountries.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _selectedCountries.clear();
                              });
                              widget.onChanged(_selectedCountries.isEmpty ? null : _selectedCountries);
                            },
                            icon: const Icon(Icons.clear_all, size: 18),
                            label: const Text('Clear All'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Country checkboxes
                  ...widget.availableCountries.map((country) {
                    final isSelected = _selectedCountries.contains(country);
                    return CheckboxListTile(
                      title: Text(
                        country,
                        style: const TextStyle(fontSize: 14),
                      ),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedCountries.add(country);
                          } else {
                            _selectedCountries.remove(country);
                          }
                        });
                        widget.onChanged(_selectedCountries.isEmpty ? null : _selectedCountries);
                      },
                      activeColor: Colors.amber,
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Helper function to get common countries for alcoholic beverages
List<String> getCommonDrinkCountries() {
  return [
    'Scotland',
    'Ireland',
    'USA',
    'Japan',
    'France',
    'Mexico',
    'Russia',
    'England',
    'Canada',
    'Germany',
    'Italy',
    'Spain',
    'Australia',
    'India',
    'Brazil',
    'Argentina',
    'Chile',
    'South Africa',
    'New Zealand',
    'Netherlands',
    'Belgium',
    'Sweden',
    'Norway',
    'Denmark',
    'Czech Republic',
    'Poland',
    'Greece',
    'Turkey',
    'China',
    'South Korea',
    'Thailand',
    'Philippines',
  ];
}