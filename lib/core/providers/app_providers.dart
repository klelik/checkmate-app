import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/mock/mock_vehicle_service.dart';
import '../../domain/entities/vehicle_check_entity.dart';
import '../../domain/repositories/vehicle_check_repository.dart';

// Repository provider
final vehicleCheckRepositoryProvider = Provider<VehicleCheckRepository>((ref) {
  return MockVehicleService();
});

// Theme mode provider
final themeModeProvider = StateProvider<bool>((ref) => true); // true = dark

// Current check state
final currentCheckProvider =
    StateProvider<VehicleCheckResult?>((ref) => null);

// Saved checks (garage)
final savedChecksProvider =
    StateNotifierProvider<SavedChecksNotifier, List<VehicleCheckResult>>((ref) {
  return SavedChecksNotifier(ref.read(vehicleCheckRepositoryProvider));
});

class SavedChecksNotifier extends StateNotifier<List<VehicleCheckResult>> {
  final VehicleCheckRepository _repository;

  SavedChecksNotifier(this._repository) : super([]) {
    _load();
  }

  Future<void> _load() async {
    state = await _repository.getSavedChecks();
  }

  Future<void> addCheck(VehicleCheckResult check) async {
    await _repository.saveCheck(check);
    state = await _repository.getSavedChecks();
  }

  Future<void> removeCheck(String reg) async {
    await _repository.deleteCheck(reg);
    state = await _repository.getSavedChecks();
  }
}

// Vehicle check action provider
final performCheckProvider =
    FutureProvider.family<VehicleCheckResult, String>((ref, reg) async {
  final repository = ref.read(vehicleCheckRepositoryProvider);
  return repository.performFullCheck(reg);
});

// Compare vehicles
final compareVehicle1Provider =
    StateProvider<VehicleCheckResult?>((ref) => null);
final compareVehicle2Provider =
    StateProvider<VehicleCheckResult?>((ref) => null);

// Onboarding completed
final onboardingCompletedProvider = StateProvider<bool>((ref) => false);

// Check history (recent)
final recentChecksProvider =
    StateNotifierProvider<RecentChecksNotifier, List<VehicleCheckResult>>((ref) {
  return RecentChecksNotifier();
});

class RecentChecksNotifier extends StateNotifier<List<VehicleCheckResult>> {
  RecentChecksNotifier() : super([]);

  void addCheck(VehicleCheckResult check) {
    state = [
      check,
      ...state.where((c) => c.registrationNumber != check.registrationNumber)
    ].take(10).toList();
  }
}
