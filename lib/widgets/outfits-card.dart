import 'package:flutter/material.dart';

import '../models/outfit.dart';
import '../models/wardrobe.dart';
import '../services/outfit-service.dart';

class OutfitsCard extends StatefulWidget {
  const OutfitsCard({Key? key}) : super(key: key);

  @override
  State<OutfitsCard> createState() => _OutfitsCardState();
}

class _OutfitsCardState extends State<OutfitsCard> {
  Future<List<Outfit>>? outfitsFuture;
  OutfitService outfitService = OutfitService();

  @override
  void initState() {
    super.initState();
    outfitsFuture = outfitService.fetchOutfits();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Outfit>>(
      future: outfitsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Outfit> outfits = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
            ),
            itemCount: outfits.length,
            itemBuilder: (context, index) {
              final Outfit outfit = outfits[index];
              return Card(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Outfit ${outfit.id}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
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
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
