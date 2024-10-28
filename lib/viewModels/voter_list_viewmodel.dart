import '../models/voter.dart';
import '../services/database/voter_service.dart';

class VoterListViewModel {
  final _voterService = VoterService();
  List<Voter> voters = [];
  bool isLoading = false;

  Future<void> loadVoters() async {
    isLoading = true;
    try {
      voters = await _voterService.getAllVoters();
      print('Loaded ${voters.length} voters'); // Debug
    } catch (e) {
      print('Error loading voters: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> deleteVoter(int id) async {
    try {
      await _voterService.delete(id);
      await loadVoters();
    } catch (e) {
      print('Error deleting voter: $e');
    }
  }
}
