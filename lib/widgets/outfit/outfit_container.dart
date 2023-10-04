import 'package:flutter/material.dart';

import '../../models/wardrobe.dart';

class OutfitContainer extends StatefulWidget {
  @override
  _OutfitContainerState createState() => _OutfitContainerState();
}

class _OutfitContainerState extends State<OutfitContainer> {
  List<Wardrobe> _outfitItems = [];

  void _addToOutfit(Wardrobe wardrobe) {
    if (_outfitItems.length < 5) {
      setState(() {
        _outfitItems.add(wardrobe);
      });
    } else {
      // Inform user that the outfit container is already full
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Outfit Container Full'),
            content: const Text(
                'You have reached the maximum limit of outfit items.'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _removeFromOutfit(Wardrobe wardrobe) {
    setState(() {
      _outfitItems.remove(wardrobe);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFB8D8D8),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _outfitItems.length,
        itemBuilder: (BuildContext context, int index) {
          final wardrobe = _outfitItems[index];
          return Container(
            margin: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                // Outfit item image
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(wardrobe.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Remove button
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      _removeFromOutfit(wardrobe);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
