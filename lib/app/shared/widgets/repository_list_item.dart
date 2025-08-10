// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:repin/app/core/utils/extensions/int.dart';
import 'package:repin/app/data/model/repository.model.dart';

/// 공용 저장소 리스트 아이템 컴포넌트
/// - 검색/북마크 화면에서 동일 UI 재사용
class RepositoryListItem extends StatelessWidget {
  /// 렌더링할 저장소 데이터
  final Repository repository;

  /// 상단 우측에 배치할 액션 위젯들(예: 북마크 버튼, 별 수 표시 등)
  final List<Widget> trailingActions;

  const RepositoryListItem({
    super.key,
    required this.repository,
    this.trailingActions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 이름 + 우측 액션들
          Row(
            children: [
              Expanded(
                child: Text(
                  repository.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star, size: 16, color: Colors.amber[600]),
                  const SizedBox(width: 4),
                  Text(
                    repository.stargazersCount.formatCompact("en_US"),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              if (trailingActions.isNotEmpty) Row(children: trailingActions),
            ],
          ),
          const SizedBox(height: 2),
          // 오너 정보
          Row(
            children: [
              if (repository.ownerProfileUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    repository.ownerProfileUrl!,
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(width: 4),
              Text(
                repository.ownerName,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 설명
          if (repository.description.isNotEmpty)
            Text(
              repository.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 8),
          // 메타 정보 (언어, 포크/워처/이슈)
          Row(
            children: [
              if (repository.language != null &&
                  repository.language!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    repository.language!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Icon(Icons.call_split, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    repository.forksCount.formatCompact("en_US"),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Icon(Icons.remove_red_eye, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    repository.watchersCount.formatCompact("en_US"),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Icon(Icons.bug_report, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    repository.openIssuesCount.formatCompact("en_US"),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
