import 'package:flutter/material.dart';

import '../../models/wardrobe.dart';
import '../../shared/enums/size_information.dart';
import '../../shared/enums/size_information_extension.dart';

class EditClothesForm extends StatefulWidget {
  final Wardrobe wardrobe;
  final Function(Wardrobe) onEditClothes;

  const EditClothesForm({
    super.key,
    required this.wardrobe,
    required this.onEditClothes,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EditClothesFormState createState() => _EditClothesFormState();
}

class _EditClothesFormState extends State<EditClothesForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _imageUrlController = TextEditingController();
  SizeInformation _selectedSize = SizeInformation.XL;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.wardrobe.name;
    _typeController.text = widget.wardrobe.typeClothes;
    _imageUrlController.text = widget.wardrobe.imageUrl;
    _selectedSize = SizeInformationExtension.fromString(widget.wardrobe.size);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFEEF5DB),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Clothes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _typeController,
              decoration: const InputDecoration(labelText: 'Type of Clothes'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the type of clothes';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the image URL';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ToggleButtons(
              isSelected: List.generate(SizeInformation.values.length, (index) {
                return SizeInformation.values[index] == _selectedSize;
              }),
              onPressed: (int index) {
                setState(() {
                  _selectedSize = SizeInformation.values[index];
                });
              },
              children: SizeInformation.values
                  .map((size) => Text(size.toString().split('.').last))
                  .toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final editedClothes = Wardrobe(
                    id: widget.wardrobe.id,
                    name: _nameController.text,
                    typeClothes: _typeController.text,
                    imageUrl: _imageUrlController.text,
                    size: _selectedSize.toString(),
                  );
                  widget.onEditClothes(editedClothes);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F6367),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
