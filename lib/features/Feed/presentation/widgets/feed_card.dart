import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/feed_post.dart';
import 'feed_action_rail.dart';

/// A single full-bleed feed card: background image, bottom gradient,
/// author row + caption on the bottom-left, action rail on the right.
class FeedCard extends StatelessWidget {
  const FeedCard({
    super.key,
    required this.post,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onSaveTap,
    required this.onShareTap,
    this.onAuthorTap,
  });

  final FeedPost post;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onSaveTap;
  final VoidCallback onShareTap;
  final VoidCallback? onAuthorTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: post.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            errorWidget: (context, url, error) => Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.broken_image_outlined),
            ),
          ),

          // Bottom gradient for text legibility.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.transparent, Colors.black87],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),

          // Action rail, vertically centered on the right edge.
          Positioned(
            right: 12,
            bottom: 90,
            child: FeedActionRail(
              likeCount: post.likeCount,
              commentCount: post.commentCount,
              saveCount: post.saveCount,
              shareCount: post.shareCount,
              isLiked: post.isLiked,
              isSaved: post.isSaved,
              onLikeTap: onLikeTap,
              onCommentTap: onCommentTap,
              onSaveTap: onSaveTap,
              onShareTap: onShareTap,
            ),
          ),

          // Author + caption, bottom-left.
          Positioned(
            left: 16,
            right: 84,
            bottom: 20,
            child: GestureDetector(
              onTap: onAuthorTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundImage: NetworkImage(post.authorAvatarUrl),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        post.authorName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      if (post.authorVerified) ...[
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, size: 14, color: Colors.blue),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.hashtags.join(' '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
