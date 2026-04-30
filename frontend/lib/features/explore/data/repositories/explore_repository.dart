import 'package:farmcom/core/domain/repositories/iexplore_repository.dart';
import 'package:farmcom/core/utils/logger.dart';

class ExploreRepository implements IExploreRepository {
  @override
  Future<List<Crop>> fetchAllCrops() async {
    Logger.warning('Explore feature not yet implemented: fetchAllCrops');
    return [];
  }

  @override
  Future<List<Crop>> searchCrops(String query) async {
    Logger.warning('Explore feature not yet implemented: searchCrops');
    return [];
  }
  
  @override
  Future<Crop?> getCropDetails(String cropId) async {
    Logger.warning('Explore feature not yet implemented: getCropDetails');
    return null;
  }
  
  @override
  Stream<List<Crop>> watchCrops() async* {
    Logger.warning('Explore feature not yet implemented: watchCrops');
    yield [];
  }
  
  @override
  Future<List<Disease>> getCropDiseases(String cropId) async {
    Logger.warning('Explore feature not yet implemented: getCropDiseases');
    return [];
  }
  
  @override
  Future<List<Disease>> searchDiseases(String query) async {
    Logger.warning('Explore feature not yet implemented: searchDiseases');
    return [];
  }
  
  @override
  Future<List<GrowingTip>> getGrowingTips(String cropId) async {
    Logger.warning('Explore feature not yet implemented: getGrowingTips');
    return [];
  }
  
  @override
  Future<void> addToFavorites(String cropId) async {
    Logger.warning('Explore feature not yet implemented: addToFavorites');
    // TODO: Implement - save to Isar
  }
  
  @override
  Future<void> removeFromFavorites(String cropId) async {
    Logger.warning('Explore feature not yet implemented: removeFromFavorites');
    // TODO: Implement
  }
  
  @override
  Future<List<Crop>> getFavoriteCrops() async {
    Logger.warning('Explore feature not yet implemented: getFavoriteCrops');
    return [];
  }
  
  @override
  Future<void> addNote(String cropId, String note) async {
    Logger.warning('Explore feature not yet implemented: addNote');
    // TODO: Implement - save note to Isar
  }
  
  @override
  Future<List<CropNote>> getNotesForCrop(String cropId) async {
    Logger.warning('Explore feature not yet implemented: getNotesForCrop');
    return [];
  }
}
