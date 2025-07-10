import 'package:flutter/material.dart';
import '../providers/tasting_providers.dart';

class EnhancedSearchBar extends StatefulWidget {
  final String? searchQuery;
  final List<SearchField> searchFields;
  final Function(String?) onSearchChanged;
  final Function(List<SearchField>) onSearchFieldsChanged;
  final List<String> searchSuggestions;

  const EnhancedSearchBar({
    super.key,
    this.searchQuery,
    required this.searchFields,
    required this.onSearchChanged,
    required this.onSearchFieldsChanged,
    this.searchSuggestions = const [],
  });

  @override
  State<EnhancedSearchBar> createState() => _EnhancedSearchBarState();
}

class _EnhancedSearchBarState extends State<EnhancedSearchBar> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;
  bool _showFieldSelector = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.searchQuery);
    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _focusNode.hasFocus && widget.searchSuggestions.isNotEmpty;
      });
    });
  }

  @override
  void didUpdateWidget(EnhancedSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _controller.text = widget.searchQuery ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main search bar
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: _getSearchHint(),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search field selector
                  IconButton(
                    icon: Icon(
                      Icons.tune,
                      color: _showFieldSelector ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _showFieldSelector = !_showFieldSelector;
                      });
                    },
                    tooltip: 'Search in specific fields',
                  ),
                  
                  // Clear button
                  if (_controller.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _controller.clear();
                        widget.onSearchChanged(null);
                        setState(() {
                          _showSuggestions = false;
                        });
                      },
                    ),
                ],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            onChanged: (value) {
              widget.onSearchChanged(value.isEmpty ? null : value);
              setState(() {
                _showSuggestions = value.isNotEmpty && widget.searchSuggestions.isNotEmpty;
              });
            },
            onSubmitted: (value) {
              setState(() {
                _showSuggestions = false;
              });
              _focusNode.unfocus();
            },
          ),
        ),
        
        // Search field selector
        if (_showFieldSelector) ...[
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search in:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: SearchField.values.map((field) {
                      final isSelected = widget.searchFields.contains(field);
                      return FilterChip(
                        label: Text(_getFieldDisplayName(field)),
                        selected: isSelected,
                        onSelected: (selected) {
                          final newFields = List<SearchField>.from(widget.searchFields);
                          if (selected) {
                            if (!newFields.contains(field)) {
                              newFields.add(field);
                            }
                          } else {
                            newFields.remove(field);
                          }
                          
                          // Ensure at least one field is selected
                          if (newFields.isEmpty) {
                            newFields.add(SearchField.name);
                          }
                          
                          widget.onSearchFieldsChanged(newFields);
                        },
                        backgroundColor: Colors.grey.shade100,
                        selectedColor: Colors.amber.shade200,
                        checkmarkColor: Colors.amber.shade800,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
        
        // Search suggestions
        if (_showSuggestions) ...[
          const SizedBox(height: 8),
          Card(
            elevation: 2,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.searchSuggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = widget.searchSuggestions[index];
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.search, size: 18, color: Colors.grey),
                    title: Text(
                      suggestion,
                      style: const TextStyle(fontSize: 14),
                    ),
                    onTap: () {
                      _controller.text = suggestion;
                      widget.onSearchChanged(suggestion);
                      setState(() {
                        _showSuggestions = false;
                      });
                      _focusNode.unfocus();
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _getSearchHint() {
    if (widget.searchFields.length == 1) {
      return 'Search by ${_getFieldDisplayName(widget.searchFields.first).toLowerCase()}...';
    } else if (widget.searchFields.length == SearchField.values.length) {
      return 'Search drinks...';
    } else {
      return 'Search in ${widget.searchFields.length} fields...';
    }
  }

  String _getFieldDisplayName(SearchField field) {
    switch (field) {
      case SearchField.name:
        return 'Name';
      case SearchField.description:
        return 'Description';
      case SearchField.country:
        return 'Country';
    }
  }
}

// Quick search suggestions
class QuickSearchSuggestions extends StatelessWidget {
  final Function(String) onSuggestionTap;

  const QuickSearchSuggestions({
    super.key,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      'Whiskey',
      'Single Malt',
      'Bourbon',
      'Scotch',
      'Japanese',
      'Highland',
      'Speyside',
      'Islay',
      'Sherry Cask',
      'Peated',
    ];

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: suggestions.map((suggestion) {
        return ActionChip(
          label: Text(
            suggestion,
            style: const TextStyle(fontSize: 12),
          ),
          onPressed: () => onSuggestionTap(suggestion),
          backgroundColor: Colors.grey.shade100,
          side: BorderSide(color: Colors.grey.shade300),
        );
      }).toList(),
    );
  }
}