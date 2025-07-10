import 'package:flutter/material.dart';

class RatingFilter extends StatefulWidget {
  final double? minRating;
  final double? maxRating;
  final bool? onlyRated;
  final bool? onlyUnrated;
  final Function(double?, double?, bool?, bool?) onChanged;

  const RatingFilter({
    super.key,
    this.minRating,
    this.maxRating,
    this.onlyRated,
    this.onlyUnrated,
    required this.onChanged,
  });

  @override
  State<RatingFilter> createState() => _RatingFilterState();
}

class _RatingFilterState extends State<RatingFilter> {
  late RangeValues _currentRatingRange;
  bool _useRatingRange = false;
  bool _onlyRated = false;
  bool _onlyUnrated = false;

  @override
  void initState() {
    super.initState();
    _currentRatingRange = RangeValues(
      widget.minRating ?? 0.0,
      widget.maxRating ?? 5.0,
    );
    _useRatingRange = widget.minRating != null || widget.maxRating != null;
    _onlyRated = widget.onlyRated ?? false;
    _onlyUnrated = widget.onlyUnrated ?? false;
  }

  @override
  void didUpdateWidget(RatingFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.minRating != widget.minRating || 
        oldWidget.maxRating != widget.maxRating ||
        oldWidget.onlyRated != widget.onlyRated ||
        oldWidget.onlyUnrated != widget.onlyUnrated) {
      _currentRatingRange = RangeValues(
        widget.minRating ?? 0.0,
        widget.maxRating ?? 5.0,
      );
      _useRatingRange = widget.minRating != null || widget.maxRating != null;
      _onlyRated = widget.onlyRated ?? false;
      _onlyUnrated = widget.onlyUnrated ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rating Filters',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // Quick filter options
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickFilterChip(
                  'Only Rated',
                  Icons.star,
                  _onlyRated,
                  () {
                    setState(() {
                      _onlyRated = !_onlyRated;
                      if (_onlyRated) _onlyUnrated = false;
                    });
                    _updateFilter();
                  },
                ),
                _buildQuickFilterChip(
                  'Only Unrated',
                  Icons.star_border,
                  _onlyUnrated,
                  () {
                    setState(() {
                      _onlyUnrated = !_onlyUnrated;
                      if (_onlyUnrated) _onlyRated = false;
                    });
                    _updateFilter();
                  },
                ),
                _buildQuickFilterChip(
                  'Highly Rated (4+ ★)',
                  Icons.star,
                  false,
                  () {
                    setState(() {
                      _useRatingRange = true;
                      _currentRatingRange = const RangeValues(4.0, 5.0);
                      _onlyRated = false;
                      _onlyUnrated = false;
                    });
                    _updateFilter();
                  },
                ),
                _buildQuickFilterChip(
                  'Top Rated (4.5+ ★)',
                  Icons.star,
                  false,
                  () {
                    setState(() {
                      _useRatingRange = true;
                      _currentRatingRange = const RangeValues(4.5, 5.0);
                      _onlyRated = false;
                      _onlyUnrated = false;
                    });
                    _updateFilter();
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Rating range section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Rating Range',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    if (_useRatingRange)
                      Text(
                        '${_currentRatingRange.start.toStringAsFixed(1)} - ${_currentRatingRange.end.toStringAsFixed(1)} ★',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.amber.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    const SizedBox(width: 8),
                    Switch(
                      value: _useRatingRange,
                      onChanged: (value) {
                        setState(() {
                          _useRatingRange = value;
                          if (!value) {
                            _onlyRated = false;
                            _onlyUnrated = false;
                          }
                        });
                        _updateFilter();
                      },
                      activeColor: Colors.amber,
                    ),
                  ],
                ),
              ],
            ),
            
            if (_useRatingRange) ...[
              const SizedBox(height: 8),
              
              // Rating range slider
              RangeSlider(
                values: _currentRatingRange,
                min: 0.0,
                max: 5.0,
                divisions: 10, // 0.5 increments
                activeColor: Colors.amber,
                inactiveColor: Colors.amber.shade100,
                labels: RangeLabels(
                  '${_currentRatingRange.start.toStringAsFixed(1)}★',
                  '${_currentRatingRange.end.toStringAsFixed(1)}★',
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRatingRange = values;
                  });
                  _updateFilter();
                },
              ),
              
              // Star visual indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStarIndicator(0),
                  _buildStarIndicator(1),
                  _buildStarIndicator(2),
                  _buildStarIndicator(3),
                  _buildStarIndicator(4),
                  _buildStarIndicator(5),
                ],
              ),
            ],
            
            // Clear rating filters
            if (_useRatingRange || _onlyRated || _onlyUnrated) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _useRatingRange = false;
                    _onlyRated = false;
                    _onlyUnrated = false;
                    _currentRatingRange = const RangeValues(0.0, 5.0);
                  });
                  _updateFilter();
                },
                icon: const Icon(Icons.clear, size: 18),
                label: const Text('Clear Rating Filters'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickFilterChip(String label, IconData icon, bool isSelected, VoidCallback onTap) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.grey.shade100,
      selectedColor: Colors.amber.shade200,
      checkmarkColor: Colors.amber.shade800,
      labelStyle: TextStyle(
        fontSize: 12,
        color: isSelected ? Colors.amber.shade800 : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildStarIndicator(int stars) {
    return Column(
      children: [
        Icon(
          Icons.star,
          size: 16,
          color: _currentRatingRange.start <= stars && stars <= _currentRatingRange.end
              ? Colors.amber
              : Colors.grey.shade300,
        ),
        Text(
          '$stars',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  void _updateFilter() {
    widget.onChanged(
      _useRatingRange ? _currentRatingRange.start : null,
      _useRatingRange ? _currentRatingRange.end : null,
      _onlyRated ? true : null,
      _onlyUnrated ? true : null,
    );
  }
}

// Quick rating filter buttons for the main UI
class QuickRatingFilters extends StatelessWidget {
  final bool? onlyRated;
  final bool? onlyUnrated;
  final double? minRating;
  final Function(bool?, bool?, double?, double?) onChanged;

  const QuickRatingFilters({
    super.key,
    this.onlyRated,
    this.onlyUnrated,
    this.minRating,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: [
        _buildQuickChip(
          'Rated',
          Icons.star,
          onlyRated == true,
          () => onChanged(onlyRated == true ? null : true, null, null, null),
        ),
        _buildQuickChip(
          'Unrated',
          Icons.star_border,
          onlyUnrated == true,
          () => onChanged(null, onlyUnrated == true ? null : true, null, null),
        ),
        _buildQuickChip(
          '4+ Stars',
          Icons.star,
          minRating == 4.0,
          () => onChanged(null, null, minRating == 4.0 ? null : 4.0, minRating == 4.0 ? null : 5.0),
        ),
      ],
    );
  }

  Widget _buildQuickChip(String label, IconData icon, bool isSelected, VoidCallback onPressed) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (_) => onPressed(),
      backgroundColor: Colors.grey.shade100,
      selectedColor: Colors.amber.shade200,
      checkmarkColor: Colors.amber.shade800,
      labelStyle: TextStyle(
        fontSize: 11,
        color: isSelected ? Colors.amber.shade800 : Colors.grey.shade700,
      ),
    );
  }
}