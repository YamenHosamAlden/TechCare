part of 'saerch_bloc.dart';

abstract class SaerchEvent extends Equatable {
  const SaerchEvent();

  @override
  List<Object> get props => [];
}

class ChangeSearchType extends SaerchEvent {
  final SearchType searchType;
  const ChangeSearchType({required this.searchType});
}

class Search extends SaerchEvent {
  final String term;
  const Search({required this.term});
}

class LoadMoreSearchByDevice extends SaerchEvent {
  final String term;
  const LoadMoreSearchByDevice({required this.term});
}
class LoadMoreSearchByReceipt extends SaerchEvent {
  final String term;
  const LoadMoreSearchByReceipt({required this.term});
}
