import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageTile extends StatelessWidget {
  final String imageSource;
  final String photographerName;
  final String photographerUrl;
  final int index;
  final double extent;

  const ImageTile({
    super.key,
    required this.imageSource,
    required this.photographerName,
    required this.photographerUrl,
    required this.index,
    required this.extent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showImageDetails(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        height: extent,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageSource,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Center(
                child: Icon(Icons.broken_image, color: Colors.red, size: 50),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.7),
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        photographerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40, // Make icon easier to tap
                      child: InkWell(
                        onTap: () {
                          // Handle favorite action (e.g., add to favorites)
                          print("Favorite tapped");
                        },
                        child: const Icon(
                          Icons.favorite_outline,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show Image Details in Bottom Sheet
  void showImageDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: SingleChildScrollView(
            // Prevent overflow on small screens
            child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: imageSource,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child:
                        Icon(Icons.broken_image, color: Colors.red, size: 50),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    photographerName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final Uri url = Uri.parse(photographerUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  child: const Text(
                    'View Profile on Pexels',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
