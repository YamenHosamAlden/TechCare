class PermissionHandler {
  final Set<String> permissions;
  PermissionHandler({
    required this.permissions,
  });

  bool get canAddReceipt {
    return (permissions.contains(Permissions.admin.name) &&
        permissions.contains(Permissions.user1.name));
  }
}

enum Permissions {
  admin,
  user1,
  user2,
  user3,
}
