// 📦 Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// 🌎 Project imports:
import 'package:repin/app/core/utils/helpers/enum_values.dart';

part 'owner.freezed.dart';
part 'owner.g.dart';

@freezed
abstract class Owner with _$Owner {
  const factory Owner({
    @JsonKey(name: "login") required String login,
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "node_id") required String nodeId,
    @JsonKey(name: "avatar_url") required String avatarUrl,
    @JsonKey(name: "gravatar_id") required String gravatarId,
    @JsonKey(name: "url") required String url,
    @JsonKey(name: "html_url") required String htmlUrl,
    @JsonKey(name: "followers_url") required String followersUrl,
    @JsonKey(name: "following_url") required String followingUrl,
    @JsonKey(name: "gists_url") required String gistsUrl,
    @JsonKey(name: "starred_url") required String starredUrl,
    @JsonKey(name: "subscriptions_url") required String subscriptionsUrl,
    @JsonKey(name: "organizations_url") required String organizationsUrl,
    @JsonKey(name: "repos_url") required String reposUrl,
    @JsonKey(name: "events_url") required String eventsUrl,
    @JsonKey(name: "received_events_url") required String receivedEventsUrl,
    @JsonKey(name: "type") required Type type,
    @JsonKey(name: "user_view_type") required Visibility userViewType,
    @JsonKey(name: "site_admin") required bool siteAdmin,
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
