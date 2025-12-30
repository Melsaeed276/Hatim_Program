import 'package:flutter/foundation.dart';
import 'package:hatim_program/service/reference_code_service.dart';
import 'package:hatim_program/service/user_services.dart';
import '../models/models.dart';

class AdminReferralController extends ChangeNotifier {
  final ReferenceCodeService _service = ReferenceCodeService();

  List<ReferenceCodeModel> _adminCodes = [];
  List<ReferenceCodeModel> get adminCodes => _adminCodes;

  List<UserModel> _referredUsers = [];
  List<UserModel> get referredUsers => _referredUsers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Load codes and users for the admin
  Future<void> loadAdminReferralData(String adminId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _adminCodes = await _service.getAdminCodes(adminId);
      _referredUsers = await _service.getReferredUsers(adminId);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading admin referral data: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Generate a new reference code
  Future<String?> generateCode(String adminId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final code = await _service.generateCode(adminId);
      await loadAdminReferralData(adminId); // Refresh data
      return code;
    } catch (e) {
      if (kDebugMode) {
        print('Error generating code: $e');
      }
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create a custom reference code
  Future<bool> createCustomCode(String code, String adminId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _service.createCustomCode(code, adminId);
      if (success) {
        await loadAdminReferralData(adminId); // Refresh data
      }
      return success;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating custom code: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Filter users who are not yet in a specific group
  List<UserModel> getUsersNotInGroup(List<String> groupUserIds) {
    return _referredUsers
        .where((user) => !groupUserIds.contains(user.id))
        .toList();
  }

  /// Delete a reference code
  Future<bool> deleteCode(String code, String adminId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.deleteCode(code);
      if (result) {
        await loadAdminReferralData(adminId); // Refresh data
      }
      return result;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting code: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Remove a user from the referral list
  Future<bool> removeUserFromReferrals(String userId, String adminId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await UserServices().removeUserFromReferrals(userId);
      if (result) {
        await loadAdminReferralData(adminId); // Refresh data
      }
      return result;
    } catch (e) {
      if (kDebugMode) {
        print('Error removing user from referrals: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
