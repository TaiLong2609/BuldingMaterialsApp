import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class PickedLocation {
  const PickedLocation({required this.address, required this.latitude, required this.longitude});
  final String address;
  final double latitude;
  final double longitude;
}

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key, this.initialAddress});

  final String? initialAddress;

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final _searchCtrl = TextEditingController();
  final _mapController = MapController();
  LatLng _selected = const LatLng(10.7769, 106.7009); // TP.HCM
  String _address = 'TP. Hồ Chí Minh';
  bool _isSearching = false;
  List<_SearchPlace> _results = [];

  @override
  void initState() {
    super.initState();
    _searchCtrl.text = widget.initialAddress ?? '';
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final q = _searchCtrl.text.trim();
    if (q.isEmpty) return;
    setState(() => _isSearching = true);
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': q,
        'format': 'json',
        'addressdetails': '1',
        'limit': '8',
        'countrycodes': 'vn',
      });
      final res = await http.get(uri, headers: {'User-Agent': 'BachHoaOnlineFlutterApp/1.0'});
      final decoded = jsonDecode(res.body);
      final places = decoded is List
          ? decoded.map((e) => _SearchPlace.fromJson(e as Map<String, dynamic>)).toList()
          : <_SearchPlace>[];
      if (!mounted) return;
      setState(() => _results = places);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Không thể tìm địa chỉ: $error')));
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  void _selectPlace(_SearchPlace place) {
    setState(() {
      _selected = LatLng(place.lat, place.lon);
      _address = place.displayName;
      _searchCtrl.text = place.displayName;
      _results = [];
    });
    _mapController.move(_selected, 16);
  }

  void _pickOnMap(LatLng point) {
    setState(() {
      _selected = point;
      _address = 'Vị trí đã chọn: ${point.latitude.toStringAsFixed(6)}, ${point.longitude.toStringAsFixed(6)}';
      _searchCtrl.text = _address;
      _results = [];
    });
  }

  void _confirm() {
    Navigator.pop(
      context,
      PickedLocation(address: _address, latitude: _selected.latitude, longitude: _selected.longitude),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn địa điểm giao hàng')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Tìm địa chỉ',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _isSearching ? null : _search,
                  child: Text(_isSearching ? '...' : 'Tìm'),
                ),
              ],
            ),
          ),
          if (_results.isNotEmpty)
            SizedBox(
              height: 170,
              child: ListView.builder(
                itemCount: _results.length,
                itemBuilder: (context, index) {
                  final place = _results[index];
                  return ListTile(
                    leading: const Icon(Icons.place_outlined),
                    title: Text(place.displayName, maxLines: 2, overflow: TextOverflow.ellipsis),
                    onTap: () => _selectPlace(place),
                  );
                },
              ),
            ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _selected,
                initialZoom: 13,
                onTap: (_, point) => _pickOnMap(point),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app_bachhoa',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selected,
                      width: 48,
                      height: 48,
                      child: const Icon(Icons.location_pin, color: Colors.red, size: 42),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8)],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_address, maxLines: 2, overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _confirm,
                    icon: const Icon(Icons.check),
                    label: const Text('Dùng địa điểm này'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchPlace {
  const _SearchPlace({required this.displayName, required this.lat, required this.lon});
  final String displayName;
  final double lat;
  final double lon;

  factory _SearchPlace.fromJson(Map<String, dynamic> json) {
    return _SearchPlace(
      displayName: json['display_name']?.toString() ?? '',
      lat: double.tryParse(json['lat']?.toString() ?? '') ?? 0,
      lon: double.tryParse(json['lon']?.toString() ?? '') ?? 0,
    );
  }
}
