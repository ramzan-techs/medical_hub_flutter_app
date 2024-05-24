class Message {
  Message({
    required this.toId,
    required this.read,
    required this.type,
    required this.sent,
    required this.fromId,
    required this.msg,
    required this.recieved,
  });
  late final String msg;
  late final String toId;
  late final String read;
  late final Type type;
  late final String sent;
  late final String recieved;
  late final String fromId;

  Message.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    toId = json['toId'].toString();
    read = json['read'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sent = json['sent'].toString();
    recieved = json['recieved'].toString();
    fromId = json['fromId'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['msg'] = msg;
    data['read'] = read;
    data['type'] = type.name;
    data['sent'] = sent;
    data['recieved'] = recieved;
    data['fromId'] = fromId;
    return data;
  }
}

enum Type { image, text }
