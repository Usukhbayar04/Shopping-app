import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/const/AppColors.dart';
import '../../app_state.dart';
import '../../const/Sizes.dart';
import '../../models/productsModel.dart';
import '../../services/productService.dart';
import '../detail_screen.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = ProductService.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.brandOp_Color),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          iconSize: 32,
                          color: AppColors.white_Color,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          color: AppColors.white_Color,
                        ),
                        child: Image.asset(
                          'assets/images/logoDark.png',
                          height: 50,
                          fit: BoxFit.fitHeight,
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
                  Sizes.sizedBoxSmall,
                  // Scroll images
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Items',
                            style: TextStyle(
                              color: AppColors.white_Color,
                              fontSize: Sizes.fontSizeMedium,
                            ),
                          ),
                          Text(
                            'Available in stock',
                            style: TextStyle(
                              color: AppColors.whiteOp_Color,
                              fontSize: Sizes.fontSizeSmall1,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.sort, color: AppColors.white_Color),
                          SizedBox(width: 3),
                          Text(
                            'Sort',
                            style: TextStyle(
                              color: AppColors.white_Color,
                              fontSize: Sizes.fontSizeMedium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Sizes.sizedBoxSmall,
                  // Products fetch from API
                  Expanded(child: buildProductList(context, snapshot)),
                ],
              ),
            ),
          );
        },
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
  final Product product;

  const ProductCart({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.product,
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
                    child: GestureDetector(
                      child: const Icon(
                        Icons.favorite_border_outlined,
                      ),
                      onTap: () {
                        Provider.of<ApplicationState>(context, listen: false)
                            .saveToFavorites(product);
                      },
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
