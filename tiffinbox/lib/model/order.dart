import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';  // This directive includes the generated code

@JsonSerializable()  // Annotation to generate toJson and fromJson methods
class Order {
  @JsonKey(name: 'id')  // Annotation to map the JSON key to this field
  String? id;

  @JsonKey(name: 'address')
  String? address;

  @JsonKey(name: 'latitude')
  double? latitude;

  @JsonKey(name: 'payment')
  String? payment;

  @JsonKey(name: 'items')
  List<Map<String, dynamic>>? items;

  @JsonKey(name: 'longitude')
  double? longitude;

  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'phone')
  String? phone;

  Order({
    this.id,
    this.address,
    this.latitude,
    this.payment,
    this.items,
    this.longitude,
    this.email,
    this.phone,
  });

  // A factory constructor to create an instance of Order from a JSON map
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  // A method to convert an instance of Order to a JSON map
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}