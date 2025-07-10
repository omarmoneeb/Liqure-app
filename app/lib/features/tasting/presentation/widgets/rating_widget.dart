import 'package:flutter/material.dart';

class RatingWidget extends StatefulWidget {
  final double rating;
  final double size;
  final Function(double)? onRatingChanged;
  final bool allowHalfRating;
  final Color color;

  const RatingWidget({
    super.key,
    required this.rating,
    this.size = 32,
    this.onRatingChanged,
    this.allowHalfRating = true,
    this.color = Colors.amber,
  });

  @override
  State<RatingWidget> createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  double _currentRating = 0;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

  @override
  void didUpdateWidget(RatingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rating != widget.rating) {
      _currentRating = widget.rating;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTapDown: widget.onRatingChanged != null
              ? (details) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final localPosition = box.globalToLocal(details.globalPosition);
                  final starWidth = widget.size;
                  final starIndex = localPosition.dx / starWidth;
                  
                  double newRating;
                  if (widget.allowHalfRating) {
                    final decimal = starIndex - index;
                    if (decimal < 0.5) {
                      newRating = index + 0.5;
                    } else {
                      newRating = index + 1;
                    }
                  } else {
                    newRating = index + 1;
                  }
                  
                  newRating = newRating.clamp(0.5, 5.0);
                  
                  setState(() {
                    _currentRating = newRating;
                  });
                  
                  widget.onRatingChanged!(newRating);
                }
              : null,
          child: Icon(
            _getIconForPosition(index + 1, _currentRating),
            color: widget.color,
            size: widget.size,
          ),
        );
      }),
    );
  }

  IconData _getIconForPosition(int position, double rating) {
    if (position <= rating) {
      return Icons.star;
    } else if (position - 0.5 <= rating && widget.allowHalfRating) {
      return Icons.star_half;
    } else {
      return Icons.star_outline;
    }
  }
}