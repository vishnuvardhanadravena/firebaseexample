import '../../domain/entities/feed_post.dart';
import '../../domain/repositories/feed_repository.dart';


final class MockFeedRepository implements FeedRepository {
  @override
  Future<List<FeedPost>> fetchFeed({int page = 0, int pageSize = 10}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return List.generate(pageSize, (i) {
      final n = page * pageSize + i;
      return FeedPost(
        id: 'post_$n',
        imageUrl:
            'https://picsum.photos/seed/weconnect$n/800/1400',
        authorName: 'Jenny Wilson',
        authorAvatarUrl: 'https://i.pravatar.cc/150?img=${n % 70}',
        authorVerified: true,
        caption: 'Life is a mirror, we get the best results when we smile at it.',
        hashtags: const ['#fashion', '#style', '#cool', '#lifestyle'],
        likeCount: 782 + n,
        commentCount: 230,
        saveCount: 128,
        shareCount: 200,
      );
    });
  }

  @override
  Future<void> toggleLike(String postId, bool liked) async {
    await Future.delayed(const Duration(milliseconds: 150));
  }

  @override
  Future<void> toggleSave(String postId, bool saved) async {
    await Future.delayed(const Duration(milliseconds: 150));
  }
}
