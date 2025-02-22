import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:panels/widgets/image_tile.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomePage extends StatefulWidget {
  final Function(bool) afterScrollResult;
  const HomePage({super.key, required this.afterScrollResult});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isVisible = true;
  final ScrollController _scrollController = ScrollController();
  List<Map<String, String>> _imageList = [];
  bool _isLoading = true;
  bool _isFetchingMore = false; // Prevent multiple API calls
  int _page = 1; // Track pagination page

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _fetchPexelsImages(); // Load initial images
  }

  /// Detect Scroll and Hide Top Bar
  void _handleScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isVisible) {
        setState(() => _isVisible = false);
        widget.afterScrollResult(false);
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isVisible) {
        setState(() => _isVisible = true);
        widget.afterScrollResult(true);
      }
    }

    // Detect when scrolled to the bottom
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _loadMoreImages();
    }
  }

  /// Fetch Images from Pexels API (Supports Pagination)
  Future<void> _fetchPexelsImages({bool isLoadMore = false}) async {
    if (_isFetchingMore) return; // Prevent multiple API calls

    setState(() {
      _isFetchingMore = true;
      if (!isLoadMore) _isLoading = true;
    });

    final String apiKey = dotenv.env['API_KEY']!;
    final String apiUrl =
        "https://api.pexels.com/v1/curated?per_page=20&page=$_page";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Authorization": apiKey},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> photos = data['photos'];

        setState(() {
          _imageList.addAll(photos.map((photo) {
            return {
              'imageUrl': photo['src']['medium'].toString(),
              'photographer': photo['photographer'].toString(),
              'photographerUrl': photo['photographer_url'].toString(),
            };
          }).toList());

          _isLoading = false;
          _isFetchingMore = false;
          _page++; // Increment page for next fetch
        });
      } else {
        throw Exception("Failed to load images");
      }
    } catch (e) {
      print("Error fetching images: $e");
      setState(() => _isFetchingMore = false);
    }
  }

  /// Load More Images when reaching the bottom
  void _loadMoreImages() {
    if (!_isFetchingMore) {
      _fetchPexelsImages(isLoadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: MasonryGridView.count(
                    controller: _scrollController,
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    padding: const EdgeInsets.all(12),
                    itemCount: _imageList.length,
                    itemBuilder: (context, index) {
                      return ImageTile(
                        index: index,
                        imageSource: _imageList[index]['imageUrl']!,
                        photographerName: _imageList[index]['photographer']!,
                        photographerUrl: _imageList[index]['photographerUrl']!,
                        extent: (index % 2) == 0 ? 300 : 150,
                      );
                    },
                  ),
                ),
                if (_isFetchingMore) // Show loader when fetching more images
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
    );
  }
}
