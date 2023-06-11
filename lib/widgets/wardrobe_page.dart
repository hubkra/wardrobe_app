import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/wardrobe.dart';
import '../services/wardrobe_service.dart';
import '../shared/enums/size_information.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WardrobePageState createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  late int _currentIndex;
  late WardrobeService _wardrobeService;
  List<Wardrobe> _wardrobes = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = 1;
    _wardrobeService = WardrobeService();
    _fetchClothes();
  }

  Future<void> _fetchClothes() async {
    try {
      final clothes = await _wardrobeService.findClothes();
      setState(() {
        _wardrobes = clothes;
      });
    } catch (error) {
      // Handle error
    }
  }

  Future<void> _addClothes(Wardrobe wardrobe) async {
    try {
      final addedClothes = await _wardrobeService.addClothes(wardrobe);
      setState(() {
        _wardrobes.add(addedClothes);
      });
    } catch (error) {
      // Handle error
    }
  }

  void _handleTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return AddClothesForm(
                        onAddClothes: _addClothes,
                      );
                    },
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Clothes'),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _wardrobes.length,
                itemBuilder: (BuildContext context, int index) {
                  final wardrobe = _wardrobes[index];
                  return ListTile(
                    title: Text(wardrobe.name),
                    subtitle: Text(wardrobe.typeClothes),
                    leading: Image.network(wardrobe.imageUrl),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddClothesForm extends StatefulWidget {
  final Function(Wardrobe) onAddClothes;

  const AddClothesForm({required this.onAddClothes});

  @override
  _AddClothesFormState createState() => _AddClothesFormState();
}

class _AddClothesFormState extends State<AddClothesForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _imageUrlController = TextEditingController();
  SizeInformation _selectedSize = SizeInformation.XL; // Default selected size

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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Clothes',
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
                  final newClothes = Wardrobe(
                    name: _nameController.text,
                    typeClothes: _typeController.text,
                    imageUrl: _imageUrlController.text,
                    size: _selectedSize.toString(),
                  );
                  widget.onAddClothes(newClothes);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
