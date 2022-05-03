import 'package:bloc/bloc.dart';
import 'package:flutter_ntf_marketplace/entities/wallet/wallet.dart';
import 'package:flutter_ntf_marketplace/services/local/local_provider.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LocalProvider _localProvider;
  AuthBloc(this._localProvider) : super(const AuthState.unauthenticated()) {
    on<_AuthInitial>((event, emit) async {
      emit(await _authStart());
    });
    on<_AuthLoggedIn>((event, emit) => {});
    on<_AuthLoggedOut>((event, emit) => {});
  }

  Future<AuthState> _authStart() async {
    await _clearIfFirstRunAfterUninstall();

    String walletSelected = _localProvider.getWalletSeleted();
    List<String> wallets = _localProvider.getWalletsImported();
    // return AuthenticatedNoPassword(walletAddress: walletSelected);
    if (wallets.isNotEmpty) {
      if (walletSelected.isEmpty) {
        await _localProvider.saveWalletSelected(walletSelected: wallets.first);
      }
      return AuthenticatedNoPassword(walletAddress: walletSelected);
    } else {
      return const UnAuthenticated();
    }
  }

  Future<void> _clearIfFirstRunAfterUninstall() async {
    if (_localProvider.isFirstRunApp()) {
      await Future.wait([
        _localProvider.saveWalletSelected(walletSelected: ""),
        _localProvider.deleteAllPrivateKey(),
        _localProvider.saveMnemonicPhrase(mnemonicPhrase: ""),
        _localProvider.saveStateFirstRunApp(isFirstRun: false),
        _localProvider.deletePasscode(),
      ]);
    }
  }
}
