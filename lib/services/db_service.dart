import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/productsModel.dart';

const String PROCUCT_COLLECTION_REF = 'products';

class DbService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _productRef;

  DbService() {
    _productRef =
        _firestore.collection(PROCUCT_COLLECTION_REF).withConverter<Product>(
              fromFirestore: (snapshorts, _) =>
                  Product.fromJson(snapshorts.data()!),
              toFirestore: (product, _) => product.toJson(),
            );
  }

  Stream<QuerySnapshot> getProducts() {
    return _productRef.snapshots();
  }

  Future<void> addProduct(Product product) async {
    await _productRef.add(product.toJson());
  }
}
