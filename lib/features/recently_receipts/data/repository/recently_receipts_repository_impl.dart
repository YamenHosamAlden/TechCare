import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tech_care_app/core/error/exceptions.dart';
import 'package:tech_care_app/core/error/failures.dart';
import 'package:tech_care_app/core/network/network_info.dart';
import 'package:tech_care_app/features/recently_receipts/data/datasource/recently_receipts_data_source.dart';
import 'package:tech_care_app/features/recently_receipts/domain/repository/recently_receipts_repository.dart';
import 'package:tech_care_app/features/saerch/domain/entity/receipt_container.dart';

class RecentlyReceiptsRepositoryImpl implements RecentlyReceiptsRepository {
  final NetworkInfo networkInfo;
  RecentlyReceiptsDataSource recentlyAddedReceiptsDataSource;

  RecentlyReceiptsRepositoryImpl(
      {required this.recentlyAddedReceiptsDataSource,
      required this.networkInfo});

  List<ReceiptContainer>? _recentlyReceiptsList;

  int _recentlyReceiptsPage = 1;

  @override
  Future<Either<Failure, List<ReceiptContainer>>>
      getRecentlyAddedReceipts() async {
    if (await networkInfo.isConnected) {
      try {
        _recentlyReceiptsList = await recentlyAddedReceiptsDataSource
            .getRecentlyAddedReceipts(_recentlyReceiptsPage);
        _recentlyReceiptsPage++;
      } on DioException catch (error) {
        return Left(DioFailure(error: error));
      } catch (e) {
        print(e);
        return Left(UnknownFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }

    return Right(_recentlyReceiptsList ?? []);
  }

  @override
  Future<Either<Failure, List<ReceiptContainer>>>
      loadMoreRecentlyAddedReceipts() async {
    if (await networkInfo.isConnected) {
      try {
        final int tempPage = _recentlyReceiptsPage;
        List<ReceiptContainer> receiptsList =
            await recentlyAddedReceiptsDataSource
                .getRecentlyAddedReceipts(_recentlyReceiptsPage);

        if (receiptsList.isNotEmpty) {
          _checkForDuplication(
              baseList: _recentlyReceiptsList!, newReceipts: receiptsList);
          _recentlyReceiptsPage = tempPage + 1;
        }
      } on DioException catch (error) {
        return Left(DioFailure(error: error));
      } on ServerException {
        return Left(ServerFailure());
      } catch (e) {
        return Left(UnknownFailure());
      }
    } else {
      return Left(InternetConnectionFailure());
    }

    return Right(_recentlyReceiptsList ?? []);
  }

  @override
  Future<Either<Failure, List<ReceiptContainer>>>
      reloadRecentlyAddedReceipts() {
    _recentlyReceiptsList?.clear();
    _recentlyReceiptsPage = 1;
    return getRecentlyAddedReceipts();
  }

  void _checkForDuplication(
      {required List<ReceiptContainer> baseList,
      required List<ReceiptContainer> newReceipts}) {
    newReceipts.forEach((newReceipt) {
      if (baseList.contains(newReceipt)) {
        return;
      }
      baseList.add(newReceipt);
    });
  }

  @override
  void resetRecentlyReceipts() async {
    _recentlyReceiptsPage = 1;
    _recentlyReceiptsList?.clear();
  }
}
