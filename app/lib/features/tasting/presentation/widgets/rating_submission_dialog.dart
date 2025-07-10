import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/rating.dart';
import '../providers/tasting_providers.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'rating_widget.dart';

class RatingSubmissionDialog extends ConsumerStatefulWidget {
  final String drinkId;
  final Rating? existingRating;

  const RatingSubmissionDialog({
    super.key,
    required this.drinkId,
    this.existingRating,
  });

  @override
  ConsumerState<RatingSubmissionDialog> createState() => _RatingSubmissionDialogState();
}

class _RatingSubmissionDialogState extends ConsumerState<RatingSubmissionDialog> {
  late double _rating;
  late TextEditingController _notesController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.existingRating?.rating ?? 0;
    _notesController = TextEditingController(text: widget.existingRating?.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingRating != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Rating' : 'Rate This Drink'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Rating',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: RatingWidget(
                rating: _rating,
                size: 40,
                onRatingChanged: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                _rating == 0 ? 'Tap to rate' : '$_rating stars',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Notes (optional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add your thoughts about this drink...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting || _rating == 0 ? null : _submitRating,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(isEditing ? 'Update' : 'Submit'),
        ),
      ],
    );
  }

  Future<void> _submitRating() async {
    if (_rating == 0) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final isEditing = widget.existingRating != null;
      final notes = _notesController.text.trim();

      final authState = ref.read(authProvider);
      if (authState.user == null) {
        throw Exception('User not authenticated');
      }
      
      if (isEditing) {
        // Update existing rating
        final updatedRating = widget.existingRating!.copyWith(
          rating: _rating,
          notes: notes.isEmpty ? null : notes,
        );
        
        await ref.read(ratingNotifierProvider.notifier).updateRating(updatedRating);
      } else {
        // Create new rating
        final newRating = Rating(
          id: '', // Will be set by backend
          userId: authState.user!.id,
          drinkId: widget.drinkId,
          rating: _rating,
          notes: notes.isEmpty ? null : notes,
          created: DateTime.now(),
          updated: DateTime.now(),
        );
        
        await ref.read(ratingNotifierProvider.notifier).createRating(newRating);
      }

      // Refresh the rating data
      ref.refresh(userDrinkRatingProvider(widget.drinkId));
      ref.refresh(drinkAverageRatingProvider(widget.drinkId));
      ref.refresh(drinkRatingsProvider(widget.drinkId));

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? 'Rating updated!' : 'Rating added!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}