import 'package:flutter/material.dart';

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback? onRatingChange;
  final RatingChangeCallback? onRatingChanged;
  final Color? color;
  final double size;

  StarRating({
    this.starCount = 5,
    this.rating = .0,
    this.onRatingChange,
    this.onRatingChanged,
    this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        children:
            new List.generate(starCount, (index) => buildStar(context, index)));
  }

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      );
    } else if (index > rating - 0.5 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      );
    }

    return new GestureDetector(
      onTap: () {
        if (this.onRatingChanged != null) onRatingChanged!(index + 1.0);
      },
      onHorizontalDragEnd: (dragDetails) {
        RenderBox box = context.findRenderObject() as RenderBox;
        var newRating = _calcRating(box, dragDetails.globalPosition);
        if (this.onRatingChanged != null) onRatingChanged!(newRating);
      },
      onHorizontalDragUpdate: (dragDetails) {
        RenderBox box = context.findRenderObject() as RenderBox;
        var newRating = _calcRating(box, dragDetails.globalPosition);
        if (this.onRatingChanged != null) onRatingChange!(newRating);
      },
      child: icon,
    );
  }

  double _calcRating(RenderBox box, Offset offset) {
    var _pos = box.globalToLocal(offset);
    var i = _pos.dx / size;
    var newRating = i;
    if (newRating > starCount) {
      newRating = starCount.toDouble();
    }
    if (newRating < 0) {
      newRating = 0.0;
    }
    return newRating;
  }
}
