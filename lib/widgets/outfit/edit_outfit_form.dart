import 'package:flutter/material.dart';
import 'package:wardrobe_app/models/outfit.dart';
import 'package:wardrobe_app/models/wardrobe.dart';

class EditOutfitForm extends StatefulWidget {
  final Outfit outfit;
  final List<Wardrobe> wardrobeItems;
  final Function(String, List<Wardrobe>) onUpdateOutfit;

  EditOutfitForm({
    required this.outfit,
    required this.wardrobeItems,
    required this.onUpdateOutfit,
  });

  @override
  _EditOutfitFormState createState() => _EditOutfitFormState();
}

class _EditOutfitFormState extends State<EditOutfitForm> {
  List<Wardrobe> selectedItems = [];
  TextEditingController _outfitNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _outfitNameController.text = widget.outfit.name ?? '';
    selectedItems.addAll(widget.outfit.wardrobeItems);
  }

  @override
  void dispose() {
    _outfitNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Edit Outfit',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            controller: _outfitNameController,
            decoration: InputDecoration(labelText: 'Outfit Name'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.wardrobeItems.length,
              itemBuilder: (BuildContext context, int index) {
                final wardrobeItem = widget.wardrobeItems[index];
                final isSelected = selectedItems.contains(wardrobeItem);

                return ListTile(
                  leading: Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value != null) {
                          if (value) {
                            selectedItems.add(wardrobeItem);
                          } else {
                            selectedItems.remove(wardrobeItem);
                          }
                        }
                      });
                    },
                  ),
                  title: Text(wardrobeItem.name),
                  subtitle: Text(wardrobeItem.typeClothes),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onUpdateOutfit(
                _outfitNameController.text,
                selectedItems,
              );
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade800,
            ),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
