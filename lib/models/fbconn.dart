import 'package:firebase_database/firebase_database.dart';
import 'package:girlies/app/data.dart';

class FbConn {
  Map objectData = new Map();

  FbConn(this.objectData);

  int getDataSize() {
    int size = objectData.keys.length;
    return size;
  }

  Object getValue(String key) {
    Object value;
    for (int s = 0; s < objectData.keys.length; s++) {
      value = objectData[objectData.keys.elementAt(s)][key];
    }
    return value == null ? "" : value;
  }

  String getKeyID() {
    Object value;
    for (int s = 0; s < objectData.keys.length; s++) {
      value = objectData[objectData.keys.elementAt(s)][AppData.keyID];
    }
    return value == null ? "" : value.toString();
  }

  String getFullName() {
    Object value = objectData[AppData.fullName];
    return value == null ? "" : value.toString();
  }

  String getAddress() {
    Object value = objectData[AppData.deliveryAddress];
    return value == null ? "" : value.toString();
  }

  String getState() {
    Object value = objectData[AppData.state];
    return value == null ? "" : value.toString();
  }

  String getHomeAddress() {
    Object value = objectData[AppData.homeAddress];
    return value == null ? "" : value.toString();
  }

  String getHomeDescription() {
    Object value = objectData[AppData.homeDescription];
    return value == null ? "" : value.toString();
  }

  String getPhoneNumber() {
    Object value = objectData[AppData.phoneNumber];
    return value == null ? "" : value.toString();
  }

  String getEmail() {
    Object value = objectData[AppData.email];
    return value == null ? "" : value.toString();
  }

  String getPassword() {
    Object value = objectData[AppData.password];
    return value == null ? "" : value.toString();
  }

  String getProfileImage() {
    Object value = objectData[AppData.profileImgURL];
    return value == null ? "" : value.toString();
  }

  String getUserID() {
    Object value = objectData[AppData.userID];
    return value == null ? "" : value.toString();
  }

  List<String> getKeyIDasList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.keyID]);
    }
    return value;
  }

  List<String> getAdminMessageSenderIDasList() {
    List<String> value = new List();
    int lastItem;
    for (int s = 0; s < objectData.keys.length; s++) {
      //Map val = objectData[objectData.keys.elementAt(s)];
      Map map1 = objectData[objectData.keys.elementAt(s)];
      lastItem = map1.keys.length - 1;
      Map map2 = map1[map1.keys.elementAt(lastItem)];
      value.add(map2[AppData.messageSenderUID]);
    }
    return value;
  }

  List<String> getAdminMessageSenderImage() {
    List<String> value = new List();
    int lastItem;
    for (int s = 0; s < objectData.keys.length; s++) {
      //Map val = objectData[objectData.keys.elementAt(s)];
      Map map1 = objectData[objectData.keys.elementAt(s)];
      lastItem = map1.keys.length - 1;
      Map map2 = map1[map1.keys.elementAt(lastItem)];
      value.add(map2[AppData.messageSenderImage]);
    }
    return value;
  }

  List<String> getAdminMessageTextasList() {
    List<String> value = new List();
    int lastItem;
    for (int s = 0; s < objectData.keys.length; s++) {
      //Map val = objectData[objectData.keys.elementAt(s)];
      Map map1 = objectData[objectData.keys.elementAt(s)];
      lastItem = map1.keys.length - 1;
      Map map2 = map1[map1.keys.elementAt(lastItem)];
      value.add(map2[AppData.messageText]);
    }
    return value;
  }

  List<String> getAdminSenderNameAsList() {
    List<String> value = new List();
    int lastItem;
    for (int s = 0; s < objectData.keys.length; s++) {
      //Map val = objectData[objectData.keys.elementAt(s)];
      Map map1 = objectData[objectData.keys.elementAt(s)];
      lastItem = map1.keys.length - 1;
      Map map2 = map1[map1.keys.elementAt(lastItem)];
      value.add(map2[AppData.messageSenderName]);
    }
    return value;
  }

  List<int> getAdminMessageTimeAsList() {
    List<int> value = new List();
    int lastItem;
    for (int s = 0; s < objectData.keys.length; s++) {
      //Map val = objectData[objectData.keys.elementAt(s)];
      Map map1 = objectData[objectData.keys.elementAt(s)];
      lastItem = map1.keys.length - 1;
      Map map2 = map1[map1.keys.elementAt(lastItem)];
      value.add(map2[AppData.messageTime]);
    }
    return value;
  }

  List<String> getMessageIDasList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageID]);
    }
    return value;
  }

  List<String> getMessageKeyIDasList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageKeyID]);
    }
    return value;
  }

  List<String> getMessageSenderIDasList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageSenderUID]);
    }
    return value;
  }

  List<String> getMessageReceiverIDasList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageReceiverUID]);
    }
    return value;
  }

  List<String> getMessageSenderNameAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageSenderName]);
    }
    return value;
  }

  List<String> getOrderSenderNameAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.orderSenderName]);
    }
    return value;
  }

  List<String> getFullNameAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.fullName]);
    }
    return value;
  }

  List<String> getProfileImgAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.profileImgURL]);
    }
    return value;
  }

  List<String> getEmailAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.email]);
    }
    return value;
  }

  List<String> getPhoneAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.phoneNumber]);
    }
    return value;
  }

  List<String> getPasswordAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.password]);
    }
    return value;
  }

  List<String> getOrderSenderImgAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.orderSenderImg]);
    }
    return value;
  }

  List<int> getOrderAmountAsList() {
    List<int> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.orderAmount]);
    }
    return value;
  }

  List<String> getOrderNoAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.noOforders]);
    }
    return value;
  }

  List<int> getOrderTimeAsList() {
    List<int> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.orderTime]);
    }
    return value;
  }

  List<String> getOrderTypeAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.orderType]);
    }
    return value;
  }

  List<String> getMessageTextAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageText]);
    }
    return value;
  }

  List<int> getMessageTimeAsList() {
    List<int> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageTime]);
    }
    return value;
  }

  List<bool> getMessageSeen() {
    List<bool> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageSeen]);
    }
    return value;
  }

  List<bool> getMessageRead() {
    List<bool> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageRead]);
    }
    return value;
  }

  List<String> getSenderImageAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageSenderImage]);
    }
    return value;
  }

  List<String> getSenderEmailAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.messageSenderEmail]);
    }
    return value;
  }

  void addIsFavorite(bool isFavorite) {
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      val[AppData.isFavorite] = isFavorite == null ? false : isFavorite;
      /* String key = val[AppData.keyID];
      val.putIfAbsent(key, () {
        return val[AppData.isFavorite] = isFavorite;
      });*/
    }
  }

  void addIsFavoriteIndex(bool isFavorite, int index) {
    Map val = objectData[objectData.keys.elementAt(index)];
    val[AppData.isFavorite] = isFavorite == null ? false : isFavorite;
  }

  void loadFavorite(String key) {
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      if (val[AppData.keyID] == key) {
        addIsFavoriteIndex(true, s);
        print(key);
      }
    }
  }

  void addFavorite(bool isFavorite, int index) {
    Map val = objectData[objectData.keys.elementAt(index)];
    val[AppData.isFavorite] = isFavorite;

    FirebaseDatabase.instance
        .reference()
        .child(AppData.favoriteDB)
        .child(AppData.currentUserID)
        .child(val[AppData.keyID])
        .set(val)
        .catchError((e) {
      print("Error Occured : $e");
    });
  }

  void removeFavorite(int index) {
    Map val = objectData[objectData.keys.elementAt(index)];
    val[AppData.isFavorite] = false;
    FirebaseDatabase.instance
        .reference()
        .child(AppData.favoriteDB)
        .child(AppData.currentUserID)
        .child(val[AppData.keyID])
        .remove()
        .catchError((e) {
      print("Error Occured : $e");
    });
  }

  void removeFavorite1(int index) {
    Map val = objectData[objectData.keys.elementAt(index)];
    String key = val[AppData.keyID];
    val.remove(key);
    val[AppData.isFavorite] = false;
    FirebaseDatabase.instance
        .reference()
        .child(AppData.favoriteDB)
        .child(AppData.currentUserID)
        .child(val[AppData.keyID])
        .remove()
        .catchError((e) {
      print("Error Occured : $e");
    });
  }

  void addToCart(int index, int quantity) {
    Map val = objectData[objectData.keys.elementAt(index)];
    val[AppData.itemQuantity] = quantity;
    FirebaseDatabase.instance
        .reference()
        .child(AppData.cartDB)
        .child(AppData.currentUserID)
        .child(val[AppData.keyID])
        .set(val)
        .catchError((e) {
      print("Error Occured : $e");
    });
  }

  void removeFromCart(int index) {
    Map val = objectData[objectData.keys.elementAt(index)];
    String key = val[AppData.keyID];
    val.remove(key);
    val[AppData.isFavorite] = false;
    FirebaseDatabase.instance
        .reference()
        .child(AppData.cartDB)
        .child(AppData.currentUserID)
        .child(val[AppData.keyID])
        .remove()
        .catchError((e) {
      print("Error Occured : $e");
    });
  }

  String getProductName() {
    Object value;
    for (int s = 0; s < /*objectData.keys.length*/ getDataSize(); s++) {
      value = objectData[objectData.keys.elementAt(0)][AppData.productName];
    }
    return value == null ? "" : value.toString();
  }

  List<bool> getIsFavoriteAsList() {
    List<bool> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.isFavorite]);
    }
    return value;
  }

  List<String> getProductNameAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.productName]);
    }
    return value;
  }

  List<String> getCategoryNameAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.categoryName]);
    }
    return value;
  }

  List<String> getCategoryImageAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.categoryImgURL]);
    }
    return value;
  }

  List<String> getProductNoInStockAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.productNoInStock]);
    }
    return value;
  }

  List<int> getItemQuantityAsList() {
    List<int> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.itemQuantity]);
    }
    return value;
  }

  List<String> getProductPriceAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.productPrice]);
    }
    return value;
  }

  double getTotalProductPrice() {
    double value = 0.0;
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      int quantity = num.parse(val[AppData.itemQuantity].toString());
      value = value + (double.parse(val[AppData.productPrice]) * quantity);
    }
    return value.roundToDouble();
  }

  double getAdminTotalProductPrice() {
    double value = 0.0;
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      int quantity = num.parse(val[AppData.noOforders].toString());
      value = value + (val[AppData.orderAmount] * quantity);
    }
    return value.roundToDouble();
  }

  List<String> getProductSizesAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.productSizesAvailable]);
    }
    return value;
  }

  List<String> getProductColorsAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.productColorsAvailable]);
    }
    return value;
  }

  Map getListMap() {
    Map value = this.objectData;
    return value;
  }

  List<String> getProductCategoryAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      value.add(val[AppData.categoryName]);
    }
    return value;
  }

  String getProductPrice() {
    Object value;
    for (int s = 0; s < objectData.keys.length; s++) {
      value = objectData[objectData.keys.elementAt(s)][AppData.productPrice];
    }
    return value == null ? "" : value.toString();
  }

  String getProductCategory() {
    Object value;
    for (int s = 0; s < objectData.keys.length; s++) {
      value =
          objectData[objectData.keys.elementAt(s)][AppData.productCategories];
    }
    return value == null ? "" : value.toString();
  }

  String getCategoryName() {
    Object value;
    for (int s = 0; s < objectData.keys.length; s++) {
      value = objectData[objectData.keys.elementAt(s)][AppData.categoryName];
    }
    return value == null ? "" : value.toString();
  }

  String getCategoryIMG() {
    Object value;
    for (int s = 0; s < objectData.keys.length; s++) {
      value = objectData[objectData.keys.elementAt(s)][AppData.categoryImgURL];
    }
    return value == null ? "" : value.toString();
  }

  String getProductColors() {
    Object value;
    for (int s = 0; s < objectData.keys.length; s++) {
      value = objectData[objectData.keys.elementAt(s)]
          [AppData.productColorsAvailable];
    }
    return value == null ? "" : value.toString();
  }

  String getProductSizes() {
    Object value;
    for (int s = 0; s < objectData.keys.length; s++) {
      value = objectData[objectData.keys.elementAt(s)]
          [AppData.productSizesAvailable];
    }
    return value == null ? "" : value.toString();
  }

  String getProductNoInStock() {
    Object value;
    for (int s = 0; s < objectData.keys.length; s++) {
      value =
          objectData[objectData.keys.elementAt(s)][AppData.productNoInStock];
    }
    return value == null ? "" : value.toString();
  }

  String getDefaultIMG() {
    Object value;
    for (int s = 0; s < objectData.keys.length; s++) {
      String data = objectData[objectData.keys.elementAt(s)]
              [AppData.productImagesURL]
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "");
      List<String> dataList = data.split(",").toList();
      value = dataList[0];
    }
    return value == null ? "" : value.toString();
  }

  List<String> getDefaultIMGAsList() {
    List<String> value = new List();
    for (int s = 0; s < objectData.keys.length; s++) {
      Map val = objectData[objectData.keys.elementAt(s)];
      List<String> data = val[AppData.productImagesURL]
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "")
          .split(",")
          .toList();

      value.add(data[0]);
    }
    return value == null ? "" : value;
  }

  String getDefaultIMG2() {
    Object value;
    for (int s = 0; s < objectData.keys.length; s++) {
      String data = objectData[objectData.keys.elementAt(s)]
              [AppData.productImagesURL]
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "");
      List<String> dataList = data.split(", ").toList();
      value = dataList[1];
    }
    return value == null ? "" : value.toString();
  }

  String getDefaultIMG3() {
    Object value;
    for (int s = 0; s < objectData.keys.length; s++) {
      String data = objectData[objectData.keys.elementAt(s)]
              [AppData.productImagesURL]
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "");
      List<String> dataList = data.split(", ").toList();
      value = dataList[2];
    }
    return value == null ? "" : value.toString();
  }

  String getDefaultIMG4() {
    Object value;
    for (int s = 0; s < objectData.keys.length; s++) {
      String data = objectData[objectData.keys.elementAt(s)]
              [AppData.productImagesURL]
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "");
      List<String> dataList = data.split(", ").toList();
      value = dataList[3];
    }
    return value == null ? "" : value.toString();
  }

  List<Map> getUserInfo(String userid) {
    List<Map> map;
    Map user = new Map();
    FirebaseDatabase.instance
        .reference()
        .child(AppData.userDB)
        .child(userid)
        .once()
        .then((snapshot) {
      Map value = snapshot.value;
      user[AppData.profileImgURL] = value[AppData.profileImgURL];
      user[AppData.fullName] = value[AppData.fullName];
      map.addAll(user.values);
    });
    return map;
  }

  String getUserNameAt(int s) {
    List<String> userIDS = new List();
    objectData.keys.forEach((value) {
      userIDS.add(value);
    });
    String fullname;

    FirebaseDatabase.instance
        .reference()
        .child(AppData.userDB)
        .child(userIDS[s])
        .once()
        .then((snapshot) {
      Map value = snapshot.value;
      fullname = value[AppData.fullName];
    });
    return fullname;
  }

  String getUserIMGAt(String userid) {
    String profileIMG;
    FirebaseDatabase.instance
        .reference()
        .child(AppData.userDB)
        .child(userid)
        .once()
        .then((snapshot) {
      Map value = snapshot.value;
      profileIMG = value[AppData.profileImgURL];
    });
    return profileIMG;
  }
}
