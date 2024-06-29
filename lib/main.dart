import 'package:flutter/material.dart';
import 'package:flutter_adaptive_layout/image_details_page.dart';
import 'package:flutter_adaptive_layout/sample_image.dart';

void main() {
  runApp(const AdaptiveGalleryApp());
}

class AdaptiveGalleryApp extends StatelessWidget {
  const AdaptiveGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
          colorScheme:
              ColorScheme.fromSeed(seedColor: const Color(0x8AAD5D5D))),
      home: const GalleryMainPage(),
    );
  }
}

class GalleryMainPage extends StatefulWidget {
  static final tabs = [
    (icon: Icons.home, label: 'Home'),
    (icon: Icons.photo, label: 'Photo'),
  ];

  const GalleryMainPage({super.key});

  @override
  State<GalleryMainPage> createState() => _HomeState();
}

class _HomeState extends State<GalleryMainPage> {
  @override
  Widget build(BuildContext context) {
    const child = PhotoView();

    return Center(
      child: TabBarLayout(child: child),
    );
  }
}

class TabBarLayout extends StatelessWidget {
  final Widget child;

  const TabBarLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter adaptive gallery')),
      bottomNavigationBar: BottomNavigationBar(
        items: GalleryMainPage.tabs
            .map((t) =>
                BottomNavigationBarItem(icon: Icon(t.icon), label: t.label))
            .toList(growable: false),
      ),
      body: child,
    );
  }
}

class PhotoView extends StatefulWidget {
  const PhotoView({super.key});

  @override
  State<PhotoView> createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: PhotoViewHeader()),
          SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              String image =
                  SampleImage.images[index % SampleImage.images.length];
              return GestureDetector(
                onTap: () {
                  // Show adaptive dialog when click the image
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        final dialogContent = ImageDetailsPage(image: image);
                        return Dialog(
                          child: dialogContent,
                        );
                      });
                },
                child: FocusableActionDetector(
                  child: Image.network(image, fit: BoxFit.cover),
                ),
              );
            }),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
          )
        ],
      ),
    );
  }
}

class PhotoViewHeader extends StatelessWidget {
  const PhotoViewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSmallLayout(context);
  }

  Widget _buildSmallLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: AspectRatio(
          aspectRatio: 1,
          child: Image.network(SampleImage.image1, fit: BoxFit.cover)),
    );
  }

  Widget _buildMediumLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AspectRatio(
        aspectRatio: 3 / 2,
        child: Row(
          children: [
            AspectRatio(
                aspectRatio: 1,
                child: Image.network(SampleImage.image1, fit: BoxFit.cover)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.network(SampleImage.image2, fit: BoxFit.cover),
                  ),
                  Expanded(
                    child: Image.network(SampleImage.image3, fit: BoxFit.cover),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AspectRatio(
        aspectRatio: 1.2,
        child: SizedBox(
          // height: 500,
          child: Row(
            children: [
              Flexible(
                  flex: 3,
                  child: Column(
                    children: [
                      AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(SampleImage.image1,
                              fit: BoxFit.cover)),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                                child: Image.network(SampleImage.image2,
                                    fit: BoxFit.cover)),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Image.network(SampleImage.image3,
                                    fit: BoxFit.cover)),
                          ],
                        ),
                      )
                    ],
                  )),
              const SizedBox(width: 12),
              Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.network(
                          SampleImage.image4,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Image.network(
                          SampleImage.image2,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
