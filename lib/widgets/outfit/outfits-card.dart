import 'package:flutter/material.dart';

import '../../models/outfit.dart';
import '../../models/wardrobe.dart';
import '../../services/outfit_service.dart';

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
          return const Center(
            child: Text(
              'Nie udało się pobrać Outfitów, dodaj outfity w zakładce szafy',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
                    'Outfit: ${outfit.name}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: outfit.wardrobeItems.length,
                      itemBuilder: (context, itemIndex) {
                        final Wardrobe wardrobeItem =
                            outfit.wardrobeItems[itemIndex];
                        return Container(
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Item: ${wardrobeItem.name}'),
                              Text('Type: ${wardrobeItem.typeClothes}'),
                              Flexible(
                                child: AspectRatio(
                                  aspectRatio:
                                      1, // Ensure a square aspect ratio
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      wardrobeItem.imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
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
