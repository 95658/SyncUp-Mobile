import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncup/app/core/widgets/common/error_state_view.dart';

extension FutureProviderExtension on WidgetRef {
  Widget watchWhen<T>({
    required ProviderListenable<AsyncValue<T>> provider,
    required Widget Function(T data) data,
    Widget Function()? loading,
    Widget Function(Object error, StackTrace stackTrace)? error,
    VoidCallback? onRetry,
  }) {
    final asyncValue = watch(provider);

    return asyncValue.when(
      data: data,
      loading: loading ??
          () => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
      error: error ??
          (err, stack) => ErrorStateView(
                message: err.toString(),
                onRetry: onRetry,
              ),
    );
  }
}
