import 'dart:convert';

Order referenceFromJson(String str) => Order.fromMap(json.decode(str));
String referenceToJson(Order data) => json.encode(data.toMap());

class Order {

  final int? id;
  final String ref;
  final String status;
  final String image;
  final String link;
  final String nbreDePages;
  final String total;
  final String date;

  const Order({
    this.id,
    required this.ref,
    this.image = '',
    this.status = '',
    this.link = '',
    this.nbreDePages = 'N/A',
    this.total = '',
    this.date = 'N/A',
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] ?? 'N/A',
      ref: map['ref'] ?? 'N/A',
      status: map['status'] ?? 'N/A',
      image: map['image'] ?? 'N/A',
      link: map['link'] ?? 'N/A',
      nbreDePages: map['nbredepages'] ?? 'N/A',
      total: map['total'] ?? 'N/A',
      date: map['date'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ref': ref,
      'status': status,
      'image': image,
      'link': link,
      'nbredepages': nbreDePages,
      'total': total,
      'date': date,
    };
  }
}
