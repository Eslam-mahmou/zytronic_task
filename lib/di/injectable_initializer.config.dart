// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../data/data_source/chat_data_source.dart' as _i372;
import '../data/reposiatory_impl/chat_repository_impl.dart' as _i754;
import '../domain/reposiatory/chat_repo.dart' as _i983;
import '../domain/use_case/chat_use_case.dart' as _i569;
import '../presentaion/chat_screen/manager/chat_screen_view_model.dart'
    as _i1051;
import '../presentaion/layout/manager/home_tab_cubit/home_tab_view_model.dart'
    as _i824;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i372.ChatDataSource>(() => _i372.ChatDataSourceImpl());
    gh.factory<_i983.ChatRepository>(
      () => _i754.ChatRepositoryImpl(gh<_i372.ChatDataSource>()),
    );
    gh.factory<_i569.ChatUseCase>(
      () => _i569.ChatUseCase(gh<_i983.ChatRepository>()),
    );
    gh.factory<_i1051.ChatCubit>(
      () => _i1051.ChatCubit(gh<_i569.ChatUseCase>()),
    );
    gh.factory<_i824.HomeChatCubit>(
      () => _i824.HomeChatCubit(gh<_i569.ChatUseCase>()),
    );
    return this;
  }
}
