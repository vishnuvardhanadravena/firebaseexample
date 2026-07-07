import '../entities/feed_post.dart';

abstract interface class FeedRepository {
  Future<List<FeedPost>> fetchFeed({int page = 0, int pageSize = 10});

  Future<void> toggleLike(String postId, bool liked);

  Future<void> toggleSave(String postId, bool saved);
}
