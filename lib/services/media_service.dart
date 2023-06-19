import 'package:photo_manager/photo_manager.dart';

class MediaService {
  Future loadAlbums(RequestType requestType) async {
    final permission = await PhotoManager.requestPermissionExtend();
    List<AssetPathEntity> albums = [];
    if (permission.isAuth) {
      albums = await PhotoManager.getAssetPathList(
        type: requestType,
      );
    } else {
      PhotoManager.openSetting();
    }
    return albums;
  }

  Future loadAssets(AssetPathEntity album) async {
    final assetCount = await album.assetCountAsync;
    final assets = await album.getAssetListRange(
      start: 0,
      end: assetCount,
    );

    return assets;
  }
}
