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

import 'package:supabase_flutter/supabase_flutter.dart';

class FarmerNetworkWidget extends StatefulWidget {
  const FarmerNetworkWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _FarmerNetworkWidgetState createState() => _FarmerNetworkWidgetState();
}

class _FarmerNetworkWidgetState extends State<FarmerNetworkWidget>
    with SingleTickerProviderStateMixin {
  final _supabase = Supabase.instance.client;
  User? _currentUser;

  // --- STATE ---
  bool _isLoading = true;
  bool _hasProfile = false;
  late TabController _tabController;

  // --- NAVIGATION ---
  bool _isChatOpen = false;
  Map<String, dynamic>? _activeChatProfile;

  // --- DATA ---
  List<Map<String, dynamic>> _allProfiles = [];
  List<Map<String, dynamic>> _myConnections = [];

  // --- CONTROLLERS ---
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _currentUser = _supabase.auth.currentUser;
    _checkProfileStatus();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // ==========================================
  //           DATA LOGIC
  // ==========================================

  Future<void> _checkProfileStatus() async {
    if (_currentUser == null) return;
    try {
      final data = await _supabase
          .from('profiles')
          .select()
          .eq('id', _currentUser!.id)
          .maybeSingle();

      if (data != null) {
        setState(() => _hasProfile = true);
        _fetchNetworkData();
      } else {
        setState(() {
          _hasProfile = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _createProfile() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await _supabase.from('profiles').insert({
        'id': _currentUser!.id,
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _currentUser!.email,
      });
      setState(() => _hasProfile = true);
      _fetchNetworkData();
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchNetworkData() async {
    try {
      final profilesData =
          await _supabase.from('profiles').select().neq('id', _currentUser!.id);

      final connectionsData = await _supabase.from('connections').select().or(
          'sender_id.eq.${_currentUser!.id},receiver_id.eq.${_currentUser!.id}');

      if (mounted) {
        setState(() {
          _allProfiles = List<Map<String, dynamic>>.from(profilesData);
          _myConnections = List<Map<String, dynamic>>.from(connectionsData);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // ==========================================
  //           CONNECTION ACTIONS
  // ==========================================

  Future<void> _sendRequest(String receiverId) async {
    try {
      await _supabase.from('connections').insert({
        'sender_id': _currentUser!.id,
        'receiver_id': receiverId,
        'status': 'pending',
      });
      _fetchNetworkData();
    } catch (e) {}
  }

  Future<void> _acceptRequest(int connectionId) async {
    try {
      await _supabase
          .from('connections')
          .update({'status': 'accepted'}).eq('id', connectionId);
      _fetchNetworkData();
    } catch (e) {}
  }

  Future<void> _removeConnection(int connectionId) async {
    bool confirm = await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text("Disconnect?"),
            content: Text(
                "Are you sure you want to remove this connection? Chat history will be hidden."),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text("Cancel", style: TextStyle(color: Colors.grey))),
              TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text("Remove", style: TextStyle(color: Colors.red))),
            ],
          ),
        ) ??
        false;

    if (!confirm) return;

    try {
      await _supabase.from('connections').delete().eq('id', connectionId);
      if (_isChatOpen && _activeChatProfile != null) {
        _closeChat();
      }
      _fetchNetworkData();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error removing connection')));
    }
  }

  // ==========================================
  //           CHAT LOGIC
  // ==========================================

  void _openChat(Map<String, dynamic> profile) {
    setState(() {
      _activeChatProfile = profile;
      _isChatOpen = true;
    });
  }

  void _closeChat() {
    setState(() {
      _isChatOpen = false;
      _activeChatProfile = null;
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _activeChatProfile == null) return;
    _messageController.clear();
    try {
      await _supabase.from('messages').insert({
        'sender_id': _currentUser!.id,
        'receiver_id': _activeChatProfile!['id'],
        'content': text,
      });
    } catch (e) {}
  }

  Stream<List<Map<String, dynamic>>> get _chatStream {
    if (_activeChatProfile == null) return Stream.value([]);
    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: true)
        .map((messages) {
          final otherId = _activeChatProfile!['id'];
          final myId = _currentUser!.id;
          return messages.where((m) {
            final sender = m['sender_id'];
            final receiver = m['receiver_id'];
            return (sender == myId && receiver == otherId) ||
                (sender == otherId && receiver == myId);
          }).toList();
        });
  }

  Map<String, dynamic> _getStatus(String otherUserId) {
    final sent = _myConnections.firstWhere(
        (c) =>
            c['sender_id'] == _currentUser!.id &&
            c['receiver_id'] == otherUserId,
        orElse: () => {});
    if (sent.isNotEmpty)
      return {
        'status': sent['status'] == 'accepted' ? 'accepted' : 'sent',
        'data': sent
      };

    final received = _myConnections.firstWhere(
        (c) =>
            c['receiver_id'] == _currentUser!.id &&
            c['sender_id'] == otherUserId,
        orElse: () => {});
    if (received.isNotEmpty)
      return {
        'status': received['status'] == 'accepted' ? 'accepted' : 'received',
        'data': received
      };

    return {'status': 'none', 'data': null};
  }

  // ==========================================
  //           UI BUILDER
  // ==========================================

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary));
    }

    if (!_hasProfile) {
      return _buildCreateProfileView(context);
    }

    if (_isChatOpen && _activeChatProfile != null) {
      return _buildChatScreen(context);
    }

    final incomingRequests = _allProfiles.where((p) {
      final status = _getStatus(p['id']);
      return status['status'] == 'received';
    }).toList();

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Column(
        children: [
          // --- HEADER & TABS ---
          Container(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(0, 2),
                  blurRadius: 5,
                )
              ],
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Farmer Network',
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.bold,
                              )),
                      InkWell(
                        onTap: () {
                          setState(() => _isLoading = true);
                          _fetchNetworkData();
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).alternate,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.refresh_rounded, size: 20),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor:
                          FlutterFlowTheme.of(context).secondaryText,
                      labelStyle: TextStyle(fontWeight: FontWeight.w600),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(text: "Discover"),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Requests"),
                              if (incomingRequests.isNotEmpty)
                                Container(
                                  margin: EdgeInsets.only(left: 8),
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle),
                                  child: Text(
                                    incomingRequests.length.toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- TAB VIEW CONTENT ---
          Expanded(
            child: Container(
              color: FlutterFlowTheme.of(context).primaryBackground,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProfileList(context, _allProfiles, showIncoming: false),
                  incomingRequests.isEmpty
                      ? _buildEmptyState(
                          context, "No pending requests", Icons.inbox_rounded)
                      : _buildProfileList(context, incomingRequests,
                          showIncoming: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- SUB-WIDGET: CHAT SCREEN (Modern) ---
  Widget _buildChatScreen(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Color(0xFFEFEFEF), // Light gray background for chat
      child: Column(
        children: [
          // Chat Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: _closeChat,
                  child: Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                ),
                SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  radius: 20,
                  child: Text(
                    (_activeChatProfile!['name'] ?? 'U')[0].toUpperCase(),
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _activeChatProfile!['name'] ?? 'Unknown',
                        style: FlutterFlowTheme.of(context)
                            .titleMedium
                            .override(
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _activeChatProfile!['phone'] ?? '',
                        style: FlutterFlowTheme.of(context)
                            .labelSmall
                            .override(color: Colors.green),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _chatStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;
                if (messages.isEmpty) {
                  return _buildEmptyState(context, "Start the conversation!",
                      Icons.chat_bubble_outline);
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['sender_id'] == _currentUser!.id;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isMe
                              ? FlutterFlowTheme.of(context).primary
                              : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomLeft:
                                isMe ? Radius.circular(16) : Radius.circular(4),
                            bottomRight:
                                isMe ? Radius.circular(4) : Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 2,
                                offset: Offset(0, 1))
                          ],
                        ),
                        child: Text(
                          msg['content'] ?? '',
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Input Area
          Container(
            padding: EdgeInsets.all(12),
            color: FlutterFlowTheme.of(context).secondaryBackground,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: FlutterFlowTheme.of(context).labelMedium,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                InkWell(
                  onTap: _sendMessage,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                      shape: BoxShape.circle,
                    ),
                    child:
                        Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- SUB-WIDGET: ONBOARDING ---
  Widget _buildCreateProfileView(BuildContext context) {
    return Container(
      width: double.infinity,
      color: FlutterFlowTheme.of(context).secondaryBackground,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person_pin,
                  size: 60, color: FlutterFlowTheme.of(context).primary),
            ),
            SizedBox(height: 24),
            Text("Create Farmer ID",
                style: FlutterFlowTheme.of(context).headlineMedium),
            SizedBox(height: 8),
            Text(
              "Join thousands of farmers. Share knowledge and grow together.",
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context)
                  .bodyMedium
                  .override(color: FlutterFlowTheme.of(context).secondaryText),
            ),
            SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Icons.person_outline),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).primaryBackground,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                prefixIcon: Icon(Icons.phone_outlined),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).primaryBackground,
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _createProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                minimumSize: Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
              ),
              child: Text("Create Profile",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // --- SUB-WIDGET: EMPTY STATE ---
  Widget _buildEmptyState(BuildContext context, String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: FlutterFlowTheme.of(context).alternate),
          SizedBox(height: 16),
          Text(
            message,
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
          ),
        ],
      ),
    );
  }

  // --- SUB-WIDGET: LIST BUILDER ---
  Widget _buildProfileList(
      BuildContext context, List<Map<String, dynamic>> profiles,
      {required bool showIncoming}) {
    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: profiles.length,
      separatorBuilder: (_, __) => SizedBox(height: 16),
      itemBuilder: (context, index) {
        final profile = profiles[index];
        final rel = _getStatus(profile['id']);
        final status = rel['status'];
        final data = rel['data'];

        if (!showIncoming && status == 'received') return SizedBox.shrink();

        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 4))
            ],
          ),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: status == 'accepted'
                      ? Colors.green.shade50
                      : FlutterFlowTheme.of(context).primaryBackground,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    (profile['name'] ?? 'U')[0].toUpperCase(),
                    style: TextStyle(
                      color: status == 'accepted'
                          ? Colors.green
                          : FlutterFlowTheme.of(context).primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),

              // Text Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile['name'] ?? 'Unknown',
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                    ),
                    SizedBox(height: 4),
                    if (status == 'accepted')
                      Row(
                        children: [
                          Icon(Icons.check_circle_rounded,
                              size: 14, color: Colors.green),
                          SizedBox(width: 4),
                          Text(
                            "Connected",
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                    else if (status == 'received')
                      Text(
                        'Sent you a request',
                        style: TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      )
                    else if (status == 'sent')
                      Text(
                        'Request Pending',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      )
                    else
                      Text(
                        'Farmer',
                        style: FlutterFlowTheme.of(context).labelSmall,
                      ),
                  ],
                ),
              ),

              // Action Buttons
              if (status == 'none')
                ElevatedButton(
                  onPressed: () => _sendRequest(profile['id']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                    shape: StadiumBorder(),
                    elevation: 0,
                  ),
                  child: Text('Connect',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                )
              else if (status == 'sent')
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: FlutterFlowTheme.of(context).alternate),
                  ),
                  child: Icon(Icons.access_time_rounded,
                      size: 20, color: Colors.grey),
                )
              else if (status == 'received')
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _acceptRequest(data['id']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: StadiumBorder(),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child:
                          Text('Accept', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                )
              else if (status == 'accepted')
                // --- CONNECTED ACTIONS ---
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => _openChat(profile),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .primary
                              .withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.chat_bubble_rounded,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 20),
                      ),
                    ),
                    SizedBox(width: 4),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'remove') {
                          _removeConnection(data['id']);
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'remove',
                          child: Row(
                            children: [
                              Icon(Icons.person_remove,
                                  color: Colors.red, size: 20),
                              SizedBox(width: 8),
                              Text('Disconnect',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      icon: Icon(Icons.more_vert_rounded,
                          color: FlutterFlowTheme.of(context).secondaryText),
                    ),
                  ],
                )
            ],
          ),
        );
      },
    );
  }
}
