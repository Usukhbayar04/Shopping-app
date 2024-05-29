import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/app_state.dart';
import '../const/AppColors.dart';
import '../const/Sizes.dart';
import '../models/productsModel.dart';

class DetailScreen extends StatefulWidget {
  final Product product;
  const DetailScreen({super.key, required this.product});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;
  String _comment = '';
  List<Map<String, dynamic>> comments = [];

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    final appState = Provider.of<ApplicationState>(context, listen: false);
    final fetchedComments =
        await appState.fetchComments(widget.product.id.toString());
    setState(() {
      comments = fetchedComments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Page',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.white_Color,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: AppColors.brand_Color,
                borderRadius: BorderRadius.circular(30),
              ),
              child: GestureDetector(
                child: Center(
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.white : Colors.white,
                    size: 32,
                  ),
                ),
                onTap: () async {
                  await Provider.of<ApplicationState>(context, listen: false)
                      .saveToFavorites(widget.product);
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                },
              ),
            ),
          ),
        ],
        backgroundColor: AppColors.brand_Color,
      ),
      backgroundColor: AppColors.white_Color,
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) {
          if (appState.products.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    widget.product.image,
                    width: 300,
                    height: 300,
                  ),
                  const SizedBox(height: Sizes.fontSizeMedium),
                  Text(
                    widget.product.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: Sizes.fontSizeSmall / 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${widget.product.price}',
                        style: const TextStyle(
                            fontSize: 20, color: AppColors.brand_Color),
                      ),
                    ],
                  ),
                  const SizedBox(height: Sizes.fontSizeSmall / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rating: ${widget.product.rating.rate} (${widget.product.rating.count} reviews)',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: Sizes.fontSizeMedium),
                      GestureDetector(
                        child: const Icon(
                          Icons.comment_outlined,
                          color: Colors.black87,
                          size: 28,
                        ),
                        onTap: () {
                          _showCommentDialog(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: Sizes.fontSizeMedium),
                  Text(
                    widget.product.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: Sizes.fontSizeMedium),
                  const Divider(
                    thickness: 2,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Comments: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments[index];
                          return ListTile(
                            title: Text(comment['comment']),
                            subtitle: Text('User: ${comment['userId']}'),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {
              Provider.of<ApplicationState>(context, listen: false)
                  .addToBasket(widget.product);
            },
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all<Color>(AppColors.brand_Color)),
            child: const Text(
              'ADD TO CART',
              style: TextStyle(
                color: AppColors.white_Color,
                fontWeight: FontWeight.w800,
                fontSize: Sizes.fontSizeMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCommentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Comment'),
          content: TextField(
            onChanged: (value) {
              _comment = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter your comment...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<ApplicationState>(context, listen: false)
                    .addComment(widget.product, _comment);
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
