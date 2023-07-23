import 'package:flutter/material.dart';

import '../models/outfit.dart';
import '../models/wardrobe.dart';
import '../services/outfit-service.dart';

class OutfitsCard extends StatefulWidget {
  final int outfitId;

  const OutfitsCard({Key? key, required this.outfitId}) : super(key: key);

  @override
  State<OutfitsCard> createState() => _OutfitsCardState();
}

class _OutfitsCardState extends State<OutfitsCard> {
  Future<Outfit>? outfitFuture;
  OutfitService outfitService = OutfitService();
  Outfit? outfit;

  @override
  void initState() {
    super.initState();
    outfitFuture = outfitService.fetchOutfitById(widget.outfitId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Outfit>(
      future: outfitFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Center(
            child: Text('Error: Unable to fetch outfit.'),
          );
        } else {
          final Outfit outfit = snapshot.data!;
          return Card(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Outfit ${outfit.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: outfit.wardrobeItems.length,
                      itemBuilder: (context, itemIndex) {
                        final Wardrobe wardrobeItem =
                            outfit.wardrobeItems[itemIndex];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Item: ${wardrobeItem.name}'),
                            Text('Type: ${wardrobeItem.typeClothes}'),
                            Image.network(
                              wardrobeItem.imageUrl,
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
