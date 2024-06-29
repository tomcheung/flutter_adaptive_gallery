import 'package:flutter/material.dart';
import 'package:flutter_adaptive_layout/adaptive_layout_builder.dart';
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
    final child = const PhotoView();

    return Center(
      child: AdaptiveLayoutBuilder(layoutBuilder: (size) {
        final content = switch (size) {
          LayoutSizeData.large =>
            LargeLayout(extendNavigationRail: true, child: child),
          LayoutSizeData.medium =>
            LargeLayout(extendNavigationRail: false, child: child),
          LayoutSizeData.small => SmallLayout(child: child),
        };

        return LayoutSize(size: size, child: content);
      }),
    );
  }
}

class LargeLayout extends StatelessWidget {
  final bool extendNavigationRail;
  final Widget child;

  const LargeLayout(
      {super.key, this.extendNavigationRail = false, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter adaptive gallery')),
      body: Row(
        children: [
          NavigationRail(
            extended: extendNavigationRail,
            destinations: GalleryMainPage.tabs
                .map((t) => NavigationRailDestination(
                    icon: Icon(t.icon), label: Text(t.label)))
                .toList(growable: false),
            selectedIndex: 0,
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1200),
                child: child,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SmallLayout extends StatelessWidget {
  final Widget child;

  const SmallLayout({super.key, required this.child});

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
    final size = LayoutSize.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: PhotoViewHeader()),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Image.network(
                  SampleImage.images[index % SampleImage.images.length],
                  fit: BoxFit.cover),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: size == LayoutSizeData.small ? 2 : 3,
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
    final size = LayoutSize.of(context);
    return switch (size) {
      LayoutSizeData.large => _buildLargeLayout(context),
      LayoutSizeData.medium => _buildMediumLayout(context),
      LayoutSizeData.small => _buildSmallLayout(context),
    };
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
