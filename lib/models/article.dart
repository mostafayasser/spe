import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:timeago/timeago.dart' as timeago;
class Article {
  String imagePath, pdfPath, title, authorName;
  List<dynamic> tags = [];
  String duration;
  Article(
      {this.authorName,
      this.duration,
      this.imagePath,
      this.pdfPath,
      this.tags,
      this.title});
}

List<Article> _articles = [];



final Firestore _firestore = Firestore.instance;

Future<void> fetchArticles() async {
  String img , pdf;
  Timestamp time;
  FirebaseStorage db = FirebaseStorage.instance;
  StorageReference storageRef = db.ref();
  QuerySnapshot allDocuments =
      await _firestore.collection('articles').getDocuments();
  allDocuments.documents.forEach((doc){
    storageRef.child(doc.data["imagePath"]).getDownloadURL().then((result) {
      img = result;
      storageRef.child(doc.data["pdfPath"]).getDownloadURL().then((res){
        pdf = res;
      });
      time = doc.data["time"];
      DateTime duration = time.toDate();
      
      _articles.add(Article(
        authorName: doc.data["authorName"],
        imagePath: img ,
        pdfPath: pdf ,
        tags: doc.data["tags"],
        duration: timeago.format(duration),
        title: doc.data["title"]
        ));
    });
    
  });

}

List<Article> get articles {
  fetchArticles();

  return _articles;
}

