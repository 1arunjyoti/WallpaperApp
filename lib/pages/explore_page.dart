/* import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:panels/widgets/image_tile.dart';
import 'package:panels/services/pexels_api.dart';

const double kImageSliderHeight = 320;

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  bool _isVisible = true;
  int _selectedSlideIndex = 0;
  final ScrollController _scrollController = ScrollController();
  List<String> _sliderImages = [];
  List<String> _gridImages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchImages();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible &&
            _scrollController.position.pixels >= kImageSliderHeight) {
          setState(() {
            _isVisible = false;
          });
        }
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      }
    });
  }

  Future<void> _fetchImages() async {
    List<String> images = await PexelsAPI.fetchImages();
    setState(() {
      _sliderImages = images.take(5).toList();
      _gridImages = images;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isVisible ? Colors.black : Colors.white,
      body: SafeArea(
        top: !_isVisible,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Image Slider
              SliverAppBar(
                expandedHeight: kImageSliderHeight,
                backgroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      PageView.builder(
                        itemCount:
                            _sliderImages.isNotEmpty ? _sliderImages.length : 5,
                        onPageChanged: (value) {
                          setState(() {
                            _selectedSlideIndex = value;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: _sliderImages.isNotEmpty
                                    ? _sliderImages[index]
                                    : 'https://picsum.photos/500/500?random=slide_$index',
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              // Gradient effect
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.black, Colors.transparent],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    stops: [0.01, 1],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      // Indicator
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: List.generate(
                            _sliderImages.isNotEmpty ? _sliderImages.length : 5,
                            (index) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: 10,
                                height: 10,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index == _selectedSlideIndex
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Search Button
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: SliverAppBar(
                  floating: true,
                  snap: true,
                  backgroundColor: _isVisible
                      ? Colors.white
                      : Colors.white.withOpacity(0.95),
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  title: TextButton.icon(
                    onPressed: () {},
                    label: const Text('Search'),
                    icon: const Icon(Icons.search_rounded),
                    style: ButtonStyle(
                      foregroundColor:
                          const WidgetStatePropertyAll(Colors.black),
                      iconSize: const WidgetStatePropertyAll(24),
                      textStyle:
                          const WidgetStatePropertyAll(TextStyle(fontSize: 20)),
                    ),
                  ),
                ),
              ),
            ];
          },
          // Main content
          body: Container(
            color: Colors.white,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    padding: const EdgeInsets.all(12),
                    itemCount: _gridImages.length,
                    itemBuilder: (context, index) {
                      return ImageTile(
                        index: index,
                        imageSource: _gridImages[index],
                        extent: (index % 2) == 0 ? 300 : 150,
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
 */
