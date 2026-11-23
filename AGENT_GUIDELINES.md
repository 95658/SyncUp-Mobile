# Antigravity & AI Agent Development Guidelines

> **Instruction for AI Agents**: You are acting as the lead software engineer on this project. You MUST follow the exact architectural patterns, state management paradigms, component system, and coding idioms specified in this document. Do not invent alternative state patterns (e.g. standard BLoC, MobX, raw setState, or vanilla ChangeNotifier) and do not use unapproved UI widgets when dedicated custom widgets exist.

---

## 1. Architecture Overview (Feature-First)

The project follows a **Feature-First Clean Architecture** with strict modularity under `lib/app/`:

```
lib/
├── app/
│   ├── core/                  # Shared foundations, widgets, network, theme, styles
│   │   ├── api_helper/        # DioClient, Endpoints, ResponseClient, Exceptions
│   │   ├── constants/         # Keys, Dimensions, Typedefs (Json)
│   │   ├── enums/             # App-wide enums
│   │   ├── extensions/        # Context, Route, Theme, String extensions
│   │   ├── models/            # Core models (CustomState, SearchManager)
│   │   ├── styles/            # Atomic Typography (style_atoms), Decorations
│   │   ├── themes/            # AppColors, ThemeData
│   │   └── widgets/           # Global design system components
│   ├── features/              # Feature modules
│   │   └── <feature_name>/
│   │       ├── data/
│   │       │   ├── models/    # Data Transfer Objects (fromJson/toJson)
│   │       │   └── service/   # API repositories calling DioClient
│   │       └── presentation/
│   │           ├── controller/# Riverpod providers & logic classes
│   │           ├── screens/   # Route pages (@RoutePage) & listeners
│   │           └── widgets/   # Sub-views, cards, body layouts
│   ├── router/                # AutoRoute setup & generated routes
│   └── services/              # Global singleton services (FCM, Location, Sentry)
├── generated/                 # Generated files (slang translations, assets)
└── main.dart                  # App bootstrap & Flavor entry
```

---

## 2. State Management: The Signature CustomState & Dual-Class Pattern

We use **Riverpod 2.x**, but business logic and UI state are orchestrated using our custom **Dual-Class Logic/States pattern** powered by `CustomState<T>`.

### The CustomState Primitive (`lib/app/core/models/custom_state.dart`)
`CustomState<T>` encapsulates a Riverpod `StateProvider<T>`, allowing state modification without calling `ref.read(provider.notifier).state = ...` everywhere, while retaining full reactive listening capabilities:

```dart
class CustomState<T> {
  final ProviderRef ref;
  final T initialValue;
  final StateProvider<T> provider;
  late T prevValue;

  CustomState(this.ref, this.initialValue)
      : provider = StateProvider<T>((ref) => initialValue),
        prevValue = initialValue;

  set state(T state) {
    if (prevValue == state) ref.invalidate(provider);
    ref.read(provider.notifier).state = state;
    prevValue = state;
  }

  T get state => ref.read(provider.notifier).state;
}
```

### The Standard Controller Architecture
Every feature controller MUST follow this exact structure:
1. Public `Provider<_XxxLogic>`
2. Private `_XxxLogic` extending `_XxxStates` (holds methods, controllers, business actions)
3. Private `_XxxStates` (holds all `CustomState<T>` variables initialized with `ref`)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tazj_user_mobile/app/core/api_helper/exceptions.dart';
import 'package:tazj_user_mobile/app/core/models/custom_state.dart';
import 'package:tazj_user_mobile/app/features/example/data/service/example_service.dart';

// 1. Public Provider
final exampleProvider = Provider<_ExampleLogic>(
  (ref) => _ExampleLogic(
    ref: ref,
    service: ref.watch(exampleServiceProvider),
  ),
);

// 2. Logic Implementation
class _ExampleLogic extends _ExampleStates {
  _ExampleLogic({required super.ref, required this.service});

  final ExampleService service;
  final formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  Future<void> performAction() async {
    try {
      if (!formKey.currentState!.validate()) return;
      isLoading.state = true;
      
      final result = await service.fetchData();
      data.state = result;
      isSuccess.state = true;
    } on ApiException catch (e) {
      isError.state = e.toString();
    } finally {
      isLoading.state = false;
    }
  }

  Future<void> refreshUI() async {
    onRefresh.state = true;
    await Future.delayed(const Duration(milliseconds: 50));
    onRefresh.state = false;
  }
}

// 3. States Definition
class _ExampleStates {
  final ProviderRef ref;
  final CustomState<bool> isLoading;
  final CustomState<bool> onRefresh;
  final CustomState<bool> isSuccess;
  final CustomState<String> isError;
  final CustomState<String?> data;

  _ExampleStates({required this.ref})
      : isLoading = CustomState(ref, false),
        onRefresh = CustomState(ref, false),
        isSuccess = CustomState(ref, false),
        isError = CustomState(ref, ''),
        data = CustomState(ref, null);
}
```

### Data Fetching with `FutureProvider` & `ref.watchWhen`
For read-only server queries, use `FutureProvider` or `FutureProvider.family`:

```dart
final getDetailsProvider = FutureProvider.family.autoDispose<DetailsModel, int>(
  (ref, id) async {
    final service = ref.watch(exampleServiceProvider);
    return service.getDetails(id: id);
  },
);
```

In the UI, consume it using the custom extension **`ref.watchWhen`** (`lib/app/features/common/screens_not_related/future_provider_screen.dart`), which automatically hooks offline retry screens, server errors, and Sentry reports:

```dart
ref.watchWhen(
  provider: getDetailsProvider(itemId),
  loading: () => const Center(child: CircularProgressIndicator.adaptive()),
  data: (item) => DetailsView(item: item),
)
```

### Paginated Lists
Use `riverpod_infinite_scroll` with `CustomPagination<Model>`:

```dart
final allItemsProvider = StateNotifierProvider<_AllNotifier, PagedState<int, ItemModel>>(
  (ref) => _AllNotifier(ref.watch(itemServiceProvider)),
);

class _AllNotifier extends PagedNotifier<int, ItemModel> {
  final ItemService service;
  _AllNotifier(this.service)
      : super(
          load: (page, limit) => service.getItems(page: page, limit: limit),
          errorBuilder: (e) => e.toString(),
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
        );
}
```

---

## 3. Screen vs. Body Layout Pattern

Screens are strictly partitioned:
1. **Screen (`screens/xxx_screen.dart`)**:
   - Annotated with `@RoutePage()`.
   - Inherits `ConsumerWidget` or `ConsumerStatefulWidget`.
   - Houses the `Scaffold`, custom `AppBar`, and reactive `listeners(ref, context)`.
   - Delegates the inner content to a separate `Body` widget.
2. **Body (`widgets/xxx_body.dart` or `presentation/widgets/`)**:
   - Houses the scroll views, form fields, and layouts.

```dart
@RoutePage()
class ExampleScreen extends ConsumerWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    listeners(ref, context);
    return Scaffold(
      appBar: DefaultAppBar(title: tr.example.title),
      body: const ExampleBody(),
    );
  }

  void listeners(WidgetRef ref, BuildContext context) {
    final provider = ref.read(exampleProvider);
    
    // SnackBar errors
    ref.listen(provider.isError.provider, (previous, current) {
      if (current.isNotEmpty) {
        context.showCustomSnackBar(message: current);
      }
    });

    // Navigation on success
    ref.listen(provider.isSuccess.provider, (previous, current) {
      if (current) {
        context.push(const SuccessRoute());
      }
    });
  }
}
```

---

## 4. Networking & Data Layer

### Typedefs
Always use the alias defined in `constants.dart`:
```dart
typedef Json = Map<String, dynamic>;
typedef ListOfJson = List<dynamic>;
```

### Services Calling `DioClient`
Inject `DioClient` via `dioClientProvider`. Wrap network calls using `ResponseClient<T>`:

```dart
final exampleServiceProvider = Provider<ExampleService>((ref) {
  return ExampleService(ref.watch(dioClientProvider));
});

class ExampleService {
  final DioClient client;
  ExampleService(this.client);

  Future<ItemModel> getItem(int id) async {
    final res = ResponseClient<Json>(
      await client.get('${Endpoints.items}/$id'),
    );
    if (res.isError) throw ApiExceptionMessage(res.message);
    return ItemModel.fromJson(res.data!);
  }

  Future<void> submitAction(Json body) async {
    final res = ResponseClient(
      await client.post(Endpoints.items, body: body),
    );
    if (res.isError) throw ApiExceptionMessage(res.message);
  }
}
```

### Exception Handling
All API exceptions inherit from `ApiException`:
- `ApiExceptionMessage(res.message)`
- `NoInternetConnection()`
- `InternalServerError()`
- `UnAuthorized(res)`

Always catch with specific `on ApiException catch (e)` clauses:
```dart
try {
  ...
} on ApiException catch (e) {
  isError.state = e.toString();
}
```

### Data Models
- Plain Dart classes (do not use Freezed or code-gen serialization unless already configured).
- Always supply `factory Model.fromJson(Map<String, dynamic> json)`.
- **Defensive Type Parsing**: API data may fluctuate between string, integer, or double. Always parse numbers defensively:
  ```dart
  totalPrice: double.parse(json['totalPrice'].toString()),
  count: json['count'] as int? ?? 0,
  logo: getImageUrl(json['logo']),
  ```
- Use `getImageUrl(json['image'])` or `getAssetPath(json['image'])` for remote image structures.

---

## 5. UI Design System & Component Library

NEVER use vanilla Flutter widgets when a project custom widget exists!

### 1. Atomic Typography (`lib/app/core/styles/style_atoms.dart`)
Never write manual `TextStyle(fontSize: ..., color: ...)` in widgets. Use the atomic extensions on `BuildContext`:
- `context.roman12TextMain`
- `context.roman14Primary`
- `context.medium16TextMain`
- `context.light14White`
- `context.medium12Danger`

### 2. Spacing
Never use raw `SizedBox(height: 16)` or `SizedBox(width: 16)`.
Use:
- `const Height(16)` or `16.h`
- `const Width(8)` or `8.w`

### 3. Clickables & Tap Targets
Never use standard `InkWell` or raw `GestureDetector` for button clicks.
Use **`CustomInkWell`** (`lib/app/core/widgets/buttons/custom_ink_well.dart`), which removes splash/hover noise and keeps clicks transparent by default:
```dart
CustomInkWell(
  onTap: () => ...,
  child: ...,
)
```

### 4. Action Buttons
- **`ConsumerButton`**: Binds directly to `CustomState<bool>` for auto-loading indicators:
  ```dart
  ConsumerButton(
    title: tr.submit,
    onPress: provider.submit,
    stateProvider: provider.isLoading,
  )
  ```
- **`CustomButton`**: Base button with support for `isLoading`, `isDisabled`, `borderColor`, and `borderRadius`.

### 5. Form Inputs
- **`CustomTextFormField`**: Handles title labels, hint styles, focus nodes, and input formatters.
- **`CustomPasswordTextFormField`**: Built-in toggle password visibility.
- Form keys and `TextEditingController` instances live inside the **logic class** (`_XxxLogic`), NOT the widget.

### 6. App Bars
- **`DefaultAppBar`**: For regular screens, includes RTL back arrow, `HeroText` animation, and scroll under elevation control.
- **`CustomAuthAppBar`**: For onboarding/auth screens with optional skip button.
- **`NoAppBar`**: Invisible zero-height app bar when no header is desired.

### 7. Images
- **`CustomCachedNetworkImage`**: Network image with automatic `ShimmerBox` placeholder, rounded borders, and broken image fallback SVG.
- Always use `Assets.<iconName>` from `lib/generated/assets.dart` for local SVG/PNG assets.

### 8. RTL & Arabic Support
Directional icons (e.g. back arrows) must be wrapped in **`CustomTransformArabic`**:
```dart
CustomTransformArabic(
  child: SvgPicture.asset('assets/icons/arrow_left.svg'),
)
```

### 9. Context Extensions (`lib/app/core/extensions/context_extensions.dart`)
- **Navigation**:
  - `context.push(Route())`
  - `context.pop()`
  - `context.pushAndPopAll(Route())`
  - `context.popAndPush(Route())`
- **Dialogs & SnackBars**:
  - `context.showCustomSnackBar(message: current, snackBarStatus: SnackBarStatus.error)`
  - `context.showCustomAlertDialog(dialog: CustomAppDialog(...))`
  - `context.showBottomSheet(bottomSheetBody: ...)`
- **Dimensions**:
  - `context.width`
  - `context.height`

---

## 6. Internationalization (i18n)

We use **`slang`**:
- Call translations via `tr.<namespace>.<key>`.
- Language files live in `assets/lang/` (`strings_en.json`, `strings_ar.json`).
- If you add or modify keys, run:
  ```bash
  flutter pub run slang
  ```
- Access current locale via `TranslationProvider.of(context).locale`.

---

## 7. Routing with AutoRoute

- Screens must be annotated with `@RoutePage()`.
- Add new routes to `routes` list in `lib/app/router/auto_router.dart`.
- After modifying routes, run:
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```
- Navigate using typed route classes: `context.push(ProductDetailsRoute(productId: id))`.

---

## 8. Code Formatting & Lint Rules

- **Quotes**: Single quotes (`'...'`) everywhere.
- **Const**: Mark all immutable constructors and widgets `const`.
- **Catch Blocks**: Do not catch generic exceptions without an `on` clause. Always use `on ApiException catch (e)` or specify the exception type.
- **Colors**: Never use magic hex colors (`Color(0xFF...)`). Use `AppColors.<color>` from `lib/app/core/themes/app_colors.dart`.
- **Dimensions & Borders**: Use `Constants.borderRadius` (8.0), `Constants.buttonHeight` (48.0), `Constants.horizontalPadding` (16.0).

---

## 9. Generation Commands Quick Reference

Whenever adding files or modifying assets/routes/translations, run the corresponding command:

- **Build Runner (AutoRoute & Riverpod)**:
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```
- **Translations (Slang)**:
  ```bash
  flutter pub run slang
  ```
- **Assets Generator**:
  ```bash
  flutter pub run flutter_assets_generator
  ```
