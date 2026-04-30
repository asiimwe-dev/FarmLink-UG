import 'package:farmlink_ug/core/domain/entities/user.dart';

/// Sync status for posts and comments
enum SyncStatus {
  synced,       // Successfully synced to cloud
  pending,      // Waiting to be synced
  syncing,      // Currently syncing
  failed,       // Failed to sync
}

/// Community/Forum repository contract
/// Implemented by features/community/data/repositories/community_repository.dart
abstract class ICommunityRepository {
  /// Fetch all posts in a topic
  Future<List<Post>> fetchPosts({
    required String topicId,
    int page = 1,
    int pageSize = 20,
  });

  /// Watch posts stream for real-time updates
  Stream<List<Post>> watchPosts(String topicId);

  /// Create a new post (queued for sync if offline)
  Future<Post> createPost({
    required String topicId,
    required String title,
    required String content,
    List<String>? imageUrls,
  });

  /// Update existing post
  Future<Post> updatePost({
    required String postId,
    String? title,
    String? content,
    List<String>? imageUrls,
  });

  /// Delete post
  Future<void> deletePost(String postId);

  /// Like/unlike post
  Future<void> toggleLike(String postId);

  /// Get comments on a post
  Future<List<Comment>> fetchComments(String postId);

  /// Add comment (queued for sync if offline)
  Future<Comment> addComment({
    required String postId,
    required String content,
  });

  /// Fetch all topics/communities
  Future<List<Topic>> fetchTopics();

  /// Watch topics stream
  Stream<List<Topic>> watchTopics();

  /// Get pending posts (not yet synced)
  Future<List<Post>> getPendingPosts();

  /// Sync pending posts to server
  Future<void> syncPendingPosts();
}

/// Forum post entity
class Post {
  final String id;
  final String topicId;
  final String userId;
  final String? userName;
  final String title;
  final String content;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likes;
  final int commentCount;
  final bool isPending; // Not yet synced
  final bool isLiked;
  final SyncStatus syncStatus;
  final String? syncErrorMessage;
  final VerificationStatus? authorVerificationStatus;

  Post({
    required this.id,
    required this.topicId,
    required this.userId,
    this.userName,
    required this.title,
    required this.content,
    this.imageUrls = const [],
    required this.createdAt,
    this.updatedAt,
    this.likes = 0,
    this.commentCount = 0,
    this.isPending = false,
    this.isLiked = false,
    this.syncStatus = SyncStatus.synced,
    this.syncErrorMessage,
    this.authorVerificationStatus,
  });

  /// Copy with modifications
  Post copyWith({
    String? id,
    String? topicId,
    String? userId,
    String? userName,
    String? title,
    String? content,
    List<String>? imageUrls,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likes,
    int? commentCount,
    bool? isPending,
    bool? isLiked,
    SyncStatus? syncStatus,
    String? syncErrorMessage,
    VerificationStatus? authorVerificationStatus,
  }) {
    return Post(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likes: likes ?? this.likes,
      commentCount: commentCount ?? this.commentCount,
      isPending: isPending ?? this.isPending,
      isLiked: isLiked ?? this.isLiked,
      syncStatus: syncStatus ?? this.syncStatus,
      syncErrorMessage: syncErrorMessage ?? this.syncErrorMessage,
      authorVerificationStatus: authorVerificationStatus ?? this.authorVerificationStatus,
    );
  }
}

/// Forum comment entity
class Comment {
  final String id;
  final String postId;
  final String userId;
  final String? userName;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likes;
  final bool isPending; // Not yet synced
  final SyncStatus syncStatus;
  final String? syncErrorMessage;
  final VerificationStatus? authorVerificationStatus;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    this.userName,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    this.likes = 0,
    this.isPending = false,
    this.syncStatus = SyncStatus.synced,
    this.syncErrorMessage,
    this.authorVerificationStatus,
  });

  /// Copy with modifications
  Comment copyWith({
    String? id,
    String? postId,
    String? userId,
    String? userName,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likes,
    bool? isPending,
    SyncStatus? syncStatus,
    String? syncErrorMessage,
    VerificationStatus? authorVerificationStatus,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likes: likes ?? this.likes,
      isPending: isPending ?? this.isPending,
      syncStatus: syncStatus ?? this.syncStatus,
      syncErrorMessage: syncErrorMessage ?? this.syncErrorMessage,
      authorVerificationStatus: authorVerificationStatus ?? this.authorVerificationStatus,
    );
  }
}

/// Forum topic/community entity
class Topic {
  final String id;
  final String name; // e.g., "Coffee Growers", "Maize Farmers"
  final String description;
  final String? imageUrl;
  final int memberCount;
  final int postCount;
  final bool isMember;

  Topic({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.memberCount = 0,
    this.postCount = 0,
    this.isMember = false,
  });
}
