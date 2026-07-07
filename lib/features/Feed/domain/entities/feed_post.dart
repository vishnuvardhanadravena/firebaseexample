
final class FeedPost {
  final String id;
  final String imageUrl;
  final String authorName;
  final String authorAvatarUrl;
  final bool authorVerified;
  final String caption;
  final List<String> hashtags;
  final int likeCount;
  final int commentCount;
  final int saveCount;
  final int shareCount;
  final bool isLiked;
  final bool isSaved;

  const FeedPost({
    required this.id,
    required this.imageUrl,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.caption,
    required this.hashtags,
    required this.likeCount,
    required this.commentCount,
    required this.saveCount,
    required this.shareCount,
    this.authorVerified = false,
    this.isLiked = false,
    this.isSaved = false,
  });

  FeedPost copyWith({
    int? likeCount,
    int? saveCount,
    bool? isLiked,
    bool? isSaved,
  }) {
    return FeedPost(
      id: id,
      imageUrl: imageUrl,
      authorName: authorName,
      authorAvatarUrl: authorAvatarUrl,
      authorVerified: authorVerified,
      caption: caption,
      hashtags: hashtags,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount,
      saveCount: saveCount ?? this.saveCount,
      shareCount: shareCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
