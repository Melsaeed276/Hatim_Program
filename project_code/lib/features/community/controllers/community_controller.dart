import 'package:flutter/foundation.dart';

import '../models/models.dart';
import '../services/community_service.dart';

class CommunityController extends ChangeNotifier {
  final CommunityService _service;

  CommunityController({CommunityService? service})
    : _service = service ?? CommunityService();

  CommunityService get service => _service;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? e) {
    _error = e;
    notifyListeners();
  }

  Future<void> requestJoin({
    required String communityId,
    required String userId,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      await _service.createJoinRequest(
        communityId: communityId,
        userId: userId,
      );
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> redeemCode({
    required String userId,
    required String code,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      return await _service.redeemInviteCode(userId: userId, code: code);
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> leave({
    required String communityId,
    required String userId,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      await _service.leaveCommunity(communityId: communityId, userId: userId);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> approveJoin({
    required String communityId,
    required String requestId,
    required String adminId,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      await _service.approveJoinRequest(
        communityId: communityId,
        requestId: requestId,
        adminId: adminId,
      );
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> rejectJoin({
    required String communityId,
    required String requestId,
    required String adminId,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
      await _service.rejectJoinRequest(
        communityId: communityId,
        requestId: requestId,
        adminId: adminId,
      );
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  bool hasPermission(CommunityMember? member, String permission) {
    if (member == null) return false;
    return hasCommunityPermission(member.permissions, permission);
  }
}
