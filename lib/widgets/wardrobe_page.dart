import 'package:flutter/material.dart';
import 'package:wardrobe_app/models/outfit.dart';

import '../models/wardrobe.dart';
import '../services/outfit-service.dart';
import '../services/wardrobe_service.dart';
import 'clothes/add_clothes_form.dart';
import 'clothes/edit_clothes_form.dart';
import 'outfit/add_outfit_form.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({Key? key}) : super(key: key);

  @override
  _WardrobePageState createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  late int _currentIndex;
  late WardrobeService _wardrobeService;
  late OutfitService _outfitService;
  List<Wardrobe> _wardrobes = [];
  List<Wardrobe> _filteredWardrobes = [];
  List<Outfit> _outfits = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _wardrobeService = WardrobeService();
    _outfitService = OutfitService();
    _fetchClothes();
    _fetchOutfits();
  }

  Future<List<Wardrobe>> _fetchClothes() async {
    try {
      final clothes = await _wardrobeService.findClothes();
      return clothes;
    } catch (error) {
      // Handle error
      return [];
    }
  }

  Future<List<Outfit>> _fetchOutfits() async {
    try {
      final outfits = await _outfitService.fetchOutfits();
      return outfits;
    } catch (error) {
      return [];
    }
  }

  Future<void> _deleteOutfit(int? id, int index) async {
    if (id != null) {
      try {
        await _outfitService.deleteOutfit(id);
        setState(() {
          _outfits.removeAt(index);
        });
      } catch (error) {
        // Handle error
      }
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

  Future<void> _deleteClothes(int? id) async {
    if (id != null) {
      try {
        await _wardrobeService.deleteClothes(id);
        setState(() {
          _wardrobes.removeWhere((wardrobe) => wardrobe.id == id);
          _filteredWardrobes.removeWhere((wardrobe) => wardrobe.id == id);
        });
      } catch (error) {
        // Handle error
      }
    }
  }

  Future<void> _editClothes(Wardrobe editedWardrobe) async {
    try {
      final updatedClothes =
          await _wardrobeService.updateClothes(editedWardrobe);
      setState(() {
        final index = _wardrobes
            .indexWhere((wardrobe) => wardrobe.id == updatedClothes.id);
        if (index != -1) {
          _wardrobes[index] = updatedClothes;
          _filteredWardrobes[index] = updatedClothes;
        }
      });
    } catch (error) {
      // Handle error
    }
  }

  Future<void> _createOutfit(List<Wardrobe> wardrobeItems) async {
    try {
      final newOutfit = await _outfitService.createOutfit(wardrobeItems);
      setState(() {
        _outfits.add(newOutfit);
      });
    } catch (error) {
      // Handle error
    }
  }

  void _handleEdit(Wardrobe wardrobe) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return EditClothesForm(
          wardrobe: wardrobe,
          onEditClothes: _editClothes,
        );
      },
    );
  }

  void _filterWardrobes(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredWardrobes = List.from(_wardrobes);
      } else {
        _filteredWardrobes = _wardrobes
            .where((wardrobe) =>
                wardrobe.name.toLowerCase().contains(query.toLowerCase()) ||
                wardrobe.typeClothes
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Wyszukaj',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (query) {
                  _filterWardrobes(query);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade800,
                    ),
                    onPressed: () {
                      setState(() {
                        _currentIndex = 0; // Show clothes view
                      });
                    },
                    child: const Text('Clothes'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade800,
                    ),
                    onPressed: () {
                      setState(() {
                        _currentIndex = 1; // Show outfits view
                      });
                    },
                    child: const Text('Outfits'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  FutureBuilder<List<Wardrobe>>(
                    future: _fetchClothes(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        _wardrobes = snapshot.data ?? [];
                        _filteredWardrobes = List.from(_wardrobes);
                        return ListView.builder(
                          itemCount: _filteredWardrobes.length,
                          itemBuilder: (BuildContext context, int index) {
                            final wardrobe = _filteredWardrobes[index];
                            return ListTile(
                              title: Text(wardrobe.name),
                              subtitle: Text(wardrobe.typeClothes),
                              leading: wardrobe.imageUrl.isNotEmpty
                                  ? Image.network(wardrobe.imageUrl)
                                  : Icon(Icons.checkroom),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    color: Colors.deepPurple.shade800,
                                    hoverColor: Colors.transparent,
                                    onPressed: () {
                                      _handleEdit(wardrobe);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    hoverColor: Colors.transparent,
                                    color: Colors.red,
                                    onPressed: () {
                                      _deleteClothes(wardrobe.id);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                  FutureBuilder<List<Outfit>>(
                    future: _fetchOutfits(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        _outfits = snapshot.data ?? [];
                        return ListView.builder(
                          itemCount: _outfits.length,
                          itemBuilder: (BuildContext context, int index) {
                            final outfit = _outfits[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Outfit ${outfit.id.toString()}'),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.redAccent),
                                        hoverColor: Colors.transparent,
                                        onPressed: () {
                                          _deleteOutfit(outfit.id, index);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: outfit.wardrobeItems.length,
                                  itemBuilder: (BuildContext context,
                                      int wardrobeIndex) {
                                    final wardrobeItem =
                                        outfit.wardrobeItems[wardrobeIndex];
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      margin: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        title: Text(wardrobeItem.name),
                                        subtitle:
                                            Text(wardrobeItem.typeClothes),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  backgroundColor: Colors.deepPurple.shade800,
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
                  child: const Icon(
                    Icons.add,
                    size: 32.0,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return AddOutfitForm(
                          wardrobeItems: _wardrobes,
                          onCreateOutfit: _createOutfit,
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    padding: EdgeInsets.zero,
                    elevation: 4.0,
                  ),
                  child: const Icon(
                    Icons.checkroom_rounded,
                    size: 32.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
