// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/widgets/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class FarmerSocialFeed extends StatefulWidget {
  const FarmerSocialFeed({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _FarmerSocialFeedState createState() => _FarmerSocialFeedState();
}

class _FarmerSocialFeedState extends State<FarmerSocialFeed> {
  final _supabase = Supabase.instance.client;
  User? _currentUser;

  // --- Theme Colors ---
  final Color kPrimary = Color(0xFF2E7D32); // Forest Green
  final Color kBg = Color(0xFFF3F4F6);
  final Color kWhite = Colors.white;
  final Color kRed = Color(0xFFE53935);
  final Color kTextMain = Color(0xFF1F2937);
  final Color kTextSub = Color(0xFF6B7280);

  // --- State Variables ---
  int _navIndex = 0;
  bool _isLoading = true;
  List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> _notifications = [];
  Set<String> _followingIds = {};

  // Track animated states for likes locally
  // Map<PostID, isLiked>
  Map<int, bool> _localLikedState = {};
  // Map<PostID, LikeCount>
  Map<int, int> _localLikeCounts = {};
  // Map<PostID, ScaleValue> for animation
  Map<int, double> _likeAnimationScale = {};

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  // ============================
  //      INIT & DATA LOADING
  // ============================

  Future<void> _initializeUser() async {
    _currentUser = _supabase.auth.currentUser;
    // Handle anon login if needed, typically handled by FF Auth
    if (_currentUser != null) {
      _refreshAll();
    }
  }

  Future<void> _refreshAll() async {
    if (_currentUser == null) return;
    setState(() => _isLoading = true);
    await Future.wait([
      _fetchFeed(),
      _fetchFollowing(),
      _fetchNotifications(),
    ]);
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _fetchFeed() async {
    try {
      final res = await _supabase
          .from('posts')
          .select(
              '*, profiles:user_id(*), post_likes(user_id), post_comments(count)')
          .order('created_at', ascending: false);

      final data = List<Map<String, dynamic>>.from(res);

      setState(() {
        _posts = data;
        // Initialize local state for instant interactions
        for (var p in data) {
          final id = p['id'];
          final likes = (p['post_likes'] as List?) ?? [];
          final count = likes.length; // Use actual count or select count query
          final isLiked = likes.any((l) => l['user_id'] == _currentUser?.id);

          _localLikedState[id] = isLiked;
          // Note: Ideally Supabase returns {count: x} for likes, but for now calculating from list
          _localLikeCounts[id] = count;
          _likeAnimationScale[id] = 1.0;
        }
      });
    } catch (e) {
      debugPrint("Error fetching feed: $e");
    }
  }

  Future<void> _fetchFollowing() async {
    try {
      final res = await _supabase
          .from('follows')
          .select('following_id')
          .eq('follower_id', _currentUser!.id);
      if (mounted) {
        setState(() {
          _followingIds =
              (res as List).map((r) => r['following_id'] as String).toSet();
        });
      }
    } catch (_) {}
  }

  Future<void> _fetchNotifications() async {
    try {
      final res = await _supabase
          .from('notifications')
          .select('*, profiles:actor_id(*)')
          .eq('user_id', _currentUser!.id)
          .order('created_at', ascending: false);
      if (mounted)
        setState(() => _notifications = List<Map<String, dynamic>>.from(res));
    } catch (_) {}
  }

  // ============================
  //      INTERACTIONS
  // ============================

  Future<void> _handleLike(int postId) async {
    final isCurrentlyLiked = _localLikedState[postId] ?? false;
    final currentCount = _localLikeCounts[postId] ?? 0;

    // 1. Trigger Animation
    setState(() {
      _likeAnimationScale[postId] = 1.5; // Grow
    });

    // Reset scale after short delay for "bounce" effect
    Future.delayed(Duration(milliseconds: 150), () {
      if (mounted)
        setState(() => _likeAnimationScale[postId] = 1.0); // Return to normal
    });

    // 2. Optimistic UI Update
    setState(() {
      _localLikedState[postId] = !isCurrentlyLiked;
      _localLikeCounts[postId] =
          isCurrentlyLiked ? (currentCount - 1) : (currentCount + 1);
    });

    // 3. Backend Call
    try {
      if (isCurrentlyLiked) {
        // Was liked, so delete
        await _supabase
            .from('post_likes')
            .delete()
            .match({'user_id': _currentUser!.id, 'post_id': postId});
      } else {
        // Was not liked, so insert
        await _supabase
            .from('post_likes')
            .insert({'user_id': _currentUser!.id, 'post_id': postId});
      }
    } catch (e) {
      // Revert on error
      setState(() {
        _localLikedState[postId] = isCurrentlyLiked;
        _localLikeCounts[postId] = currentCount;
      });
    }
  }

  Future<void> _toggleFollow(String targetId, String targetName) async {
    if (targetId == _currentUser!.id) return;
    final isFollowing = _followingIds.contains(targetId);

    setState(() {
      if (isFollowing)
        _followingIds.remove(targetId);
      else
        _followingIds.add(targetId);
    });

    try {
      if (isFollowing) {
        await _supabase
            .from('follows')
            .delete()
            .match({'follower_id': _currentUser!.id, 'following_id': targetId});
      } else {
        await _supabase.from('follows').insert(
            {'follower_id': _currentUser!.id, 'following_id': targetId});

        // Notify
        final me = await _supabase
            .from('profiles')
            .select('name')
            .eq('id', _currentUser!.id)
            .single();
        await _supabase.from('notifications').insert({
          'user_id': targetId,
          'actor_id': _currentUser!.id,
          'message': "${me['name']} followed you",
        });
      }
    } catch (e) {
      _refreshAll(); // Revert logic is complex, easier to refresh
    }
  }

  // ============================
  //      MODALS (Comment & Post)
  // ============================

  void _showCommentsModal(BuildContext context, int postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Needed for full height responsiveness
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CommentsSheet(
        supabase: _supabase,
        currentUser: _currentUser!,
        postId: postId,
        primaryColor: kPrimary,
      ),
    );
  }

  void _showCreatePostModal() {
    final _textCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        // Calculate padding to push content above keyboard
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.all(24),
            // REMOVED: mainAxisSize: MainAxisSize.min, (Not valid for Container)
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // <--- MOVED HERE (Valid for Column)
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("New Post",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kTextMain)),
                    IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx)),
                  ],
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _textCtrl,
                  maxLines: 4,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Share your farming tips or questions...",
                    filled: true,
                    fillColor: kBg,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_textCtrl.text.trim().isEmpty) return;
                    Navigator.pop(ctx);
                    await _supabase.from('posts').insert({
                      'user_id': _currentUser!.id,
                      'content': _textCtrl.text.trim(),
                    });
                    _fetchFeed();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Post Now",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================
  //      MAIN BUILD
  // ============================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      // AppBar
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 1,
        title: Row(
          children: [
            Icon(Icons.eco, color: kPrimary, size: 28),
            SizedBox(width: 8),
            Text(
              "AgriConnect",
              style: TextStyle(
                  color: kTextMain, fontWeight: FontWeight.w800, fontSize: 22),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: kTextSub),
            onPressed: _refreshAll,
          )
        ],
      ),

      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: kPrimary))
          : IndexedStack(
              index: _navIndex,
              children: [
                _buildFeed(), // 0
                Container(), // 1 (Placeholder for modal)
                _buildNotifications(), // 2
              ],
            ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _navIndex,
          onTap: (i) {
            if (i == 1)
              _showCreatePostModal();
            else {
              setState(() => _navIndex = i);
              if (i == 2) _fetchNotifications();
            }
          },
          backgroundColor: Colors.white,
          selectedItemColor: kPrimary,
          unselectedItemColor: kTextSub,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded, size: 28), label: "Home"),
            BottomNavigationBarItem(
                icon: Container(
                  padding: EdgeInsets.all(12),
                  decoration:
                      BoxDecoration(color: kPrimary, shape: BoxShape.circle),
                  child: Icon(Icons.add, color: Colors.white, size: 28),
                ),
                label: "Add"),
            BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.notifications_rounded, size: 28),
                    if (_notifications.any((n) => !(n['is_read'] ?? false)))
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: kRed,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 2)),
                        ),
                      )
                  ],
                ),
                label: "Alerts"),
          ],
        ),
      ),
    );
  }

  Widget _buildFeed() {
    if (_posts.isEmpty)
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.post_add, size: 60, color: Colors.grey),
          SizedBox(height: 10),
          Text("No posts yet", style: TextStyle(color: Colors.grey)),
        ],
      ));

    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: _posts.length,
      separatorBuilder: (_, __) => SizedBox(height: 16),
      itemBuilder: (context, index) {
        final post = _posts[index];
        final profile = post['profiles'] ?? {};
        final postId = post['id'];
        final userId = profile['id'];
        final isMe = userId == _currentUser?.id;

        final isLiked = _localLikedState[postId] ?? false;
        final likeCount = _localLikeCounts[postId] ?? 0;
        final scale = _likeAnimationScale[postId] ?? 1.0;

        // Count comments safely
        final commentData = post['post_comments'];
        int commentCount = 0;
        if (commentData is List && commentData.isNotEmpty) {
          commentCount =
              commentData[0]['count'] ?? 0; // If using .count() in query
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4))
            ],
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: kPrimary.withOpacity(0.1),
                    child: Text((profile['name'] ?? "?")[0].toUpperCase(),
                        style: TextStyle(
                            color: kPrimary, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile['name'] ?? "Unknown Farmer",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: kTextMain)),
                        Text(
                            DateFormat.yMMMd()
                                .format(DateTime.parse(post['created_at'])),
                            style: TextStyle(fontSize: 12, color: kTextSub)),
                      ],
                    ),
                  ),
                  if (!isMe)
                    GestureDetector(
                      onTap: () =>
                          _toggleFollow(userId, profile['name'] ?? "User"),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: _followingIds.contains(userId)
                              ? Colors.transparent
                              : kPrimary.withOpacity(0.1),
                          border: Border.all(
                              color: _followingIds.contains(userId)
                                  ? kTextSub
                                  : Colors.transparent),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _followingIds.contains(userId)
                              ? "Following"
                              : "Follow",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _followingIds.contains(userId)
                                  ? kTextSub
                                  : kPrimary),
                        ),
                      ),
                    )
                ],
              ),
              SizedBox(height: 12),
              // CONTENT
              Text(post['content'],
                  style:
                      TextStyle(fontSize: 15, height: 1.5, color: kTextMain)),
              SizedBox(height: 16),
              Divider(height: 1, color: Colors.grey[200]),
              SizedBox(height: 12),
              // ACTIONS
              Row(
                children: [
                  // LIKE BUTTON WITH ANIMATION
                  GestureDetector(
                    onTap: () => _handleLike(postId),
                    child: Row(
                      children: [
                        AnimatedScale(
                          scale: scale,
                          duration: Duration(milliseconds: 150),
                          curve: Curves.easeOutBack,
                          child: Icon(
                            isLiked
                                ? Icons.favorite
                                : Icons.favorite_border_rounded,
                            color: isLiked ? kRed : kTextSub,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text("$likeCount",
                            style: TextStyle(
                                color: isLiked ? kRed : kTextSub,
                                fontWeight: isLiked
                                    ? FontWeight.bold
                                    : FontWeight.normal)),
                      ],
                    ),
                  ),
                  SizedBox(width: 24),
                  // COMMENT BUTTON
                  GestureDetector(
                    onTap: () => _showCommentsModal(context, postId),
                    child: Row(
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded,
                            color: kTextSub, size: 22),
                        SizedBox(width: 6),
                        Text("Comment", style: TextStyle(color: kTextSub)),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotifications() {
    if (_notifications.isEmpty)
      return Center(
          child: Text("No alerts yet", style: TextStyle(color: kTextSub)));

    return ListView.builder(
      itemCount: _notifications.length,
      itemBuilder: (ctx, i) {
        final n = _notifications[i];
        final actor = n['profiles'] ?? {};
        return Container(
          color: Colors.white,
          margin: EdgeInsets.only(bottom: 1),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: kPrimary.withOpacity(0.1),
              child:
                  Icon(Icons.notifications_active, color: kPrimary, size: 20),
            ),
            title: Text(n['message'] ?? "Notification",
                style: TextStyle(fontSize: 14)),
            subtitle: Text(
                DateFormat.Hm().format(DateTime.parse(n['created_at'])),
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ),
        );
      },
    );
  }
}

// ==========================================
//    HELPER: COMMENTS BOTTOM SHEET
// ==========================================
// Needs its own state to handle loading/posting independently

class _CommentsSheet extends StatefulWidget {
  final SupabaseClient supabase;
  final User currentUser;
  final int postId;
  final Color primaryColor;

  const _CommentsSheet(
      {required this.supabase,
      required this.currentUser,
      required this.postId,
      required this.primaryColor});

  @override
  __CommentsSheetState createState() => __CommentsSheetState();
}

class __CommentsSheetState extends State<_CommentsSheet> {
  final TextEditingController _commentCtrl = TextEditingController();
  List<Map<String, dynamic>> _comments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchComments();
  }

  Future<void> _fetchComments() async {
    try {
      final res = await widget.supabase
          .from('post_comments')
          .select('*, profiles:user_id(*)')
          .eq('post_id', widget.postId)
          .order('created_at', ascending: true);
      if (mounted)
        setState(() {
          _comments = List<Map<String, dynamic>>.from(res);
          _isLoading = false;
        });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _postComment() async {
    final text = _commentCtrl.text.trim();
    if (text.isEmpty) return;
    _commentCtrl.clear();

    // Optimistic UI insert
    setState(() {
      _comments.add({
        'content': text,
        'created_at': DateTime.now().toIso8601String(),
        'profiles': {'name': 'Me'} // Temporary name
      });
    });

    try {
      await widget.supabase.from('post_comments').insert({
        'post_id': widget.postId,
        'user_id': widget.currentUser.id,
        'content': text,
      });
      // Refresh to get real ID/Profile
      _fetchComments();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    // IMPORTANT: Padding for Keyboard
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          children: [
            // Handle bar
            Center(
                child: Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2)))),
            Padding(
                padding: EdgeInsets.all(16),
                child: Text("Comments",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            Divider(height: 1),

            // List
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _comments.isEmpty
                      ? Center(
                          child: Text("No comments yet.",
                              style: TextStyle(color: Colors.grey)))
                      : ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: _comments.length,
                          itemBuilder: (ctx, i) {
                            final c = _comments[i];
                            final p = c['profiles'] ?? {};
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.grey[200],
                                      child: Text((p['name'] ?? "U")[0],
                                          style: TextStyle(fontSize: 12))),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Color(0xFFF3F4F6),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(p['name'] ?? "User",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13)),
                                          SizedBox(height: 4),
                                          Text(c['content'] ?? "",
                                              style: TextStyle(fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
            ),

            // Input
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey[200]!))),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentCtrl,
                      decoration: InputDecoration(
                        hintText: "Write a comment...",
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        filled: true,
                        fillColor: Color(0xFFF3F4F6),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    onPressed: _postComment,
                    icon: Icon(Icons.send_rounded, color: widget.primaryColor),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
