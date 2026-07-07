import 'package:flutter/foundation.dart';

import '../../domain/entities/feed_post.dart';
import '../../domain/repositories/feed_repository.dart';

enum FeedStatus { initial, loading, loaded, error }

class FeedProvider extends ChangeNotifier {
  FeedProvider({required FeedRepository repository})
      : _repository = repository;

  final FeedRepository _repository;

  FeedStatus _status = FeedStatus.initial;
  FeedStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final List<FeedPost> _posts = [];
  List<FeedPost> get posts => List.unmodifiable(_posts);

  int _page = 0;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  Future<void> loadInitial() async {
    _status = FeedStatus.loading;
    notifyListeners();

    try {
      final result = await _repository.fetchFeed(page: 0);
      _posts
        ..clear()
        ..addAll(result);
      _page = 0;
      _hasMore = result.isNotEmpty;
      _status = FeedStatus.loaded;
    } catch (e) {
      _errorMessage = 'Could not load your feed. Pull to retry.';
      _status = FeedStatus.error;
    }
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (!_hasMore || _status == FeedStatus.loading) return;

    try {
      final nextPage = _page + 1;
      final result = await _repository.fetchFeed(page: nextPage);
      if (result.isEmpty) {
        _hasMore = false;
      } else {
        _posts.addAll(result);
        _page = nextPage;
      }
      notifyListeners();
    } catch (_) {
      // Silently keep existing posts; a snackbar can be surfaced by the
      // caller if desired.
    }
  }

  Future<void> toggleLike(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = _posts[index];
    final nowLiked = !post.isLiked;

    // Optimistic update.
    _posts[index] = post.copyWith(
      isLiked: nowLiked,
      likeCount: post.likeCount + (nowLiked ? 1 : -1),
    );
    notifyListeners();

    try {
      await _repository.toggleLike(postId, nowLiked);
    } catch (_) {
      // Revert on failure.
      _posts[index] = post;
      notifyListeners();
    }
  }

  Future<void> toggleSave(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = _posts[index];
    final nowSaved = !post.isSaved;

    _posts[index] = post.copyWith(
      isSaved: nowSaved,
      saveCount: post.saveCount + (nowSaved ? 1 : -1),
    );
    notifyListeners();

    try {
      await _repository.toggleSave(postId, nowSaved);
    } catch (_) {
      _posts[index] = post;
      notifyListeners();
    }
  }
}
