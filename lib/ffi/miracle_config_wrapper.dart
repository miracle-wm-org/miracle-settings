import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:miracle_settings/shared/ffi_library.dart';
import 'miracle_config_generated.dart';

// Initialize the FFI library
final _lib = tryLoadLibrary('libmiracle-wm-config.so')!;
final _ffi = MiracleFfi(_lib);

// Helper classes and enums

class MiracleOption {
  final String name;
  final int value;

  MiracleOption({required this.name, required this.value});
}

enum MiracleConfigErrorLevel { warning, error }

class MiracleConfigError {
  final int line;
  final int column;
  final MiracleConfigErrorLevel level;
  final String filename;
  final String message;

  MiracleConfigError({
    required this.line,
    required this.column,
    required this.level,
    required this.filename,
    required this.message,
  });
}

class MiracleConfigSaveResult {
  final bool success;
  final List<MiracleConfigError> errors;

  MiracleConfigSaveResult({
    required this.success,
    required this.errors,
  });
}

class MiracleCustomKeyCommand {
  final int action;
  final int modifiers;
  final int key;
  final String command;

  MiracleCustomKeyCommand({
    required this.action,
    required this.modifiers,
    required this.key,
    required this.command,
  });
}

class MiracleBuiltInKeyCommand {
  final int action;
  final int modifiers;
  final int key;
  final int builtInAction;

  MiracleBuiltInKeyCommand({
    required this.action,
    required this.modifiers,
    required this.key,
    required this.builtInAction,
  });
}

class MiracleStartupApp {
  final String command;
  final bool restartOnDeath;
  final bool noStartupId;
  final bool shouldHaltCompositorOnDeath;
  final bool inSystemdScope;

  MiracleStartupApp({
    required this.command,
    required this.restartOnDeath,
    required this.noStartupId,
    required this.shouldHaltCompositorOnDeath,
    required this.inSystemdScope,
  });
}

class MiracleEnvVar {
  final String key;
  final String value;

  MiracleEnvVar({required this.key, required this.value});
}

class MiracleBorderConfig {
  final int size;
  final double radius;
  final Color focusColor;
  final Color color;

  MiracleBorderConfig({
    required this.size,
    required this.radius,
    required this.focusColor,
    required this.color,
  });
}

class MiracleAnimationDefinition {
  final MiracleAnimationType type;
  final MiracleEaseFunction function;
  final double durationSeconds;
  final double c1;
  final double c2;
  final double c3;
  final double c4;
  final double c5;
  final double n1;
  final double d1;

  MiracleAnimationDefinition({
    required this.type,
    required this.function,
    required this.durationSeconds,
    this.c1 = 0.0,
    this.c2 = 0.0,
    this.c3 = 0.0,
    this.c4 = 0.0,
    this.c5 = 0.0,
    this.n1 = 0.0,
    this.d1 = 0.0,
  });

  MiracleAnimationDefinition copyWith({
    MiracleAnimationType? type,
    MiracleEaseFunction? function,
    double? durationSeconds,
    double? c1,
    double? c2,
    double? c3,
    double? c4,
    double? c5,
    double? n1,
    double? d1,
  }) {
    return MiracleAnimationDefinition(
      type: type ?? this.type,
      function: function ?? this.function,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      c1: c1 ?? this.c1,
      c2: c2 ?? this.c2,
      c3: c3 ?? this.c3,
      c4: c4 ?? this.c4,
      c5: c5 ?? this.c5,
      n1: n1 ?? this.n1,
      d1: d1 ?? this.d1,
    );
  }
}

enum MiracleAnimationType {
  none,
  slide,
  grow,
  fade,
}

enum MiracleEaseFunction {
  linear,
  easeInSine,
  easeOutSine,
  easeInOutSine,
  easeInQuad,
  easeOutQuad,
  easeInOutQuad,
  easeInCubic,
  easeOutCubic,
  easeInOutCubic,
  easeInQuart,
  easeOutQuart,
  easeInOutQuart,
  easeInQuint,
  easeOutQuint,
  easeInOutQuint,
  easeInExpo,
  easeOutExpo,
  easeInOutExpo,
  easeInCirc,
  easeOutCirc,
  easeInOutCirc,
  easeInBack,
  easeOutBack,
  easeInOutBack,
  easeInElastic,
  easeOutElastic,
  easeInOutElastic,
  easeInBounce,
  easeOutBounce,
  easeInOutBounce,
}

enum MiracleAnimatableEvent {
  windowOpen,
  windowClose,
  windowMove,
  windowResize,
  workspaceChange,
  windowFocusChange,
}

class MiracleWorkspaceConfig {
  final int num;
  final int containerType;
  final String? name;

  MiracleWorkspaceConfig({
    required this.num,
    required this.containerType,
    this.name,
  });
}

class MiracleDragAndDropConfig {
  final bool enabled;
  final int modifiers;

  MiracleDragAndDropConfig({
    required this.enabled,
    required this.modifiers,
  });
}

// Main wrapper class
class MiracleConfig {
  static String get defaultConfigPath {
    final pathPtr = _ffi.miracle_config_path();
    return pathPtr.cast<Utf8>().toDartString();
  }

  static MiracleConfigData? loadFromPath(String path) {
    final pathPtr = path.toNativeUtf8();
    final resultPtr = _ffi.miracle_config_load(pathPtr.cast());
    malloc.free(pathPtr);

    if (resultPtr == nullptr) {
      return null;
    }

    final configPtr = _ffi.miracle_config_get_data(resultPtr);
    final data = MiracleConfigData(path, configPtr);

    // Don't free here - the config data is still needed
    // _ffi.miracle_config_free(resultPtr);

    return data;
  }

  static List<MiracleOption> getModifierOptions() {
    final count = _ffi.miracle_config_get_modifier_options_count();
    final options = <MiracleOption>[];

    for (var i = 0; i < count; i++) {
      final option = _ffi.miracle_config_get_modifier_option(i);
      options.add(
        MiracleOption(
          name: option.name.cast<Utf8>().toDartString(),
          value: option.value,
        ),
      );
    }

    return options;
  }

  static List<MiracleOption> getButtonsOptions() {
    final count = _ffi.miracle_config_get_mouse_button_options_count();
    final options = <MiracleOption>[];

    for (var i = 0; i < count; i++) {
      final option = _ffi.miracle_config_get_mouse_button_option(i);
      options.add(
        MiracleOption(
          name: option.name.cast<Utf8>().toDartString(),
          value: option.value,
        ),
      );
    }

    return options;
  }

  static List<MiracleOption> getMouseActionsOptions() {
    final count = _ffi.miracle_config_get_mouse_actions_options_count();
    final options = <MiracleOption>[];

    for (var i = 0; i < count; i++) {
      final option = _ffi.miracle_config_get_mouse_actions_option(i);
      options.add(
        MiracleOption(
          name: option.name.cast<Utf8>().toDartString(),
          value: option.value,
        ),
      );
    }

    return options;
  }

  static List<MiracleOption> getKeyboardActionsOptions() {
    final count = _ffi.miracle_config_get_keyboard_actions_options_count();
    final options = <MiracleOption>[];

    for (var i = 0; i < count; i++) {
      final option = _ffi.miracle_config_get_keyboard_actions_option(i);
      options.add(
        MiracleOption(
          name: option.name.cast<Utf8>().toDartString(),
          value: option.value,
        ),
      );
    }

    return options;
  }

  static List<MiracleOption> getBuiltInKeyCommandOptions() {
    final count = _ffi.miracle_config_get_built_in_key_command_options_count();
    final options = <MiracleOption>[];

    for (var i = 0; i < count; i++) {
      final option = _ffi.miracle_config_get_built_in_key_command_option(i);
      options.add(
        MiracleOption(
          name: option.name.cast<Utf8>().toDartString(),
          value: option.value,
        ),
      );
    }

    return options;
  }

  static List<MiracleOption> getAnimationTypeOptions() {
    final count =
        _ffi.miracle_config_get_built_in_animation_type_options_count();
    final options = <MiracleOption>[];

    for (var i = 0; i < count; i++) {
      final option = _ffi.miracle_config_get_built_in_animation_type_option(i);
      options.add(
        MiracleOption(
          name: option.name.cast<Utf8>().toDartString(),
          value: option.value,
        ),
      );
    }

    return options;
  }

  static List<MiracleOption> getEaseFunctionOptions() {
    final count = _ffi.miracle_config_get_ease_function_options_count();
    final options = <MiracleOption>[];

    for (var i = 0; i < count; i++) {
      final option = _ffi.miracle_config_get_ease_function_option(i);
      options.add(
        MiracleOption(
          name: option.name.cast<Utf8>().toDartString(),
          value: option.value,
        ),
      );
    }

    return options;
  }

  static List<MiracleOption> getContainerLayoutOptions() {
    final count = _ffi.miracle_config_get_layout_options_count();
    final options = <MiracleOption>[];

    for (var i = 0; i < count; i++) {
      final option = _ffi.miracle_config_get_layout_option(i);
      options.add(
        MiracleOption(
          name: option.name.cast<Utf8>().toDartString(),
          value: option.value,
        ),
      );
    }

    return options;
  }
}

// MiracleConfigData extends ChangeNotifier for reactive UI updates
class MiracleConfigData extends ChangeNotifier {
  final String path;
  final Pointer<miracle_config_data_t> _ptr;

  MiracleConfigData(this.path, this._ptr);

  // Save the config to a file
  MiracleConfigSaveResult saveToPath(String path) {
    final pathPtr = path.toNativeUtf8();
    final resultPtr = _ffi.miracle_config_save(pathPtr.cast(), _ptr);
    malloc.free(pathPtr);

    if (resultPtr == nullptr) {
      return MiracleConfigSaveResult(
        success: false,
        errors: [
          MiracleConfigError(
            line: 0,
            column: 0,
            level: MiracleConfigErrorLevel.error,
            filename: '',
            message: 'Result pointer is null. Failed to save config.',
          )
        ],
      );
    }

    final result = MiracleConfigSaveResult(
      success: resultPtr.ref.success,
      errors: [],
    );

    if (!resultPtr.ref.success) {
      final errorCount = _ffi.miracle_save_result_get_error_count(resultPtr);
      if (errorCount > 0) {
        for (var i = 0; i < errorCount; i++) {
          final errorPtr = _ffi.miracle_save_result_get_error(resultPtr, i);
          result.errors.add(
            MiracleConfigError(
              line: errorPtr.ref.line,
              column: errorPtr.ref.column,
              level: MiracleConfigErrorLevel.values[errorPtr.ref.levelAsInt],
              filename: errorPtr.ref.filename.cast<Utf8>().toDartString(),
              message: errorPtr.ref.message.cast<Utf8>().toDartString(),
            ),
          );
        }
      }
    }

    _ffi.miracle_save_result_free(resultPtr);
    return result;
  }

  // Accessors
  int get primaryModifier => _ffi.miracle_config_get_primary_modifier(_ptr);
  set primaryModifier(int modifier) {
    _ffi.miracle_config_set_primary_modifier(_ptr, modifier);
    notifyListeners();
  }

  int get primaryButton => _ffi.miracle_config_get_primary_button(_ptr);
  set primaryButton(int button) {
    _ffi.miracle_config_set_primary_button(_ptr, button);
    notifyListeners();
  }

  // Gaps
  int get innerGapsX => _ffi.miracle_config_get_inner_gaps_x(_ptr);
  set innerGapsX(int value) {
    _ffi.miracle_config_set_inner_gaps_x(_ptr, value);
    notifyListeners();
  }

  int get innerGapsY => _ffi.miracle_config_get_inner_gaps_y(_ptr);
  set innerGapsY(int value) {
    _ffi.miracle_config_set_inner_gaps_y(_ptr, value);
    notifyListeners();
  }

  int get outerGapsX => _ffi.miracle_config_get_outer_gaps_x(_ptr);
  set outerGapsX(int value) {
    _ffi.miracle_config_set_outer_gaps_x(_ptr, value);
    notifyListeners();
  }

  int get outerGapsY => _ffi.miracle_config_get_outer_gaps_y(_ptr);
  set outerGapsY(int value) {
    _ffi.miracle_config_set_outer_gaps_y(_ptr, value);
    notifyListeners();
  }

  int get resizeJump => _ffi.miracle_config_get_resize_jump(_ptr);
  set resizeJump(int value) {
    _ffi.miracle_config_set_resize_jump(_ptr, value);
    notifyListeners();
  }

  bool get animationsEnabled =>
      _ffi.miracle_config_get_animations_enabled(_ptr);
  set animationsEnabled(bool value) {
    _ffi.miracle_config_set_animations_enabled(_ptr, value);
    notifyListeners();
  }

  // Terminal
  String? get terminal {
    final ptr = _ffi.miracle_config_get_terminal(_ptr);
    return ptr == nullptr ? null : ptr.cast<Utf8>().toDartString();
  }

  set terminal(String? value) {
    if (value == null) {
      _ffi.miracle_config_set_terminal(_ptr, nullptr);
    } else {
      final ptr = value.toNativeUtf8();
      _ffi.miracle_config_set_terminal(_ptr, ptr.cast());
      malloc.free(ptr);
    }
    notifyListeners();
  }

  // Custom key commands
  List<MiracleCustomKeyCommand> getCustomKeyCommands() {
    final count = _ffi.miracle_config_get_custom_key_command_count(_ptr);
    final commands = <MiracleCustomKeyCommand>[];

    for (var i = 0; i < count; i++) {
      final cmd = _ffi.miracle_config_get_custom_key_command(_ptr, i);
      commands.add(
        MiracleCustomKeyCommand(
          action: cmd.action,
          modifiers: cmd.modifiers,
          key: cmd.key,
          command: cmd.command.cast<Utf8>().toDartString(),
        ),
      );
    }

    return commands;
  }

  void addCustomKeyCommand(int action, int modifiers, int key, String command) {
    final cmdPtr = calloc<miracle_custom_key_command_t>();
    cmdPtr.ref
      ..action = action
      ..modifiers = modifiers
      ..key = key
      ..command = command.toNativeUtf8().cast();

    _ffi.miracle_config_add_custom_key_command(_ptr, cmdPtr);

    malloc.free(cmdPtr.ref.command.cast<Utf8>());
    calloc.free(cmdPtr);
    notifyListeners();
  }

  void editCustomKeyCommand(
      int index, int action, int modifiers, int key, String command) {
    final cmdPtr = calloc<miracle_custom_key_command_t>();
    cmdPtr.ref
      ..action = action
      ..modifiers = modifiers
      ..key = key
      ..command = command.toNativeUtf8().cast();

    _ffi.miracle_config_edit_custom_key_command(_ptr, index, cmdPtr);

    malloc.free(cmdPtr.ref.command.cast<Utf8>());
    calloc.free(cmdPtr);
    notifyListeners();
  }

  void removeCustomKeyCommand(int index) {
    _ffi.miracle_config_remove_custom_key_command(_ptr, index);
    notifyListeners();
  }

  // Startup apps
  List<MiracleStartupApp> getStartupApps() {
    final count = _ffi.miracle_config_get_startup_app_count(_ptr);
    final apps = <MiracleStartupApp>[];

    for (var i = 0; i < count; i++) {
      final app = _ffi.miracle_config_get_startup_app(_ptr, i);
      apps.add(
        MiracleStartupApp(
          command: app.command.cast<Utf8>().toDartString(),
          restartOnDeath: app.restart_on_death,
          noStartupId: app.no_startup_id,
          shouldHaltCompositorOnDeath: app.should_halt_compositor_on_death,
          inSystemdScope: app.in_systemd_scope,
        ),
      );
    }

    return apps;
  }

  void addStartupApp(
    String command, {
    bool restartOnDeath = false,
    bool noStartupId = false,
    bool shouldHaltCompositorOnDeath = false,
    bool inSystemdScope = false,
  }) {
    final appPtr = calloc<miracle_startup_app_t>();
    appPtr.ref
      ..command = command.toNativeUtf8().cast()
      ..restart_on_death = restartOnDeath
      ..no_startup_id = noStartupId
      ..should_halt_compositor_on_death = shouldHaltCompositorOnDeath
      ..in_systemd_scope = inSystemdScope;

    _ffi.miracle_config_add_startup_app(_ptr, appPtr);

    malloc.free(appPtr.ref.command.cast<Utf8>());
    calloc.free(appPtr);
    notifyListeners();
  }

  void updateStartupApp(
    int index,
    String command, {
    bool restartOnDeath = false,
    bool noStartupId = false,
    bool shouldHaltCompositorOnDeath = false,
    bool inSystemdScope = false,
  }) {
    final appPtr = calloc<miracle_startup_app_t>();
    appPtr.ref
      ..command = command.toNativeUtf8().cast()
      ..restart_on_death = restartOnDeath
      ..no_startup_id = noStartupId
      ..should_halt_compositor_on_death = shouldHaltCompositorOnDeath
      ..in_systemd_scope = inSystemdScope;

    _ffi.miracle_config_set_startup_app(_ptr, index, appPtr);

    malloc.free(appPtr.ref.command.cast<Utf8>());
    calloc.free(appPtr);
    notifyListeners();
  }

  bool removeStartupApp(int index) {
    final result = _ffi.miracle_config_remove_startup_app(_ptr, index);
    notifyListeners();
    return result;
  }

  // Environment variables
  List<MiracleEnvVar> getEnvironmentVariables() {
    final count = _ffi.miracle_config_get_environment_variable_count(_ptr);
    final vars = <MiracleEnvVar>[];

    for (var i = 0; i < count; i++) {
      final var_ = _ffi.miracle_config_get_environment_variable(_ptr, i);
      vars.add(
        MiracleEnvVar(
          key: var_.key.cast<Utf8>().toDartString(),
          value: var_.value.cast<Utf8>().toDartString(),
        ),
      );
    }

    return vars;
  }

  void addEnvironmentVariable(String key, String value) {
    final varPtr = calloc<miracle_environment_variable_t>();
    varPtr.ref
      ..key = key.toNativeUtf8().cast()
      ..value = value.toNativeUtf8().cast();

    _ffi.miracle_config_add_environment_variable(_ptr, varPtr);

    malloc.free(varPtr.ref.key.cast<Utf8>());
    malloc.free(varPtr.ref.value.cast<Utf8>());
    calloc.free(varPtr);
    notifyListeners();
  }

  void setEnvironmentVariable(int index, String key, String value) {
    final varPtr = calloc<miracle_environment_variable_t>();
    varPtr.ref
      ..key = key.toNativeUtf8().cast()
      ..value = value.toNativeUtf8().cast();

    _ffi.miracle_config_set_environment_variable(_ptr, index, varPtr);

    malloc.free(varPtr.ref.key.cast<Utf8>());
    malloc.free(varPtr.ref.value.cast<Utf8>());
    calloc.free(varPtr);
    notifyListeners();
  }

  bool removeEnvironmentVariable(int index) {
    final result = _ffi.miracle_config_remove_environment_variable(_ptr, index);
    notifyListeners();
    return result;
  }

  // Built-in key commands
  List<MiracleBuiltInKeyCommand> getBuiltInKeyCommands() {
    final count =
        _ffi.miracle_config_get_built_in_key_command_override_count(_ptr);
    final commands = <MiracleBuiltInKeyCommand>[];

    for (var i = 0; i < count; i++) {
      final cmd =
          _ffi.miracle_config_get_built_in_key_command_override(_ptr, i);
      commands.add(
        MiracleBuiltInKeyCommand(
          action: cmd.action,
          modifiers: cmd.modifiers,
          key: cmd.key,
          builtInAction: cmd.command,
        ),
      );
    }

    return commands;
  }

  void addBuiltInKeyCommand(int action, int modifiers, int key, int command) {
    final cmdPtr = calloc<miracle_built_in_key_command_override_t>();
    cmdPtr.ref
      ..action = action
      ..modifiers = modifiers
      ..key = key
      ..command = command;

    _ffi.miracle_config_add_built_in_key_command_override(_ptr, cmdPtr);
    calloc.free(cmdPtr);
    notifyListeners();
  }

  void updateBuiltInKeyCommand(
      int index, int action, int modifiers, int key, int command) {
    final cmdPtr = calloc<miracle_built_in_key_command_override_t>();
    cmdPtr.ref
      ..action = action
      ..modifiers = modifiers
      ..key = key
      ..command = command;

    _ffi.miracle_config_set_built_in_key_command_override(_ptr, index, cmdPtr);
    calloc.free(cmdPtr);
    notifyListeners();
  }

  bool removeBuiltInKeyCommand(int index) {
    final result =
        _ffi.miracle_config_remove_built_in_key_command_override(_ptr, index);
    notifyListeners();
    return result;
  }

  int _doubleColorToInt(double color) {
    return (color * 255.0).toInt();
  }

  Color ffiColorArrayToColor(Array<Float> colorArray) {
    return Color.fromARGB(
        _doubleColorToInt(colorArray[0]),
        _doubleColorToInt(colorArray[3]),
        _doubleColorToInt(colorArray[2]),
        _doubleColorToInt(colorArray[1]));
  }

  // Border config
  MiracleBorderConfig getBorderConfig() {
    final config = _ffi.miracle_config_get_border_config(_ptr);
    return MiracleBorderConfig(
      size: config.size,
      radius: config.radius,
      focusColor: ffiColorArrayToColor(config.focus_color),
      color: ffiColorArrayToColor(config.color),
    );
  }

  void setBorderConfig(MiracleBorderConfig config) {
    final borderPtr = calloc<miracle_border_config_t>();
    borderPtr.ref
      ..size = config.size
      ..radius = config.radius;

    // Set focus color
    borderPtr.ref.focus_color[0] = config.focusColor.alpha / 255.0;
    borderPtr.ref.focus_color[1] = config.focusColor.blue / 255.0;
    borderPtr.ref.focus_color[2] = config.focusColor.green / 255.0;
    borderPtr.ref.focus_color[3] = config.focusColor.red / 255.0;

    // Set normal color
    borderPtr.ref.color[0] = config.color.alpha / 255.0;
    borderPtr.ref.color[1] = config.color.blue / 255.0;
    borderPtr.ref.color[2] = config.color.green / 255.0;
    borderPtr.ref.color[3] = config.color.red / 255.0;

    _ffi.miracle_config_set_border_config(_ptr, borderPtr);
    calloc.free(borderPtr);
    notifyListeners();
  }

  // Animation - NEW API STRUCTURE
  int get animationDefinitionCount =>
      _ffi.miracle_config_get_animateable_event_count();

  MiracleAnimationDefinition getAnimationDefinition(
      MiracleAnimatableEvent event) {
    final eventDef =
        _ffi.miracle_config_get_animateable_event(_ptr, event.index);

    // Get the first animation part (for backward compatibility)
    if (eventDef.num_parts > 0) {
      final eventPtr = calloc<miracle_animateable_event_t>();
      eventPtr.ref = eventDef;
      final anim =
          _ffi.miracle_animateable_event_get_animation_part(eventPtr, 0);
      calloc.free(eventPtr);

      return MiracleAnimationDefinition(
        type: MiracleAnimationType.values[
            anim.type < MiracleAnimationType.values.length ? anim.type : 0],
        function: MiracleEaseFunction.values[
            anim.function < MiracleEaseFunction.values.length
                ? anim.function
                : 0],
        durationSeconds: eventDef.duration_seconds,
        c1: anim.c1,
        c2: anim.c2,
        c3: anim.c3,
        c4: anim.c4,
        c5: anim.c5,
        n1: anim.n1,
        d1: anim.d1,
      );
    }

    // Return a default if no parts
    return MiracleAnimationDefinition(
      type: MiracleAnimationType.none,
      function: MiracleEaseFunction.linear,
      durationSeconds: 0.0,
    );
  }

  void setAnimationDefinition(
    MiracleAnimatableEvent event,
    MiracleAnimationDefinition def,
  ) {
    // Get the current event
    final eventDef =
        _ffi.miracle_config_get_animateable_event(_ptr, event.index);
    final eventPtr = calloc<miracle_animateable_event_t>();
    eventPtr.ref = eventDef;

    // Create animation
    final animPtr = calloc<miracle_built_in_animation_t>();
    animPtr.ref
      ..type = def.type.index
      ..function = def.function.index
      ..c1 = def.c1
      ..c2 = def.c2
      ..c3 = def.c3
      ..c4 = def.c4
      ..c5 = def.c5
      ..n1 = def.n1
      ..d1 = def.d1;

    // Update or add animation part
    if (eventDef.num_parts > 0) {
      _ffi.miracle_animateable_event_set_animation(eventPtr, 0, animPtr.ref);
    } else {
      _ffi.miracle_animateable_event_add_animation(eventPtr, animPtr.ref);
    }

    // Update event with new duration
    eventPtr.ref.duration_seconds = def.durationSeconds;
    _ffi.miracle_config_set_animateable_event(_ptr, event.index, eventPtr);

    calloc.free(animPtr);
    notifyListeners();
  }

  void resetAnimationDefinition(MiracleAnimatableEvent event) {
    _ffi.miracle_config_reset_animation_definition(_ptr, event.index);
    notifyListeners();
  }

  // Workspace config
  List<MiracleWorkspaceConfig> getWorkspaceConfigs() {
    final count = _ffi.miracle_config_get_workspace_config_count(_ptr);
    final configs = <MiracleWorkspaceConfig>[];

    for (var i = 0; i < count; i++) {
      final config = _ffi.miracle_config_get_workspace_config(_ptr, i);
      configs.add(
        MiracleWorkspaceConfig(
          num: config.has_num ? config.num : 0,
          containerType:
              config.has_layout_strategy ? config.layout_strategy : 0,
          name: config.has_name && config.name != nullptr
              ? config.name.cast<Utf8>().toDartString()
              : null,
        ),
      );
    }

    return configs;
  }

  void addWorkspaceConfig(int num, int containerType, {String? name}) {
    final configPtr = calloc<miracle_workspace_config_t>();
    configPtr.ref
      ..has_num = true
      ..num = num
      ..has_layout_strategy = true
      ..layout_strategy = containerType
      ..has_name = name != null;

    if (name != null) {
      configPtr.ref.name = name.toNativeUtf8().cast();
    }

    _ffi.miracle_config_add_workspace_config(_ptr, configPtr);

    if (name != null) {
      malloc.free(configPtr.ref.name.cast<Utf8>());
    }
    calloc.free(configPtr);
    notifyListeners();
  }

  void setWorkspaceConfig(int index, int num, int containerType,
      {String? name}) {
    final configPtr = calloc<miracle_workspace_config_t>();
    configPtr.ref
      ..has_num = true
      ..num = num
      ..has_layout_strategy = true
      ..layout_strategy = containerType
      ..has_name = name != null;

    if (name != null) {
      configPtr.ref.name = name.toNativeUtf8().cast();
    }

    _ffi.miracle_config_set_workspace_config(_ptr, index, configPtr);

    if (name != null) {
      malloc.free(configPtr.ref.name.cast<Utf8>());
    }
    calloc.free(configPtr);
    notifyListeners();
  }

  bool removeWorkspaceConfig(int index) {
    final result = _ffi.miracle_config_remove_workspace_config(_ptr, index);
    notifyListeners();
    return result;
  }

  // Move modifier
  int get moveModifier => _ffi.miracle_config_get_move_modifier(_ptr);
  set moveModifier(int modifier) {
    _ffi.miracle_config_set_move_modifier(_ptr, modifier);
    notifyListeners();
  }

  // Drag and drop
  MiracleDragAndDropConfig get dragAndDrop {
    final config = _ffi.miracle_config_get_drag_and_drop(_ptr);
    return MiracleDragAndDropConfig(
      enabled: config.enabled,
      modifiers: config.modifiers,
    );
  }

  set dragAndDrop(MiracleDragAndDropConfig config) {
    final ddPtr = calloc<miracle_drag_and_drop_config_t>();
    ddPtr.ref
      ..enabled = config.enabled
      ..modifiers = config.modifiers;

    _ffi.miracle_config_set_drag_and_drop(_ptr, ddPtr);
    calloc.free(ddPtr);
    notifyListeners();
  }
}
