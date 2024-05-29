import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/productsModel.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static const String url = 'https://fakestoreapi.com/products';
  static final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      if (kDebugMode) {
        print('Data received from API');
      }
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<List<Product>> fetchHomeProduct() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      if (kDebugMode) {
        print('Data received from API');
      }
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<void> saveProductsToFireStore(List<Product> products) async {
    try {
      await productsCollection.doc('all_products').delete();

      for (var product in products) {
        await productsCollection
            .doc('all_products')
            .collection('items')
            .doc(product.id.toString())
            .set(product.toJson());
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving products to Firestore: $e');
      }
      rethrow;
    }
  }
}
