import 'package:flutter/material.dart';
import 'package:wardrobe_app/models/outfit.dart';
import 'package:wardrobe_app/models/wardrobe.dart';

class EditOutfitForm extends StatefulWidget {
  final Outfit outfit;
  final List<Wardrobe> wardrobeItems;
  final List<Wardrobe> selectedWardrobeItems;
  final Function(String, List<Wardrobe>) onUpdateOutfit;

  EditOutfitForm({
    required this.outfit,
    required this.wardrobeItems,
    required this.selectedWardrobeItems,
    required this.onUpdateOutfit,
  });

  @override
  _EditOutfitFormState createState() => _EditOutfitFormState();
}

class _EditOutfitFormState extends State<EditOutfitForm> {
  List<Wardrobe> selectedItems = [];
  final TextEditingController _outfitNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _outfitNameController.text = widget.outfit.name ?? '';

    selectedItems = List<Wardrobe>.from(widget.selectedWardrobeItems);
    for (var wardrobeItem in widget.wardrobeItems) {
      if (!selectedItems.contains(wardrobeItem)) {
        selectedItems.add(wardrobeItem);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFEEF5DB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Edit Outfit',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            controller: _outfitNameController,
            decoration: const InputDecoration(labelText: 'Outfit Name'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedItems.length,
              itemBuilder: (BuildContext context, int index) {
                final wardrobeItem = selectedItems[index];

                return ListTile(
                  leading: Checkbox(
                    value: true,
                    onChanged: null, // Zablokowanie zmiany checkboxa
                  ),
                  title: Text(wardrobeItem.name),
                  subtitle: Text(wardrobeItem.typeClothes),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    color: const Color(0xFFFE5F55),
                    onPressed: () {
                      setState(() {
                        selectedItems.remove(wardrobeItem);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onUpdateOutfit(_outfitNameController.text, selectedItems);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4F6367),
            ),
            child: const Text('Update Outfit'),
          ),
        ],
      ),
    );
  }
}
