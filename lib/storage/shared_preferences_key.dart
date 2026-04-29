enum SharedPreferencesKey {
  appCounter('app_counter'),
  lastSyncAt('last_sync_at');

  const SharedPreferencesKey(this.storageKey);

  final String storageKey;
}
