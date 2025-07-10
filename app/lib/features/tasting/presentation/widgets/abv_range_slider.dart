import 'package:flutter/material.dart';

class ABVRangeSlider extends StatefulWidget {
  final double? minValue;
  final double? maxValue;
  final Function(double?, double?) onChanged;
  final double minLimit;
  final double maxLimit;

  const ABVRangeSlider({
    super.key,
    this.minValue,
    this.maxValue,
    required this.onChanged,
    this.minLimit = 0.0,
    this.maxLimit = 100.0,
  });

  @override
  State<ABVRangeSlider> createState() => _ABVRangeSliderState();
}

class _ABVRangeSliderState extends State<ABVRangeSlider> {
  late RangeValues _currentRangeValues;
  bool _isActive = false;

  @override
  void initState() {
    super.initState();
    _currentRangeValues = RangeValues(
      widget.minValue ?? widget.minLimit,
      widget.maxValue ?? widget.maxLimit,
    );
    _isActive = widget.minValue != null || widget.maxValue != null;
  }

  @override
  void didUpdateWidget(ABVRangeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.minValue != widget.minValue || oldWidget.maxValue != widget.maxValue) {
      _currentRangeValues = RangeValues(
        widget.minValue ?? widget.minLimit,
        widget.maxValue ?? widget.maxLimit,
      );
      _isActive = widget.minValue != null || widget.maxValue != null;
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
            // Header with toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ABV Range',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    if (_isActive)
                      Text(
                        '${_currentRangeValues.start.round()}% - ${_currentRangeValues.end.round()}%',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    const SizedBox(width: 8),
                    Switch(
                      value: _isActive,
                      onChanged: (value) {
                        setState(() {
                          _isActive = value;
                        });
                        if (value) {
                          widget.onChanged(
                            _currentRangeValues.start,
                            _currentRangeValues.end,
                          );
                        } else {
                          widget.onChanged(null, null);
                        }
                      },
                      activeColor: Colors.amber,
                    ),
                  ],
                ),
              ],
            ),
            
            if (_isActive) ...[
              const SizedBox(height: 16),
              
              // Range slider
              RangeSlider(
                values: _currentRangeValues,
                min: widget.minLimit,
                max: widget.maxLimit,
                divisions: (widget.maxLimit - widget.minLimit).round(),
                activeColor: Colors.amber,
                inactiveColor: Colors.amber.shade100,
                labels: RangeLabels(
                  '${_currentRangeValues.start.round()}%',
                  '${_currentRangeValues.end.round()}%',
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues = values;
                  });
                  widget.onChanged(values.start, values.end);
                },
              ),
              
              // Range indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.minLimit.round()}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    '${widget.maxLimit.round()}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Quick preset buttons
              Wrap(
                spacing: 8,
                children: [
                  _buildPresetChip('Low (0-20%)', 0, 20),
                  _buildPresetChip('Standard (20-40%)', 20, 40),
                  _buildPresetChip('Strong (40-60%)', 40, 60),
                  _buildPresetChip('High (60%+)', 60, 100),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip(String label, double min, double max) {
    final isSelected = _currentRangeValues.start == min && _currentRangeValues.end == max;
    
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? Colors.white : Colors.grey.shade700,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _currentRangeValues = RangeValues(min, max);
          });
          widget.onChanged(min, max);
        }
      },
      backgroundColor: Colors.grey.shade100,
      selectedColor: Colors.amber.shade600,
      checkmarkColor: Colors.white,
    );
  }
}