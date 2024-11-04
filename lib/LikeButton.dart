import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikeButton extends StatefulWidget {
  final String itemId;

  const LikeButton({Key? key, required this.itemId}) : super(key: key);

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  static Set<String> _clickedItems = {};
  late SharedPreferences _prefs;
  bool isLiked = false;
  late String _key;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    _loadLikeCount();
    _key = 'likeCount_${widget.itemId}';
  }

  void _loadLikeCount() async {

    _prefs = await SharedPreferences.getInstance();
    setState(() {
      likeCount = _prefs.getInt(_key) ?? 0;
      isLiked = _clickedItems.contains(widget.itemId);
    });
  }

  void _saveLikeCount(int count) async {
    _prefs.setInt(_key, count);
    _clickedItems.add(_key);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              isLiked = !isLiked;
              if (isLiked) {
                likeCount++;
              } else {
                likeCount--;
              }
              _saveLikeCount(likeCount);
            });
          },
        ),
        SizedBox(width: 4),
        Text('$likeCount', style: TextStyle(color: Colors.white),),
      ],
    );
  }
}