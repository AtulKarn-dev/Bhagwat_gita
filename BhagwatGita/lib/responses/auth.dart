import 'dart:convert';

Token tokenFromJson(String str) => Token.fromJson(json.decode(str));

String tokenToJson(Token data) => json.encode(data.toJson());

class Token {
    String accessToken;
    String tokenType;
    String scope;

    Token({
        required this.accessToken,
        required this.tokenType,
        required this.scope,
    });

    factory Token.fromJson(Map<String, dynamic> json) => Token(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        scope: json["scope"],
    );

    Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "scope": scope,
    };
}
