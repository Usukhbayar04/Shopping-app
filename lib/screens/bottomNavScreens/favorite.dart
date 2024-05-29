import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/const/Sizes.dart';
import '../../app_state.dart';
import '../../const/AppColors.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  void initState() {
    super.initState();
    final appState = Provider.of<ApplicationState>(context, listen: false);
    appState.fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, child) {
        if (appState.favorite.isEmpty) {
          return const Center(
            child: Text(
              'No favorites yet.',
              style: TextStyle(
                fontSize: Sizes.fontSizeMedium,
                color: AppColors.white_Color,
              ),
            ),
          );
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: appState.favorite.length,
            itemBuilder: (context, index) {
              final product = appState.favorite[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      width: 60.0,
                      height: 60.0,
                    ),
                  ),
                  title: Text(
                    product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  subtitle: Text(
                    '\$${product.price}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
