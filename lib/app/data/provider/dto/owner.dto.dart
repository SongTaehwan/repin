// 📦 Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// 🌎 Project imports:
import 'package:repin/app/core/utils/helpers/enum_values.dart';

part 'owner.dto.freezed.dart';
part 'owner.dto.g.dart';

@freezed
abstract class Owner with _$Owner {
  const factory Owner({
    @JsonKey(name: "avatar_url") required String avatarUrl,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "events_url") required String eventsUrl,
    @JsonKey(name: "followers_url") required String followersUrl,
    @JsonKey(name: "following_url") required String followingUrl,
    @JsonKey(name: "gists_url") required String gistsUrl,
    @JsonKey(name: "gravatar_id") required String? gravatarId,
    @JsonKey(name: "html_url") required String htmlUrl,
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "login") required String login,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "node_id") required String nodeId,
    @JsonKey(name: "organizations_url") required String organizationsUrl,
    @JsonKey(name: "received_events_url") required String receivedEventsUrl,
    @JsonKey(name: "repos_url") required String reposUrl,
    @JsonKey(name: "site_admin") required bool siteAdmin,
    @JsonKey(name: "starred_at") String? starredAt,
    @JsonKey(name: "starred_url") required String starredUrl,
    @JsonKey(name: "subscriptions_url") required String subscriptionsUrl,
    @JsonKey(name: "type") required String type,
    @JsonKey(name: "url") required String url,
    @JsonKey(name: "user_view_type") Visibility? userViewType,
  }) = _Owner;

  factory Owner.fromJson(Map<String, Object?> json) => _$OwnerFromJson(json);
}

enum Visibility {
  @JsonValue("public")
  PUBLIC,
}

final visibilityValues = EnumValues({"public": Visibility.PUBLIC});

enum Type {
  @JsonValue("Organization")
  ORGANIZATION,
  @JsonValue("User")
  USER,
}

final typeValues = EnumValues({
  "Organization": Type.ORGANIZATION,
  "User": Type.USER,
});
