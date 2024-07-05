import 'package:flutter/material.dart';
import 'package:flutter_adaptive_layout/adaptive_layout.dart';
import 'package:flutter_adaptive_layout/image_details_page.dart';
import 'package:flutter_adaptive_layout/sample_image.dart';

void main() {
  runApp(const AdaptiveGalleryApp());
}

class AdaptiveGalleryApp extends StatelessWidget {
  const AdaptiveGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayoutBuilder(
      layoutBuilder: (size) => LayoutSize(
        size: size,
        child: MaterialApp(
          theme: ThemeData.from(
              colorScheme:
                  ColorScheme.fromSeed(seedColor: const Color(0x8AAD5D5D))),
          home: const GalleryMainPage(),
        ),
      ),
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
    final size = LayoutSize.of(context);
    const child = PhotoView();

    return Center(
      child: switch (size) {
        LayoutSizeData.large =>
          NavigationRailLayout(extendNavigationRail: true, child: child),
        LayoutSizeData.medium =>
          NavigationRailLayout(extendNavigationRail: true, child: child),
        LayoutSizeData.small => TabBarLayout(child: child),
      },
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

class NavigationRailLayout extends StatelessWidget {
  final bool extendNavigationRail;
  final Widget child;

  const NavigationRailLayout(
      {super.key, required this.child, this.extendNavigationRail = true});

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
                        final showFullScreenDialog =
                            LayoutSize.of(context) == LayoutSizeData.small;
                        final dialogContent = ImageDetailsPage(image: image);

                        if (showFullScreenDialog) {
                          return Dialog.fullscreen(
                            child: dialogContent,
                          );
                        } else {
                          return Dialog(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 400),
                                child: dialogContent,
                              ));
                        }
                      });
                },
                child: MouseRegion(
                  child: GalleryImageView(image),
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

class GalleryImageView extends StatefulWidget {
  final String imageUrl;

  const GalleryImageView(this.imageUrl, {super.key});

  @override
  State<GalleryImageView> createState() => _GalleryImageViewState();
}

class _GalleryImageViewState extends State<GalleryImageView> {
  var _scaleEnabled = false;
  @override
  Widget build(BuildContext context) {
    double s = _scaleEnabled ? 1.03 : 1;
    return MouseRegion(
        onEnter: (e) {
          setState(() {
            _scaleEnabled = true;
          });
        },
        onExit: (e) {
          setState(() {
            _scaleEnabled = false;
          });
        },
        child: AnimatedContainer(
          transformAlignment: Alignment.center,
          transform: Matrix4.identity().scaled(s),
          clipBehavior: Clip.antiAlias,
          duration: Duration(milliseconds: 100),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(_scaleEnabled ? 15 : 0)),
          child: Image.network(
            widget.imageUrl,
            fit: BoxFit.cover,
          ),
        ));
  }
}
