import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping_app/models/productsModel.dart';
import 'services/productService.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  User? user;
  List<Product> _products = [];
  List<Product> get products => _products;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> init() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        _loggedIn = false;
      } else {
        this.user = user;
        _loggedIn = true;
        fetchProductsFromApi();
      }
      notifyListeners();
    });

    if (_auth.currentUser == null) {
      await _auth.signInAnonymously();
    }
  }

  // Fetch api
  Future<void> fetchProductsFromApi() async {
    try {
      _products = await ProductService.fetchProducts();
      notifyListeners();
      await ProductService.saveProductsToFireStore(_products);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching products: $e');
      }
    }
  }

  // Add to basket
  Future<void> addToBasket(Product product) async {
    if (user != null) {
      final basketCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('basket');
      await basketCollection.doc(product.id.toString()).set(product.toJson());
    }
  }

  List<Product> _favorites = [];
  List<Product> get favorite => _favorites;

  Future<void> fetchFavorites() async {
    if (user != null) {
      final favoritesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('favorites');

      final querySnapshot = await favoritesCollection.get();
      _favorites = querySnapshot.docs
          .map((doc) => Product.fromJson(doc.data()))
          .toList();
      notifyListeners();
    }
  }

  // Add to favorites
  Future<void> saveToFavorites(Product product) async {
    if (user != null) {
      final favoritesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('favorites');
      await favoritesCollection
          .doc(product.id.toString())
          .set(product.toJson());
    }
  }

  // Add to comments
  Future<void> addComment(Product product, String comment) async {
    if (user != null) {
      final commentsCollection = FirebaseFirestore.instance
          .collection('products')
          .doc(product.id.toString())
          .collection('comments');
      await commentsCollection.add({
        'userId': user!.uid,
        'comment': comment,
        'timestamp': Timestamp.now(),
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchComments(String productId) async {
    final commentsCollection = FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .collection('comments');

    final querySnapshot = await commentsCollection.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}
