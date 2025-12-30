import 'package:flutter/foundation.dart';
import 'security_service.dart';
import '../models/models.dart';

// Result class for group creation operations
class GroupCreationResult {
  final bool isSuccess;
  final GroupModel? group;
  final String? error;

  GroupCreationResult.success({required this.group})
      : isSuccess = true,
        error = null;

  GroupCreationResult.failure({required this.error})
      : isSuccess = false,
        group = null;
}

// Interface for group services to allow for testing
abstract class GroupServiceInterface {
  Future<GroupModel?> getGroupByID(String groupID);
  Future<void> addGroup(GroupModel group);
  Future<void> updateGroup(GroupModel group);
  Future<List<GroupModel>> getAllGroups();
  Future<List<GroupModel>> getGroupsCreatedByAdmin(String adminId);
  Future<void> deleteGroupAsAdmin(String groupId);
  Future<void> removeUserFromGroup(String groupId, String userId);
}

// Service dedicated to handling group creation logic
class GroupCreationService {
  final GroupServiceInterface _groupServices;

  GroupCreationService(this._groupServices);

  // Generate a unique random group ID with collision detection
  Future<String> generateUniqueRandomGroupID() async {
    const maxAttempts = 50; // Prevent infinite loops
    int attempts = 0;

    while (attempts < maxAttempts) {
      final randomID = GroupModel.generateRandomGroupID().toString();
      final existingGroup = await _groupServices.getGroupByID(randomID);

      if (existingGroup == null) {
        return randomID;
      }

      attempts++;
    }

    throw Exception('Could not generate a unique group ID after $maxAttempts attempts');
  }

  // Validate group creation parameters with security checks
  String? validateGroupParameters({
    required String groupID,
    required String name,
    required int count,
    required HatimStyle hatimStyle,
    String? userId,
  }) {
    // Security validation first
    if (!SecurityService.isValidGroupID(groupID)) {
      return 'Group ID must be exactly 6 digits containing only numbers';
    }

    if (!SecurityService.isValidGroupName(name)) {
      return 'Group name must be 3-50 characters long and contain no special characters';
    }

    // Rate limiting check
    if (userId != null && !SecurityService.canCreateGroup(userId)) {
      final remaining = SecurityService.getRemainingAttempts(userId);
      return 'Rate limit exceeded. You can create $remaining more groups in the next hour.';
    }

    // Validate count based on hatim style
    if (hatimStyle == HatimStyle.allTogetherInOneHatim) {
      // For "All Together in One Hatim", count must be exactly 30
      if (count != 30) {
        return 'All Together in One Hatim must have exactly 30 people';
      }
    } else {
      // For other styles, count can be flexible between 1 and 100
      if (count < 1) {
        return 'Group must allow at least 1 user';
      }

      if (count > 100) {
        return 'Group cannot exceed 100 users';
      }
    }

    return null; // No validation errors
  }

  // Create group with comprehensive validation and error handling
  Future<GroupCreationResult> createGroup({
    required String groupID,
    required String name,
    required GroupDateType groupDateType,
    required HatimStyle hatimStyle,
    required int count,
    String? adminId,
    String? userId,
  }) async {
    // Sanitize inputs
    final sanitizedGroupID = SecurityService.sanitizeGroupID(groupID);
    final sanitizedName = SecurityService.sanitizeGroupName(name);

    // Validate parameters
    final validationError = validateGroupParameters(
      groupID: sanitizedGroupID,
      name: sanitizedName,
      count: count,
      hatimStyle: hatimStyle,
      userId: userId,
    );

    if (validationError != null) {
      return GroupCreationResult.failure(error: validationError);
    }

    // Check if group ID already exists
    final existingGroup = await _groupServices.getGroupByID(sanitizedGroupID);
    if (existingGroup != null) {
      return GroupCreationResult.failure(error: 'Group with ID $sanitizedGroupID already exists');
    }

    // Create the group model
    final group = GroupModel.withCustomInfo(
      groupID: sanitizedGroupID,
      name: sanitizedName,
      adminId: adminId,
      dateType: groupDateType,
      hatimStyle: hatimStyle,
      userCount: count,
    );

    // Save to database
    await _groupServices.addGroup(group);

    if (kDebugMode) {
      print('Successfully created group: ${group.groupID}');
    }

    return GroupCreationResult.success(group: group);
  }

  // Create group with auto-generated ID
  Future<GroupCreationResult> createGroupWithRandomID({
    required String name,
    required GroupDateType groupDateType,
    required HatimStyle hatimStyle,
    required int count,
    String? adminId,
    String? userId,
  }) async {
    final groupID = await generateUniqueRandomGroupID();

    return createGroup(
      groupID: groupID,
      name: name,
      groupDateType: groupDateType,
      hatimStyle: hatimStyle,
      count: count,
      adminId: adminId,
      userId: userId,
    );
  }
}