import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/user_service.dart';
import 'workout_plan_controller.dart';

class ChatMessage {
  final String role;
  final String content;
  final DateTime timestamp;
  final bool isNew; // ✅ NEW FIELD

  ChatMessage({
    required this.role,
    required this.content,
    DateTime? timestamp,
    this.isNew = false, // ✅ Default to false (loaded messages)
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
    // Don't save 'isNew' - it's only for UI state
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    role: json['role'],
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
    isNew: false, // ✅ Loaded messages are not new
  );

  Map<String, dynamic> toFirestore() => {
    'role': role,
    'content': content,
    'timestamp': Timestamp.fromDate(timestamp),
  };

  factory ChatMessage.fromFirestore(Map<String, dynamic> data) => ChatMessage(
  role: data['role'],
  content: data['content'],
  timestamp: (data['timestamp'] as Timestamp).toDate(),
  isNew: false, // ✅ Loaded from Firestore = not new
);
}

class ChatController extends GetxController {
  final UserService _userService = Get.find<UserService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  RxList<ChatMessage> messages = <ChatMessage>[].obs;
  RxBool isLoading = false.obs;
  RxBool isTyping = false.obs;
  RxBool isSyncing = false.obs;
  RxList<String> quickSuggestions = <String>[
    '💪 Workout form tips',
    '🥗 Nutrition advice',
    '🎯 Modify my plan',
  ].obs;

  static const String _baseUrl = 'http://10.0.2.2:8000/api';
  static const int _maxMessagesInCache = 100;
  static const int _maxMessagesInFirestore = 200;

  @override
  void onInit() {
    super.onInit();
    print('🚀 ChatController initialized');
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    print('\n📚 ========== LOADING CHAT HISTORY ==========');
    isLoading.value = true;

    try {
      // Step 1: Load from cache
      print('⏱️ Step 1: Loading from local cache...');
      await _loadFromCache();

      // Step 2: Sync with Firestore
      print('⏱️ Step 2: Syncing with Firestore...');
      await _syncWithFirestore();

      print('✅ Chat history loaded successfully!');
    } catch (e) {
      print('❌ Failed to load chat history: $e');
      _addWelcomeMessage();
    } finally {
      isLoading.value = false;
      print('📚 ========== LOADING COMPLETE ==========\n');
    }
  }

  Future<void> _loadFromCache() async {
    final startTime = DateTime.now();
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = _userService.currentUser.value?.uid ?? 'guest';
      final cacheKey = 'chat_cache_$userId';
      
      print('   🔑 Cache key: $cacheKey');
      
      final cachedJson = prefs.getString(cacheKey);

      if (cachedJson != null) {
        final List<dynamic> cachedData = jsonDecode(cachedJson);
        messages.value = cachedData
            .map((json) => ChatMessage.fromJson(json))
            .toList();
        
        final duration = DateTime.now().difference(startTime).inMilliseconds;
        print('   ✅ Loaded ${messages.length} messages from cache in ${duration}ms');
      } else {
        print('   ℹ️ No cache found, adding welcome message');
        _addWelcomeMessage();
      }
    } catch (e) {
      print('   ⚠️ Cache load failed: $e');
      _addWelcomeMessage();
    }
  }

  Future<void> _syncWithFirestore() async {
    final userId = _userService.currentUser.value?.uid;
    if (userId == null) {
      print('   ⚠️ No user ID, skipping Firestore sync');
      return;
    }

    isSyncing.value = true;
    final startTime = DateTime.now();

    try {
      print('   ☁️ Fetching from Firestore for user: $userId');
      
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('chat_messages')
          .orderBy('timestamp', descending: false)
          .limit(_maxMessagesInFirestore)
          .get();

      final duration = DateTime.now().difference(startTime).inMilliseconds;

      if (snapshot.docs.isNotEmpty) {
        final firestoreMessages = snapshot.docs
            .map((doc) => ChatMessage.fromFirestore(doc.data()))
            .toList();

        print('   📊 Firestore returned ${firestoreMessages.length} messages in ${duration}ms');

        if (firestoreMessages.length > messages.length) {
          messages.value = firestoreMessages;
          await _saveToCache();
          print('   ✅ Updated local cache with Firestore data');
        } else {
          print('   ℹ️ Cache is up-to-date, no sync needed');
        }
      } else {
        print('   ℹ️ No messages in Firestore');
      }
    } catch (e) {
      print('   ❌ Firestore sync failed: $e');
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> _saveToCache() async {
    final startTime = DateTime.now();
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = _userService.currentUser.value?.uid ?? 'guest';
      final cacheKey = 'chat_cache_$userId';

      final messagesToCache = messages.length > _maxMessagesInCache
          ? messages.sublist(messages.length - _maxMessagesInCache)
          : messages;

      final cacheData = messagesToCache.map((m) => m.toJson()).toList();
      await prefs.setString(cacheKey, jsonEncode(cacheData));
      
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      print('   💾 Saved ${messagesToCache.length} messages to cache in ${duration}ms');
    } catch (e) {
      print('   ⚠️ Cache save failed: $e');
    }
  }

  Future<void> _saveToFirestore() async {
    final userId = _userService.currentUser.value?.uid;
    if (userId == null) {
      print('   ⚠️ No user ID, skipping Firestore save');
      return;
    }

    final startTime = DateTime.now();
    try {
      print('   ☁️ Saving to Firestore...');
      
      final batch = _firestore.batch();
      final chatRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('chat_messages');

      final recentMessages = messages.length >= 2
          ? messages.sublist(messages.length - 2)
          : messages;

      for (var message in recentMessages) {
        final docRef = chatRef.doc(message.timestamp.millisecondsSinceEpoch.toString());
        batch.set(docRef, message.toFirestore());
      }

      await batch.commit();
      
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      print('   ✅ Saved ${recentMessages.length} messages to Firestore in ${duration}ms');
      
      _cleanupOldMessages(userId);
    } catch (e) {
      print('   ❌ Firestore save failed: $e');
    }
  }

  Future<void> _cleanupOldMessages(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('chat_messages')
          .orderBy('timestamp', descending: true)
          .get();

      if (snapshot.docs.length > _maxMessagesInFirestore) {
        final batch = _firestore.batch();
        final docsToDelete = snapshot.docs.skip(_maxMessagesInFirestore);

        for (var doc in docsToDelete) {
          batch.delete(doc.reference);
        }

        await batch.commit();
        print('   🧹 Cleaned up ${docsToDelete.length} old messages from Firestore');
      }
    } catch (e) {
      print('   ⚠️ Cleanup failed: $e');
    }
  }

  Future<void> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    print('\n💬 ========== SENDING MESSAGE ==========');
    print('📤 User: ${userMessage.trim()}');

    messages.add(ChatMessage(
      role: 'user',
      content: userMessage.trim(),
    ));

    print('⏱️ Saving to cache...');
    await _saveToCache();

    isTyping.value = true;

    try {
      final context = await _getUserContext();
      print('🔧 User context: ${context.keys.join(", ")}');

      final history = messages
          .skip(messages.length > 10 ? messages.length - 10 : 0)
          .where((m) => m.role != 'system')
          .map((m) => {
                'role': m.role,
                'content': m.content,
              })
          .toList();

      print('📡 Calling backend API...');
      final response = await http.post(
        Uri.parse('$_baseUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': userMessage,
          'conversationHistory': history,
          'userContext': context,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        print('✅ AI Response received');
        print('🤖 Assistant: ${data['response'].substring(0, 50)}...');
        
        // Add AI response
        messages.add(ChatMessage(
          role: 'assistant',
          content: data['response'],
          isNew: true, // ✅ This is a new message - show typewriter effect
        ));

        if (data['suggestions'] != null && (data['suggestions'] as List).isNotEmpty) {
          quickSuggestions.value = List<String>.from(data['suggestions']);
          print('💡 Updated ${quickSuggestions.length} suggestions');
        }

        print('⏱️ Saving to cache and Firestore...');
        await Future.wait([
          _saveToCache(),
          _saveToFirestore(),
        ]);
        
        print('✅ Message saved successfully!');

      } else {
        throw Exception('Chat API failed: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Chat error: $e');
      messages.add(ChatMessage(
        role: 'assistant',
        content: 'Sorry, I\'m having trouble connecting right now. Please try again! 🙏',
      ));
      await _saveToCache();
    } finally {
      isTyping.value = false;
      print('💬 ========== MESSAGE COMPLETE ==========\n');
    }
  }

  Future<Map<String, dynamic>> _getUserContext() async {
    final context = <String, dynamic>{};

    try {
      if (Get.isRegistered<WorkoutPlanController>()) {
        final planController = Get.find<WorkoutPlanController>();
        final plan = planController.currentPlan.value;

        if (plan != null) {
          context['currentDay'] = plan.currentDay;
          context['totalDays'] = plan.totalDays;
          context['goalName'] = plan.planTitle;
          context['currentStreak'] = planController.userStreak.value;

          final currentDayPlan = plan.getDayByNumber(plan.currentDay);
          if (currentDayPlan != null && currentDayPlan.intensity.isNotEmpty) {
            if (currentDayPlan.intensity.contains('Menstruation')) {
              context['cyclePhase'] = 'Menstruation';
            } else if (currentDayPlan.intensity.contains('Follicular')) {
              context['cyclePhase'] = 'Follicular';
            } else if (currentDayPlan.intensity.contains('Ovulation')) {
              context['cyclePhase'] = 'Ovulation';
            } else if (currentDayPlan.intensity.contains('Luteal')) {
              context['cyclePhase'] = 'Luteal';
            }
          }
        }
      }
    } catch (e) {
      print('⚠️ Could not build user context: $e');
    }

    return context;
  }

  void useSuggestion(String suggestion) {
    print('💡 Using suggestion: $suggestion');
    sendMessage(suggestion.replaceAll(RegExp(r'[💪🥗🎯🌸😌🍵🔥😴]'), '').trim());
  }

  void clearChat() async {
    print('\n🧹 ========== CLEARING CHAT ==========');
    
    messages.clear();
    _addWelcomeMessage();
    
    await _saveToCache();
    print('   ✅ Cache cleared');
    
    final userId = _userService.currentUser.value?.uid;
    if (userId != null) {
      try {
        final snapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('chat_messages')
            .get();

        final batch = _firestore.batch();
        for (var doc in snapshot.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
        print('   ✅ Firestore cleared (${snapshot.docs.length} messages deleted)');
      } catch (e) {
        print('   ⚠️ Failed to clear Firestore: $e');
      }
    }
    
    print('🧹 ========== CLEAR COMPLETE ==========\n');
  }

    void _addWelcomeMessage() {
      messages.add(ChatMessage(
        role: 'assistant',
        content: 'Hi! 👋 I\'m your fitness coach. How can I help you today?',
        isNew: true, // ✅ Show typewriter for welcome message
      ));
    }
}