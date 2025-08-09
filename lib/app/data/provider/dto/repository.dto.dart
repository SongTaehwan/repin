// 📦 Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// 🌎 Project imports:
import 'package:repin/app/core/utils/helpers/enum_values.dart';
import 'package:repin/app/data/provider/dto/license.dto.dart';
import 'package:repin/app/data/provider/dto/owner.dto.dart';
import 'package:repin/app/data/provider/dto/permissions.dto.dart';
import 'package:repin/app/data/provider/dto/search_result_text_match.dto.dart';

part 'repository.dto.freezed.dart';
part 'repository.dto.g.dart';

@freezed
abstract class Repository with _$Repository {
  const factory Repository({
    @JsonKey(name: "allow_auto_merge") bool? allowAutoMerge,
    @JsonKey(name: "allow_forking") bool? allowForking,
    @JsonKey(name: "allow_merge_commit") bool? allowMergeCommit,
    @JsonKey(name: "allow_rebase_merge") bool? allowRebaseMerge,
    @JsonKey(name: "allow_squash_merge") bool? allowSquashMerge,
    @JsonKey(name: "archive_url") required String archiveUrl,
    @JsonKey(name: "archived") required bool archived,
    @JsonKey(name: "assignees_url") required String assigneesUrl,
    @JsonKey(name: "blobs_url") required String blobsUrl,
    @JsonKey(name: "branches_url") required String branchesUrl,
    @JsonKey(name: "clone_url") required String cloneUrl,
    @JsonKey(name: "collaborators_url") required String collaboratorsUrl,
    @JsonKey(name: "comments_url") required String commentsUrl,
    @JsonKey(name: "commits_url") required String commitsUrl,
    @JsonKey(name: "compare_url") required String compareUrl,
    @JsonKey(name: "contents_url") required String contentsUrl,
    @JsonKey(name: "contributors_url") required String contributorsUrl,
    @JsonKey(name: "created_at") required DateTime createdAt,
    @JsonKey(name: "default_branch") required String defaultBranch,
    @JsonKey(name: "delete_branch_on_merge") bool? deleteBranchOnMerge,
    @JsonKey(name: "deployments_url") required String deploymentsUrl,
    @JsonKey(name: "description") required String? description,

    ///Returns whether or not this repository disabled.
    @JsonKey(name: "disabled") required bool disabled,
    @JsonKey(name: "downloads_url") required String downloadsUrl,
    @JsonKey(name: "events_url") required String eventsUrl,
    @JsonKey(name: "fork") required bool fork,
    @JsonKey(name: "forks") required int forks,
    @JsonKey(name: "forks_count") required int forksCount,
    @JsonKey(name: "forks_url") required String forksUrl,
    @JsonKey(name: "full_name") required String fullName,
    @JsonKey(name: "git_commits_url") required String gitCommitsUrl,
    @JsonKey(name: "git_refs_url") required String gitRefsUrl,
    @JsonKey(name: "git_tags_url") required String gitTagsUrl,
    @JsonKey(name: "git_url") required String gitUrl,
    @JsonKey(name: "has_discussions") bool? hasDiscussions,
    @JsonKey(name: "has_downloads") required bool hasDownloads,
    @JsonKey(name: "has_issues") required bool hasIssues,
    @JsonKey(name: "has_pages") required bool hasPages,
    @JsonKey(name: "has_projects") required bool hasProjects,
    @JsonKey(name: "has_wiki") required bool hasWiki,
    @JsonKey(name: "homepage") required String? homepage,
    @JsonKey(name: "hooks_url") required String hooksUrl,
    @JsonKey(name: "html_url") required String htmlUrl,
    @JsonKey(name: "id") required int id,
    @JsonKey(name: "is_template") bool? isTemplate,
    @JsonKey(name: "issue_comment_url") required String issueCommentUrl,
    @JsonKey(name: "issue_events_url") required String issueEventsUrl,
    @JsonKey(name: "issues_url") required String issuesUrl,
    @JsonKey(name: "keys_url") required String keysUrl,
    @JsonKey(name: "labels_url") required String labelsUrl,
    @JsonKey(name: "language") required String? language,
    @JsonKey(name: "languages_url") required String languagesUrl,
    @JsonKey(name: "license") required License? license,
    @JsonKey(name: "master_branch") String? masterBranch,
    @JsonKey(name: "merges_url") required String mergesUrl,
    @JsonKey(name: "milestones_url") required String milestonesUrl,
    @JsonKey(name: "mirror_url") required String? mirrorUrl,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "node_id") required String nodeId,
    @JsonKey(name: "notifications_url") required String notificationsUrl,
    @JsonKey(name: "open_issues") required int openIssues,
    @JsonKey(name: "open_issues_count") required int openIssuesCount,
    @JsonKey(name: "owner") required Owner? owner,
    @JsonKey(name: "permissions") Permissions? permissions,
    @JsonKey(name: "private") required bool private,
    @JsonKey(name: "pulls_url") required String pullsUrl,
    @JsonKey(name: "pushed_at") required DateTime pushedAt,
    @JsonKey(name: "releases_url") required String releasesUrl,
    @JsonKey(name: "score") required double score,
    @JsonKey(name: "size") required int size,
    @JsonKey(name: "ssh_url") required String sshUrl,
    @JsonKey(name: "stargazers_count") required int stargazersCount,
    @JsonKey(name: "stargazers_url") required String stargazersUrl,
    @JsonKey(name: "statuses_url") required String statusesUrl,
    @JsonKey(name: "subscribers_url") required String subscribersUrl,
    @JsonKey(name: "subscription_url") required String subscriptionUrl,
    @JsonKey(name: "svn_url") required String svnUrl,
    @JsonKey(name: "tags_url") required String tagsUrl,
    @JsonKey(name: "teams_url") required String teamsUrl,
    @JsonKey(name: "temp_clone_token") String? tempCloneToken,
    @JsonKey(name: "text_matches") List<SearchResultTextMatch>? textMatches,
    @JsonKey(name: "topics") List<String>? topics,
    @JsonKey(name: "trees_url") required String treesUrl,
    @JsonKey(name: "updated_at") required DateTime updatedAt,
    @JsonKey(name: "url") required String url,

    ///The repository visibility: public, private, or internal.
    @JsonKey(name: "visibility") String? visibility,
    @JsonKey(name: "watchers") required int watchers,
    @JsonKey(name: "watchers_count") required int watchersCount,
    @JsonKey(name: "web_commit_signoff_required")
    bool? webCommitSignoffRequired,
  }) = _Item;

  factory Repository.fromJson(Map<String, dynamic> json) =>
      _$RepositoryFromJson(json);
}

enum DefaultBranch {
  @JsonValue("dev")
  DEV,
  @JsonValue("main")
  MAIN,
  @JsonValue("master")
  MASTER,
}

final defaultBranchValues = EnumValues({
  "dev": DefaultBranch.DEV,
  "main": DefaultBranch.MAIN,
  "master": DefaultBranch.MASTER,
});
