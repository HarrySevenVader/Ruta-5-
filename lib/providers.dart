import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/auth/data/repositories/firebase_auth_repository.dart';
import '../../features/auth/domain/usecases/get_id_token.dart';
import '../../features/auth/domain/usecases/register_with_email_password.dart';
import '../../features/auth/domain/usecases/sign_in_with_email_password.dart';
import '../../features/auth/domain/usecases/sign_in_with_google.dart';
import '../../features/auth/presentation/viewmodels/login_viewmodel.dart';
import '../../features/auth/presentation/viewmodels/register_viewmodel.dart';

import '../../features/menu/data/datasources/menu_api_datasource.dart';
import '../../features/menu/data/repositories/menu_repository_impl.dart';
import '../../features/menu/data/repositories/rating_repository_impl.dart';
import '../../features/menu/domain/usecases/get_today_menu.dart';
import '../../features/menu/domain/usecases/submit_rating.dart';
import '../../features/menu/presentation/viewmodels/menu_viewmodel.dart';
import '../../features/menu/presentation/viewmodels/rating_viewmodel.dart';

List<SingleChildWidget> appProviders() {
  final authRepository = FirebaseAuthRepository();
  final menuRepository = MenuRepositoryImpl(MenuApiDatasource());
  final ratingRepository = RatingRepositoryImpl();

  return [
    ChangeNotifierProvider(
      create:
          (_) => LoginViewModel(
            signInWithGoogle: SignInWithGoogle(authRepository),
            signInWithEmailPassword: SignInWithEmailPassword(authRepository),
            getIdToken: GetIdToken(authRepository),
          ),
    ),
    ChangeNotifierProvider(
      create:
          (_) => RegisterViewModel(RegisterWithEmailPassword(authRepository)),
    ),
    ChangeNotifierProvider(
      create: (_) => MenuViewModel(GetTodayMenu(menuRepository)),
    ),
    ChangeNotifierProvider(
      create:
          (_) => RatingViewModel(submitRating: SubmitRating(ratingRepository)),
    ),
  ];
}
