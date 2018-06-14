enum productData {
  PRODUCT_TITLE,
  PRODUCT_PRICE,
  PRODUCT_IMAGE,
  PRODUCT_CATEGORY,
  SIZES_AVAILABLE,
  COLORS_AVAILABLE,
  NO_IN_STOCK
}

class Base {
  //for products
  final String productTitle;
  final String productImgURL;
  final String productCategory;
  final double productPrice;
  final String sizesAvaliable;
  final String colorsAvaliable;
  final int noInStock;
  int itemQuantity;
  bool isFavorite;
  final double totalOrderAmount;
  final int totalOrder;
  final String orderTime;

  //for messages
  String senderName;
  String senderImgUrl;
  String messageTime;
  String messageSent;

  Base.messages(
      {this.productTitle,
      this.productImgURL,
      this.productCategory,
      this.productPrice,
      this.sizesAvaliable,
      this.colorsAvaliable,
      this.noInStock,
      this.senderName,
      this.senderImgUrl,
      this.messageTime,
      this.messageSent,
      this.orderTime,
      this.totalOrder,
      this.totalOrderAmount});

  Base.adminOrder(
      {this.productTitle,
      this.productImgURL,
      this.productCategory,
      this.productPrice,
      this.sizesAvaliable,
      this.colorsAvaliable,
      this.noInStock,
      this.senderName,
      this.senderImgUrl,
      this.messageTime,
      this.messageSent,
      this.orderTime,
      this.totalOrder,
      this.totalOrderAmount});

  Base.products(
      {this.productTitle,
      this.productImgURL,
      this.productCategory,
      this.productPrice,
      this.sizesAvaliable,
      this.colorsAvaliable,
      this.noInStock,
      this.itemQuantity,
      this.isFavorite,
      this.orderTime,
      this.totalOrder,
      this.totalOrderAmount});

  buildDemoProducts() {
    return <Base>[
      Base.products(
          productTitle: "Hanging Top",
          productImgURL:
              "https://ng.jumia.is/VApm0veICYc9j3CezbjKYS-ILZQ=/fit-in/680x680/filters:fill(white):sharpen(1,0,false):quality(100)/product/33/433921/1.jpg?5319",
          productCategory: "Clothings",
          productPrice: 1999.0,
          sizesAvaliable: "30,35,40,45",
          colorsAvaliable: "red, yellow, blue, green",
          itemQuantity: 1,
          isFavorite: true),
      Base.products(
          productTitle: "Cool Top",
          productImgURL:
              "https://ng.jumia.is/udgp_Blaamps7xCq9fK0GnUl-qI=/fit-in/680x680/filters:fill(white):sharpen(1,0,false):quality(100)/product/98/95129/1.jpg?4928",
          productCategory: "Clothings",
          productPrice: 1499.0,
          sizesAvaliable: "30,35,40,45",
          colorsAvaliable: "red, yellow, blue, green",
          itemQuantity: 1,
          isFavorite: false),
      Base.products(
          productTitle: "Nam Top",
          productImgURL:
              "https://ng.jumia.is/mQ3YbOAjg4C3mOPbM_MJnzbLBSY=/fit-in/220x220/filters:fill(white):sharpen(1,0,false):quality(100)/product/71/25558/1.jpg?8298",
          productCategory: "Clothings",
          productPrice: 2499.0,
          sizesAvaliable: "30,35,40,45",
          colorsAvaliable: "red, yellow, blue, green",
          itemQuantity: 1,
          isFavorite: false),
      Base.products(
          productTitle: "Butterfly Blowse",
          productImgURL:
              "https://ng.jumia.is/xcOop8mgvmECLlvF9rZnFQ4zArk=/fit-in/220x220/filters:fill(white):sharpen(1,0,false):quality(100)/product/65/81907/1.jpg?2688",
          productCategory: "Clothings",
          productPrice: 1399.0,
          sizesAvaliable: "30,35,40,45",
          colorsAvaliable: "red, yellow, blue, green",
          itemQuantity: 1,
          isFavorite: true),
      Base.products(
          productTitle: "Pink Rose T-Shirt",
          productImgURL:
              "https://ng.jumia.is/1n78ijDwgfwRABxnjvczt3xlKsY=/fit-in/220x220/filters:fill(white):sharpen(1,0,false):quality(100)/product/10/117311/1.jpg?0588",
          productCategory: "Clothings",
          productPrice: 2999.0,
          sizesAvaliable: "30,35,40,45",
          colorsAvaliable: "red, yellow, blue, green",
          itemQuantity: 1,
          isFavorite: false),
    ];
  }

  buildDemoMessages() {
    return <Base>[
      Base.messages(
          senderName: "Esther Tony",
          senderImgUrl:
              "https://scontent.flos2-1.fna.fbcdn.net/v/t1.0-1/p160x160/20604540_1805020276474894_7050122777360916994_n.jpg?_nc_cat=0&_nc_eui2=AeEt4x3EaHkY_Qiuu86YBWBa-MXLvoSTZK9DdJiSaUSENzv40Zb2UtfnV-iC56oI2ZW7ytTGQ37FuQBmkyoyw1p4OSCU-G9XeiUyVktuWG5wYQ&oh=2a9585ff5d8ce839d75dd3c2e4b81028&oe=5B774047",
          messageTime: "10 mins ago",
          messageSent: "Hello , how long does it take to delver ?"),
      Base.messages(
          senderName: "Judith Ukonu",
          senderImgUrl:
              "https://scontent.flos2-1.fna.fbcdn.net/v/t1.0-1/c0.0.160.160/p160x160/21270793_2355653891326918_4378932577050204161_n.jpg?_nc_cat=0&_nc_eui2=AeHyfkw_N21ybktUCQ-fZElTthGbfh8XD2jXap7zawLLM03GKut-GRVfMrOpAwhX-OMZ_JJnFVGVV8u8yyCyJj16-oOHqa5S1e0v_igSJfa82g&oh=9552e870852f1391a1eb876adf4eef31&oe=5B932659",
          messageTime: "15 mins ago",
          messageSent: "How, Do i check my history?"),
      Base.messages(
          senderName: "Anih Ann",
          senderImgUrl:
              "https://scontent.flos2-1.fna.fbcdn.net/v/t1.0-1/p160x160/32155288_1719889604754287_8806466055422607360_n.jpg?_nc_cat=0&_nc_eui2=AeHWqFDGD-265FIeaGCEnWLCju7clrZqDTzCW1HctfYMsyGUqY71EMvStacPLYZr9E9JrQ3jK8u9i-13Z7Sv_z6SxCzp5uADz3YkZJBrBk5fiw&oh=cde8b9a8e7083c7b1d58017112e87e17&oe=5BC13166",
          messageTime: "20 mins ago",
          messageSent: "Please , i'd want to add to my previous order"),
      Base.messages(
          senderName: "Nkechi Odionu",
          senderImgUrl:
              "https://scontent.flos2-1.fna.fbcdn.net/v/t1.0-1/c27.0.160.160/p160x160/10001307_1374857406125629_940003785_n.jpg?_nc_cat=0&_nc_eui2=AeG4aM-rrzySJtEVqFwxOU1AWug_215ObQ1wq6g9j2MX6cpqBeWVBpwdB1ujWNP8JzppDFpyorLVd4SVpf9-4uaOmdtXLINAQiOLzf6idtghvw&oh=ad4bdc53d31360fb227cbf0678b0795a&oe=5BC0FC59",
          messageTime: "25 mins ago",
          messageSent: "Do you guys accept pay on delivery?"),
      Base.messages(
          senderName: "Joy Esther",
          senderImgUrl:
              "https://scontent.flos2-1.fna.fbcdn.net/v/t1.0-1/p160x160/30738456_179742519504398_1148078082872049664_n.jpg?_nc_cat=0&_nc_eui2=AeGgdM9U_-vjewqK9I4pAX0zBiVmEwEpGXVzPLiNPAlgrPhIJ9MYl3Pxx14GhkqFzgODD0KNTFzRWGxm2_lGKSce3wMXcIjEA50_V1YAtbw83Q&oh=6dd8457f6cb8568c1a7eac96be903a21&oe=5B975259",
          messageTime: "30 mins ago",
          messageSent:
              "Please, your is Girlie Classics is out of stock, when would it be instock?"),
      Base.messages(
          senderName: "Chidinma Iwuajoku",
          senderImgUrl:
              "https://scontent.flos2-1.fna.fbcdn.net/v/t1.0-1/p160x160/17424740_1154743711315225_839220400350401501_n.jpg?_nc_cat=0&_nc_eui2=AeGyjEA1gqMXWlTQ6L-K6DDfmf4-h1sk0m_bElpHTUXAabGkVuxe2kJW6VN-tjoI0BWKVYao9hG25SIj5e4t0bBZFUAY_lSsys5Kl6YfWSWP0Q&oh=f1e53dfe610dfd2c3067555eb06f8ffd&oe=5B81D565",
          messageTime: "35 mins ago",
          messageSent: "When you guys add, jeweries to your boutique?"),
      Base.messages(
          senderName: "Nancy Chinecherem",
          senderImgUrl:
              "https://scontent.flos2-1.fna.fbcdn.net/v/t1.0-1/c0.0.160.160/p160x160/32584480_2054922424827961_1941670558932402176_n.jpg?_nc_cat=0&_nc_eui2=AeFFObFhSdAkbLIw3UXa-vfJNzQ32clTLpE-9sQH6Xbpw8R8py8qiLRvHMdcUDK-Eu6lC-o4LM5ognEaic4EvaXmgrmu88bQZwYPms1IPPwrIA&oh=b33e3b38c564b7d29b6cb1867a34f4aa&oe=5B8E1F08",
          messageTime: "40 mins ago",
          messageSent: "Received my goods thanks..."),
    ];
  }

  buildDemoAdminOrder() {
    return <Base>[
      Base.adminOrder(
          senderName: "Esther Tony",
          senderImgUrl:
              "https://scontent.flos2-1.fna.fbcdn.net/v/t1.0-1/p160x160/20604540_1805020276474894_7050122777360916994_n.jpg?_nc_cat=0&_nc_eui2=AeEt4x3EaHkY_Qiuu86YBWBa-MXLvoSTZK9DdJiSaUSENzv40Zb2UtfnV-iC56oI2ZW7ytTGQ37FuQBmkyoyw1p4OSCU-G9XeiUyVktuWG5wYQ&oh=2a9585ff5d8ce839d75dd3c2e4b81028&oe=5B774047",
          orderTime: "10 mins ago",
          totalOrder: 5,
          totalOrderAmount: 12000.0),
      Base.adminOrder(
          senderName: "Judith Ukonu",
          senderImgUrl:
              "https://scontent.flos2-1.fna.fbcdn.net/v/t1.0-1/c0.0.160.160/p160x160/21270793_2355653891326918_4378932577050204161_n.jpg?_nc_cat=0&_nc_eui2=AeHyfkw_N21ybktUCQ-fZElTthGbfh8XD2jXap7zawLLM03GKut-GRVfMrOpAwhX-OMZ_JJnFVGVV8u8yyCyJj16-oOHqa5S1e0v_igSJfa82g&oh=9552e870852f1391a1eb876adf4eef31&oe=5B932659",
          orderTime: "15 mins ago",
          totalOrder: 2,
          totalOrderAmount: 10000.0),
      Base.adminOrder(
          senderName: "Anih Ann",
          senderImgUrl:
              "https://scontent.flos2-1.fna.fbcdn.net/v/t1.0-1/p160x160/32155288_1719889604754287_8806466055422607360_n.jpg?_nc_cat=0&_nc_eui2=AeHWqFDGD-265FIeaGCEnWLCju7clrZqDTzCW1HctfYMsyGUqY71EMvStacPLYZr9E9JrQ3jK8u9i-13Z7Sv_z6SxCzp5uADz3YkZJBrBk5fiw&oh=cde8b9a8e7083c7b1d58017112e87e17&oe=5BC13166",
          orderTime: "20 mins ago",
          totalOrder: 5,
          totalOrderAmount: 15000.0),
      Base.adminOrder(
          senderName: "Nkechi Odionu",
          senderImgUrl:
              "https://scontent.flos2-1.fna.fbcdn.net/v/t1.0-1/c27.0.160.160/p160x160/10001307_1374857406125629_940003785_n.jpg?_nc_cat=0&_nc_eui2=AeG4aM-rrzySJtEVqFwxOU1AWug_215ObQ1wq6g9j2MX6cpqBeWVBpwdB1ujWNP8JzppDFpyorLVd4SVpf9-4uaOmdtXLINAQiOLzf6idtghvw&oh=ad4bdc53d31360fb227cbf0678b0795a&oe=5BC0FC59",
          orderTime: "25 mins ago",
          totalOrder: 8,
          totalOrderAmount: 120000.0),
      Base.adminOrder(
          senderName: "Joy Esther",
          senderImgUrl:
              "https://scontent.flos2-1.fna.fbcdn.net/v/t1.0-1/p160x160/30738456_179742519504398_1148078082872049664_n.jpg?_nc_cat=0&_nc_eui2=AeGgdM9U_-vjewqK9I4pAX0zBiVmEwEpGXVzPLiNPAlgrPhIJ9MYl3Pxx14GhkqFzgODD0KNTFzRWGxm2_lGKSce3wMXcIjEA50_V1YAtbw83Q&oh=6dd8457f6cb8568c1a7eac96be903a21&oe=5B975259",
          orderTime: "30 mins ago",
          totalOrder: 3,
          totalOrderAmount: 8000.0),
      Base.adminOrder(
          senderName: "Chidinma Iwuajoku",
          senderImgUrl:
              "https://scontent.flos2-1.fna.fbcdn.net/v/t1.0-1/p160x160/17424740_1154743711315225_839220400350401501_n.jpg?_nc_cat=0&_nc_eui2=AeGyjEA1gqMXWlTQ6L-K6DDfmf4-h1sk0m_bElpHTUXAabGkVuxe2kJW6VN-tjoI0BWKVYao9hG25SIj5e4t0bBZFUAY_lSsys5Kl6YfWSWP0Q&oh=f1e53dfe610dfd2c3067555eb06f8ffd&oe=5B81D565",
          orderTime: "35 mins ago",
          totalOrder: 2,
          totalOrderAmount: 2500.0),
      Base.adminOrder(
          senderName: "Nancy Chinecherem",
          senderImgUrl:
              "https://scontent.flos2-1.fna.fbcdn.net/v/t1.0-1/c0.0.160.160/p160x160/32584480_2054922424827961_1941670558932402176_n.jpg?_nc_cat=0&_nc_eui2=AeFFObFhSdAkbLIw3UXa-vfJNzQ32clTLpE-9sQH6Xbpw8R8py8qiLRvHMdcUDK-Eu6lC-o4LM5ognEaic4EvaXmgrmu88bQZwYPms1IPPwrIA&oh=b33e3b38c564b7d29b6cb1867a34f4aa&oe=5B8E1F08",
          orderTime: "40 mins ago",
          totalOrder: 10,
          totalOrderAmount: 50000.0),
    ];
  }
}
