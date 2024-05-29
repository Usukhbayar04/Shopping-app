import 'package:flutter/material.dart';
import '../../const/AppColors.dart';
import '../../const/Sizes.dart';
import '../../models/productsModel.dart';
import '../../services/productService.dart';
import '../detail_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = ProductService.fetchHomeProduct();
  }

  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Sizes.sizedBoxMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.brandOp_Color),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.menu,
                          size: 32,
                          color: AppColors.white_Color,
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.brandOp_Color,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.notifications_none,
                          size: 32,
                          color: AppColors.white_Color,
                        ),
                      ),
                    ),
                  ],
                ),
                Sizes.sizedBoxMedium,
                // User name
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Usukhbayar',
                      style: TextStyle(
                        fontSize: 28,
                        color: AppColors.white_Color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Welcome to Free Spirit',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.whiteOp_Color,
                      ),
                    ),
                  ],
                ),
                Sizes.sizedBoxMedium,
                // Search
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextFormField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.5,
                              ),
                            ),
                            hintText: 'Search...',
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: AppColors.whiteOp_Color,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppColors.whiteOp_Color,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: AppColors.brand_Color,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.bottom_Color,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.mic_none,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                Sizes.sizedBoxMedium,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New Arrival',
                      style: TextStyle(
                        color: AppColors.white_Color,
                        fontSize: Sizes.fontSizeLarge,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'View All',
                      style: TextStyle(
                        color: AppColors.whiteOp_Color,
                        fontSize: Sizes.fontSizeSmall1,
                      ),
                    ),
                  ],
                ),
                Sizes.sizedBoxMedium,
                FutureBuilder<List<Product>>(
                  future: futureProducts,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Бүтээгдэхүүнийг ачаалж чадсангүй'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Бүтээгдэхүүн байхгүй байна.'),
                      );
                    } else {
                      List<Product> products = snapshot.data!;
                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        children: List.generate(products.length, (index) {
                          Product product = products[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailScreen(product: product),
                                  ),
                                );
                              },
                              child: ProductCart(
                                image: product.image,
                                title: product.title,
                                price: product.price,
                                rating: product.rating.rate,
                                reviewCount: product.rating.count,
                                product: product,
                              ),
                            ),
                          );
                        }),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Returns a list of products
Widget buildProductList(
    BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  } else if (snapshot.hasError) {
    return const Center(
      child: Text('Бүтээгдэхүүнийг ачаалж чадсангүй'),
    );
  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
    return const Center(
      child: Text('Бүтээгдэхүүн байхгүй байна.'),
    );
  } else {
    List<Product> products = snapshot.data!;
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(products.length, (index) {
        Product product = products[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(product: product),
                ),
              );
            },
            child: ProductCart(
              image: product.image,
              title: product.title,
              price: product.price,
              rating: product.rating.rate,
              reviewCount: product.rating.count,
              product: product,
            ),
          ),
        );
      }),
    );
  }
}

class ProductCart extends StatelessWidget {
  final String image;
  final String title;
  final double price;
  final double rating;
  final int reviewCount;

  const ProductCart({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required Product product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              child: Stack(
                children: [
                  Image.network(
                    image,
                    width: double.infinity,
                    fit: BoxFit.fitHeight,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.favorite_border,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '\$$price',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
