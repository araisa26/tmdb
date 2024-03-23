import 'package:json_annotation/json_annotation.dart';

part 'account_states.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class AccountStates {
  final int id;
  final bool favorite;
  final bool rated;
  final bool watchlist;
  AccountStates({
    required this.id,
    required this.favorite,
    required this.rated,
    required this.watchlist,
  });

  factory AccountStates.fromJson(Map<String, dynamic> json) =>
      _$AccountStatesFromJson(json);

  Map<String, dynamic> toJson() => _$AccountStatesToJson(this);
}
