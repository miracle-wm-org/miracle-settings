import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

// FFI bindings
final _lib = DynamicLibrary.open(
  '/home/matthew/miracle-wm/build/lib/libmiracle-wm-config.so',
);

// Initialize FFI bindings
final _miracleConfigLoad = _lib.lookupFunction<
    Pointer<_MiracleConfigLoadResult> Function(Pointer<Utf8>),
    Pointer<_MiracleConfigLoadResult> Function(
        Pointer<Utf8>)>('miracle_config_load');

final _miracleConfigLoadResultGetData = _lib.lookupFunction<
    Pointer<_MiracleConfigData> Function(Pointer<_MiracleConfigLoadResult>),
    Pointer<_MiracleConfigData> Function(
        Pointer<_MiracleConfigLoadResult>)>('miracle_config_get_data');

final _miracleConfigFree = _lib.lookupFunction<
    Void Function(Pointer<_MiracleConfigLoadResult>),
    void Function(Pointer<_MiracleConfigLoadResult>)>('miracle_config_free');

final _miracleConfigGetModifierOptionsCount =
    _lib.lookupFunction<Uint32 Function(), int Function()>(
  'miracle_config_get_modifier_options_count',
);

final _miracleConfigGetModifierOption = _lib.lookupFunction<
    _MiracleOption Function(Uint32),
    _MiracleOption Function(int)>("miracle_config_get_modifier_option");

final _miracleConfigGetButtonsOptionsCount =
    _lib.lookupFunction<Uint32 Function(), int Function()>(
  'miracle_config_get_mouse_button_options_count',
);

final _miracleConfigGetButtonOption = _lib.lookupFunction<
    _MiracleOption Function(Uint32),
    _MiracleOption Function(int)>("miracle_config_get_mouse_button_option");

final _miracleConfigGetMouseActionsOptionsCount =
    _lib.lookupFunction<Uint32 Function(), int Function()>(
  'miracle_config_get_mouse_actions_options_count',
);

final _miracleConfigGetMouseActionsOption = _lib.lookupFunction<
    _MiracleOption Function(Uint32),
    _MiracleOption Function(int)>("miracle_config_get_mouse_actions_option");

final _miracleConfigGetKeyboardActionsOptionsCount =
    _lib.lookupFunction<Uint32 Function(), int Function()>(
  'miracle_config_get_keyboard_actions_options_count',
);

final _miracleConfigGetBuiltInKeyCommandsOption = _lib.lookupFunction<
    _MiracleOption Function(Uint32),
    _MiracleOption Function(
        int)>("miracle_config_get_built_in_key_command_option");

final _miracleConfigGetBuiltInKeyCommandsOptionsCount =
    _lib.lookupFunction<Uint32 Function(), int Function()>(
  'miracle_config_get_built_in_key_command_options_count',
);

final _miracleConfigGetKeyboardActionsOption = _lib.lookupFunction<
    _MiracleOption Function(Uint32),
    _MiracleOption Function(int)>("miracle_config_get_keyboard_actions_option");

final _miracleConfigGetPrimaryModifier = _lib.lookupFunction<
    Uint32 Function(Pointer<_MiracleConfigData>),
    int Function(
        Pointer<_MiracleConfigData>)>('miracle_config_get_primary_modifier');

final _miracleConfigSetPrimaryModifier = _lib.lookupFunction<
    Void Function(Pointer<_MiracleConfigData>, Uint32),
    void Function(Pointer<_MiracleConfigData>,
        int)>('miracle_config_set_primary_modifier');

final _miracleConfigGetPrimaryButton = _lib.lookupFunction<
    Uint32 Function(Pointer<_MiracleConfigData>),
    int Function(
        Pointer<_MiracleConfigData>)>('miracle_config_get_primary_button');

final _miracleConfigSetPrimaryButton = _lib.lookupFunction<
    Void Function(Pointer<_MiracleConfigData>, Uint32),
    void Function(
        Pointer<_MiracleConfigData>, int)>('miracle_config_set_primary_button');

// Gaps accessors
final _miracleConfigGetInnerGapsX = _lib.lookupFunction<
    Int32 Function(Pointer<_MiracleConfigData>),
    int Function(
        Pointer<_MiracleConfigData>)>('miracle_config_get_inner_gaps_x');

final _miracleConfigSetInnerGapsX = _lib.lookupFunction<
    Void Function(Pointer<_MiracleConfigData>, Int32),
    void Function(
        Pointer<_MiracleConfigData>, int)>('miracle_config_set_inner_gaps_x');

final _miracleConfigGetInnerGapsY = _lib.lookupFunction<
    Int32 Function(Pointer<_MiracleConfigData>),
    int Function(
        Pointer<_MiracleConfigData>)>('miracle_config_get_inner_gaps_y');

final _miracleConfigSetInnerGapsY = _lib.lookupFunction<
    Void Function(Pointer<_MiracleConfigData>, Int32),
    void Function(
        Pointer<_MiracleConfigData>, int)>('miracle_config_set_inner_gaps_y');

final _miracleConfigGetOuterGapsX = _lib.lookupFunction<
    Int32 Function(Pointer<_MiracleConfigData>),
    int Function(
        Pointer<_MiracleConfigData>)>('miracle_config_get_outer_gaps_x');

final _miracleConfigSetOuterGapsX = _lib.lookupFunction<
    Void Function(Pointer<_MiracleConfigData>, Int32),
    void Function(
        Pointer<_MiracleConfigData>, int)>('miracle_config_set_outer_gaps_x');

final _miracleConfigGetOuterGapsY = _lib.lookupFunction<
    Int32 Function(Pointer<_MiracleConfigData>),
    int Function(
        Pointer<_MiracleConfigData>)>('miracle_config_get_outer_gaps_y');

final _miracleConfigSetOuterGapsY = _lib.lookupFunction<
    Void Function(Pointer<_MiracleConfigData>, Int32),
    void Function(
        Pointer<_MiracleConfigData>, int)>('miracle_config_set_outer_gaps_y');

// Resize jump
final _miracleConfigGetResizeJump = _lib.lookupFunction<
    Int32 Function(Pointer<_MiracleConfigData>),
    int Function(
        Pointer<_MiracleConfigData>)>('miracle_config_get_resize_jump');

final _miracleConfigSetResizeJump = _lib.lookupFunction<
    Void Function(Pointer<_MiracleConfigData>, Int32),
    void Function(
        Pointer<_MiracleConfigData>, int)>('miracle_config_set_outer_gaps_y');

// Animations enabled
final _miracleConfigGetAnimationsEnabled = _lib.lookupFunction<
    Bool Function(Pointer<_MiracleConfigData>),
    bool Function(
        Pointer<_MiracleConfigData>)>('miracle_config_get_animations_enabled');

final _miracleConfigSetAnimationsEnabled = _lib.lookupFunction<
    Void Function(Pointer<_MiracleConfigData>, Bool),
    void Function(Pointer<_MiracleConfigData>,
        bool)>('miracle_config_set_animations_enabled');

// Terminal
final _miracleConfigGetTerminal = _lib.lookupFunction<
    Pointer<Utf8> Function(Pointer<_MiracleConfigData>),
    Pointer<Utf8> Function(
        Pointer<_MiracleConfigData>)>('miracle_config_get_terminal');

final _miracleConfigSetTerminal = _lib.lookupFunction<
    Void Function(Pointer<_MiracleConfigData>, Pointer<Utf8>),
    void Function(Pointer<_MiracleConfigData>,
        Pointer<Utf8>)>('miracle_config_set_terminal');

// Custom key commands
final _miracleConfigGetCustomKeyCommandCount = _lib.lookupFunction<
        UintPtr Function(Pointer<_MiracleConfigData>),
        int Function(Pointer<_MiracleConfigData>)>(
    'miracle_config_get_custom_key_command_count');

final _miracleConfigGetCustomKeyCommand = _lib.lookupFunction<
    _MiracleCustomKeyCommand Function(Pointer<_MiracleConfigData>, UintPtr),
    _MiracleCustomKeyCommand Function(Pointer<_MiracleConfigData>,
        int)>('miracle_config_get_custom_key_command');

final _miracleConfigAddCustomKeyCommand = _lib.lookupFunction<
    Void Function(
      Pointer<_MiracleConfigData>,
      Int32,
      Uint32,
      Int32,
      Pointer<Utf8>,
    ),
    void Function(Pointer<_MiracleConfigData>, int, int, int,
        Pointer<Utf8>)>('miracle_config_add_custom_key_command');

final _miracleConfigEditCustomKeyCommand = _lib.lookupFunction<
    Void Function(
      Pointer<_MiracleConfigData>,
      Int32,
      Uint32,
      Uint32,
      Int32,
      Pointer<Utf8>,
    ),
    void Function(Pointer<_MiracleConfigData>, int, int, int, int,
        Pointer<Utf8>)>('miracle_config_edit_custom_key_command');

final _miracleConfigClearCustomKeyCommands = _lib.lookupFunction<
        Void Function(Pointer<_MiracleConfigData>),
        void Function(Pointer<_MiracleConfigData>)>(
    'miracle_config_clear_custom_key_commands');

final _miracleConfigRemoveCustomKeyCommand = _lib.lookupFunction<
    Void Function(Pointer<_MiracleConfigData>, Uint32),
    void Function(Pointer<_MiracleConfigData>,
        int)>('miracle_config_remove_custom_key_command');

// Startup apps
final _miracleConfigGetStartupAppCount = _lib.lookupFunction<
    UintPtr Function(Pointer<_MiracleConfigData>),
    int Function(
        Pointer<_MiracleConfigData>)>('miracle_config_get_startup_app_count');

final _miracleConfigGetStartupApp = _lib.lookupFunction<
    _MiracleStartupApp Function(Pointer<_MiracleConfigData>, UintPtr),
    _MiracleStartupApp Function(
        Pointer<_MiracleConfigData>, int)>('miracle_config_get_startup_app');

final _miracleConfigAddStartupApp = _lib.lookupFunction<
    Void Function(
      Pointer<_MiracleConfigData>,
      Pointer<Utf8>,
      Bool,
      Bool,
      Bool,
      Bool,
    ),
    void Function(
      Pointer<_MiracleConfigData>,
      Pointer<Utf8>,
      bool,
      bool,
      bool,
      bool,
    )>('miracle_config_add_startup_app');

final _miracleConfigSetStartupApp = _lib.lookupFunction<
    Void Function(
      Pointer<_MiracleConfigData>,
      Int32,
      Pointer<Utf8>,
      Bool,
      Bool,
      Bool,
      Bool,
    ),
    void Function(
      Pointer<_MiracleConfigData>,
      int,
      Pointer<Utf8>,
      bool,
      bool,
      bool,
      bool,
    )>('miracle_config_set_startup_app');

final _miracleConfigRemoveStartupApp = _lib.lookupFunction<
    Bool Function(Pointer<_MiracleConfigData>, UintPtr),
    bool Function(
        Pointer<_MiracleConfigData>, int)>('miracle_config_remove_startup_app');

// Environment variables
final _miracleConfigGetEnvVarCount = _lib.lookupFunction<
        UintPtr Function(Pointer<_MiracleConfigData>),
        int Function(Pointer<_MiracleConfigData>)>(
    'miracle_config_get_environment_variable_count');

final _miracleConfigGetEnvVar = _lib.lookupFunction<
    _MiracleEnvVar Function(Pointer<_MiracleConfigData>, UintPtr),
    _MiracleEnvVar Function(Pointer<_MiracleConfigData>,
        int)>('miracle_config_get_environment_variable');

final _miracleConfigAddEnvVar = _lib.lookupFunction<
    Void Function(Pointer<_MiracleConfigData>, Pointer<Utf8>, Pointer<Utf8>),
    void Function(Pointer<_MiracleConfigData>, Pointer<Utf8>,
        Pointer<Utf8>)>('miracle_config_add_environment_variable');

final _miracleConfigClearEnvVars = _lib.lookupFunction<
        Void Function(Pointer<_MiracleConfigData>),
        void Function(Pointer<_MiracleConfigData>)>(
    'miracle_config_clear_environment_variables');

final _miracleConfigRemoveEnvVar = _lib.lookupFunction<
    Bool Function(Pointer<_MiracleConfigData>, UintPtr),
    bool Function(Pointer<_MiracleConfigData>,
        int)>('miracle_config_remove_environment_variable');

final _miracleConfigGetBuiltInKeyCommandOverrideCount = _lib.lookupFunction<
        UintPtr Function(Pointer<_MiracleConfigData>),
        int Function(Pointer<_MiracleConfigData>)>(
    'miracle_config_get_built_in_key_command_override_count');

final _miracleConfigGetBuiltInKeyCommandOverride = _lib.lookupFunction<
    _MiracleBuiltInKeyCommand Function(Pointer<_MiracleConfigData>, UintPtr),
    _MiracleBuiltInKeyCommand Function(Pointer<_MiracleConfigData>,
        int)>('miracle_config_get_built_in_key_command_override');

final _miracleConfigAddBuiltInKeyCommandOverride = _lib.lookupFunction<
    Void Function(Pointer<_MiracleConfigData>, Uint32, Uint32, Int32, Uint32),
    void Function(Pointer<_MiracleConfigData>, int, int, int,
        int)>('miracle_config_add_built_in_key_command_override');

final _miracleConfigSetBuiltInKeyCommandOverride = _lib.lookupFunction<
    Void Function(
        Pointer<_MiracleConfigData>, Int32, Uint32, Uint32, Int32, Uint32),
    void Function(Pointer<_MiracleConfigData>, int, int, int, int,
        int)>('miracle_config_set_built_in_key_command_override');

final _miracleConfigRemoveBuiltInKeyCommandOverride = _lib.lookupFunction<
    Bool Function(Pointer<_MiracleConfigData>, UintPtr),
    bool Function(Pointer<_MiracleConfigData>,
        int)>('miracle_config_remove_built_in_key_command_override');

// Border config
final _miracleConfigGetBorderConfig = _lib.lookupFunction<
    _MiracleBorderConfig Function(Pointer<_MiracleConfigData>),
    _MiracleBorderConfig Function(
        Pointer<_MiracleConfigData>)>('miracle_config_get_border_config');

final _miracleConfigSetBorderConfig = _lib.lookupFunction<
    Void Function(
      Pointer<_MiracleConfigData>,
      Int32,
      Pointer<Float>,
      Pointer<Float>,
    ),
    void Function(
      Pointer<_MiracleConfigData>,
      int,
      Pointer<Float>,
      Pointer<Float>,
    )>('miracle_config_set_border_config');

// Animation definitions
final _miracleConfigGetAnimationDefCount =
    _lib.lookupFunction<UintPtr Function(), int Function()>(
  'miracle_config_get_animation_definition_count',
);

final _miracleConfigGetAnimationDef = _lib.lookupFunction<
    _MiracleAnimationDef Function(Pointer<_MiracleConfigData>, Int32),
    _MiracleAnimationDef Function(Pointer<_MiracleConfigData>,
        int)>('miracle_config_get_animation_definition');

final _miracleConfigSetAnimationDef = _lib.lookupFunction<
        Void Function(
          Pointer<_MiracleConfigData>,
          Int32,
          Pointer<_MiracleAnimationDef>,
        ),
        void Function(
            Pointer<_MiracleConfigData>, int, Pointer<_MiracleAnimationDef>)>(
    'miracle_config_set_animation_definition');

// Workspace config
final _miracleConfigGetWorkspaceConfigCount = _lib.lookupFunction<
        UintPtr Function(Pointer<_MiracleConfigData>),
        int Function(Pointer<_MiracleConfigData>)>(
    'miracle_config_get_workspace_config_count');

final _miracleConfigGetWorkspaceConfig = _lib.lookupFunction<
    _MiracleWorkspaceConfig Function(Pointer<_MiracleConfigData>, UintPtr),
    _MiracleWorkspaceConfig Function(Pointer<_MiracleConfigData>,
        int)>('miracle_config_get_workspace_config');

final _miracleConfigAddWorkspaceConfig = _lib.lookupFunction<
    Void Function(Pointer<_MiracleConfigData>, Int32, Int32, Pointer<Utf8>),
    void Function(Pointer<_MiracleConfigData>, int, int,
        Pointer<Utf8>)>('miracle_config_add_workspace_config');

final _miracleConfigClearWorkspaceConfigs = _lib.lookupFunction<
    Void Function(Pointer<_MiracleConfigData>),
    void Function(
        Pointer<_MiracleConfigData>)>('miracle_config_clear_workspace_configs');

final _miracleConfigRemoveWorkspaceConfig = _lib.lookupFunction<
    Bool Function(Pointer<_MiracleConfigData>, UintPtr),
    bool Function(Pointer<_MiracleConfigData>,
        int)>('miracle_config_remove_workspace_config');

// Move modifier
final _miracleConfigGetMoveModifier = _lib.lookupFunction<
    Uint32 Function(Pointer<_MiracleConfigData>),
    int Function(
        Pointer<_MiracleConfigData>)>('miracle_config_get_move_modifier');

final _miracleConfigSetMoveModifier = _lib.lookupFunction<
    Void Function(Pointer<_MiracleConfigData>, Uint32),
    void Function(
        Pointer<_MiracleConfigData>, int)>('miracle_config_set_move_modifier');

// Drag and drop
final _miracleConfigGetDragAndDrop = _lib.lookupFunction<
    _MiracleDragAndDrop Function(Pointer<_MiracleConfigData>),
    _MiracleDragAndDrop Function(
        Pointer<_MiracleConfigData>)>('miracle_config_get_drag_and_drop');

final _miracleConfigSetDragAndDrop = _lib.lookupFunction<
    Void Function(Pointer<_MiracleConfigData>, Bool, Uint32),
    void Function(Pointer<_MiracleConfigData>, bool,
        int)>('miracle_config_set_drag_and_drop');

// Error handling
final _miracleConfigGetErrorCount = _lib.lookupFunction<
    UintPtr Function(Pointer<_MiracleConfigLoadResult>),
    int Function(
        Pointer<_MiracleConfigLoadResult>)>('miracle_config_get_error_count');

final _miracleConfigGetError = _lib.lookupFunction<
    Pointer<_MiracleConfigError> Function(
      Pointer<_MiracleConfigLoadResult>,
      UintPtr,
    ),
    Pointer<_MiracleConfigError> Function(
        Pointer<_MiracleConfigLoadResult>, int)>('miracle_config_get_error');

// Error types
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

enum MiracleConfigErrorLevel { warning, error }

// Main wrapper class
class MiracleConfig {
  static MiracleConfigData? loadFromPath(String path) {
    final pathPtr = path.toNativeUtf8();
    final resultPtr = _miracleConfigLoad(pathPtr);
    malloc.free(pathPtr);

    if (resultPtr == nullptr) {
      return null;
    }

    return MiracleConfigData(_miracleConfigLoadResultGetData(resultPtr));
  }

  static void free(Pointer<_MiracleConfigLoadResult> result) {
    _miracleConfigFree(result);
  }

  static List<MiracleConfigError> getErrors(
    Pointer<_MiracleConfigLoadResult> result,
  ) {
    final count = _miracleConfigGetErrorCount(result);
    final errors = <MiracleConfigError>[];

    for (var i = 0; i < count; i++) {
      final errorPtr = _miracleConfigGetError(result, i);
      final error = errorPtr.ref;

      errors.add(
        MiracleConfigError(
          line: error.line,
          column: error.column,
          level: MiracleConfigErrorLevel.values[error.level],
          filename: error.filename.toDartString(),
          message: error.message.toDartString(),
        ),
      );
    }

    return errors;
  }

  static List<MiracleOption> getModifierOptions() {
    final count = _miracleConfigGetModifierOptionsCount();
    final options = <MiracleOption>[];

    for (var i = 0; i < count; i++) {
      final option = _miracleConfigGetModifierOption(i);
      options.add(
        MiracleOption(name: option.name.toDartString(), value: option.value),
      );
    }

    return options;
  }

  static List<MiracleOption> getButtonsOptions() {
    final count = _miracleConfigGetButtonsOptionsCount();
    final options = <MiracleOption>[];

    for (var i = 0; i < count; i++) {
      final option = _miracleConfigGetButtonOption(i);
      options.add(
        MiracleOption(name: option.name.toDartString(), value: option.value),
      );
    }

    return options;
  }

  static List<MiracleOption> getMouseActionsOptions() {
    final count = _miracleConfigGetMouseActionsOptionsCount();
    final options = <MiracleOption>[];

    for (var i = 0; i < count; i++) {
      final option = _miracleConfigGetMouseActionsOption(i);
      options.add(
        MiracleOption(name: option.name.toDartString(), value: option.value),
      );
    }

    return options;
  }

  static List<MiracleOption> getKeyboardActionsOptions() {
    final count = _miracleConfigGetKeyboardActionsOptionsCount();
    final options = <MiracleOption>[];

    for (var i = 0; i < count; i++) {
      final option = _miracleConfigGetKeyboardActionsOption(i);
      options.add(
        MiracleOption(name: option.name.toDartString(), value: option.value),
      );
    }

    return options;
  }

  static List<MiracleOption> getBuiltInKeyCommandsOptions() {
    final count = _miracleConfigGetBuiltInKeyCommandsOptionsCount();
    final options = <MiracleOption>[];

    for (var i = 0; i < count; i++) {
      final option = _miracleConfigGetBuiltInKeyCommandsOption(i);
      options.add(
        MiracleOption(name: option.name.toDartString(), value: option.value),
      );
    }

    return options;
  }
}

// Extended ConfigData wrapper with all methods
class MiracleConfigData {
  final Pointer<_MiracleConfigData> _ptr;

  MiracleConfigData(this._ptr);

  // Accessors
  int get primaryModifier => _miracleConfigGetPrimaryModifier(_ptr);
  set primaryModifier(int modifier) =>
      _miracleConfigSetPrimaryModifier(_ptr, modifier);

  int get primaryButton => _miracleConfigGetPrimaryButton(_ptr);
  set primaryButton(int button) => _miracleConfigSetPrimaryButton(_ptr, button);

  // Gaps
  int get innerGapsX => _miracleConfigGetInnerGapsX(_ptr);
  set innerGapsX(int value) => _miracleConfigSetInnerGapsX(_ptr, value);

  int get innerGapsY => _miracleConfigGetInnerGapsY(_ptr);
  set innerGapsY(int value) => _miracleConfigSetInnerGapsY(_ptr, value);

  int get outerGapsX => _miracleConfigGetOuterGapsX(_ptr);
  set outerGapsX(int value) => _miracleConfigSetOuterGapsX(_ptr, value);

  int get outerGapsY => _miracleConfigGetOuterGapsY(_ptr);
  set outerGapsY(int value) => _miracleConfigSetOuterGapsY(_ptr, value);

  int get resizeJump => _miracleConfigGetResizeJump(_ptr);
  set resizeJump(int value) => _miracleConfigSetResizeJump(_ptr, value);

  bool get animationsEnabled => _miracleConfigGetAnimationsEnabled(_ptr);
  set animationsEnabled(bool value) =>
      _miracleConfigSetAnimationsEnabled(_ptr, value);

  // Terminal
  String? get terminal {
    final ptr = _miracleConfigGetTerminal(_ptr);
    return ptr == nullptr ? null : ptr.toDartString();
  }

  set terminal(String? value) {
    if (value == null) {
      _miracleConfigSetTerminal(_ptr, nullptr);
    } else {
      final ptr = value.toNativeUtf8();
      _miracleConfigSetTerminal(_ptr, ptr);
      malloc.free(ptr);
    }
  }

  // Custom key commands
  List<MiracleCustomKeyCommand> getCustomKeyCommands() {
    final count = _miracleConfigGetCustomKeyCommandCount(_ptr);
    final commands = <MiracleCustomKeyCommand>[];

    for (var i = 0; i < count; i++) {
      final cmd = _miracleConfigGetCustomKeyCommand(_ptr, i);
      commands.add(
        MiracleCustomKeyCommand(
          action: cmd.action,
          modifiers: cmd.modifiers,
          key: cmd.key,
          command: cmd.command.toDartString(),
        ),
      );
    }

    return commands;
  }

  void addCustomKeyCommand(int action, int modifiers, int key, String command) {
    final cmdPtr = command.toNativeUtf8();
    _miracleConfigAddCustomKeyCommand(_ptr, action, modifiers, key, cmdPtr);
    malloc.free(cmdPtr);
  }

  void editCustomKeyCommand(
      int index, int action, int modifiers, int key, String command) {
    final cmdPtr = command.toNativeUtf8();
    _miracleConfigEditCustomKeyCommand(
        _ptr, index, action, modifiers, key, cmdPtr);
    malloc.free(cmdPtr);
  }

  void clearCustomKeyCommands() {
    _miracleConfigClearCustomKeyCommands(_ptr);
  }

  void removeCustomKeyCommand(int index) {
    _miracleConfigRemoveCustomKeyCommand(_ptr, index);
  }

  // Startup apps
  List<MiracleStartupApp> getStartupApps() {
    final count = _miracleConfigGetStartupAppCount(_ptr);
    final apps = <MiracleStartupApp>[];

    for (var i = 0; i < count; i++) {
      final app = _miracleConfigGetStartupApp(_ptr, i);
      apps.add(
        MiracleStartupApp(
          command: app.command.toDartString(),
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
    final cmdPtr = command.toNativeUtf8();
    _miracleConfigAddStartupApp(
      _ptr,
      cmdPtr,
      restartOnDeath,
      noStartupId,
      shouldHaltCompositorOnDeath,
      inSystemdScope,
    );
    malloc.free(cmdPtr);
  }

  void updateStartupApp(
    int index,
    String command, {
    bool restartOnDeath = false,
    bool noStartupId = false,
    bool shouldHaltCompositorOnDeath = false,
    bool inSystemdScope = false,
  }) {
    final cmdPtr = command.toNativeUtf8();
    _miracleConfigSetStartupApp(
      _ptr,
      index,
      cmdPtr,
      restartOnDeath,
      noStartupId,
      shouldHaltCompositorOnDeath,
      inSystemdScope,
    );
    malloc.free(cmdPtr);
  }

  bool removeStartupApp(int index) =>
      _miracleConfigRemoveStartupApp(_ptr, index);

  // Environment variables
  List<MiracleEnvVar> getEnvironmentVariables() {
    final count = _miracleConfigGetEnvVarCount(_ptr);
    final vars = <MiracleEnvVar>[];

    for (var i = 0; i < count; i++) {
      final var_ = _miracleConfigGetEnvVar(_ptr, i);
      vars.add(
        MiracleEnvVar(
          key: var_.key.toDartString(),
          value: var_.value.toDartString(),
        ),
      );
    }

    return vars;
  }

  void addEnvironmentVariable(String key, String value) {
    final keyPtr = key.toNativeUtf8();
    final valuePtr = value.toNativeUtf8();
    _miracleConfigAddEnvVar(_ptr, keyPtr, valuePtr);
    malloc.free(keyPtr);
    malloc.free(valuePtr);
  }

  void clearEnvironmentVariables() => _miracleConfigClearEnvVars(_ptr);
  bool removeEnvironmentVariable(int index) =>
      _miracleConfigRemoveEnvVar(_ptr, index);

  // Built-in key commands
  List<MiracleBuiltInKeyCommand> getBuiltInKeyCommands() {
    final count = _miracleConfigGetBuiltInKeyCommandOverrideCount(_ptr);
    final commands = <MiracleBuiltInKeyCommand>[];

    for (var i = 0; i < count; i++) {
      final cmd = _miracleConfigGetBuiltInKeyCommandOverride(_ptr, i);
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
    _miracleConfigAddBuiltInKeyCommandOverride(
        _ptr, action, modifiers, key, command);
  }

  void updateBuiltInKeyCommand(
      int index, int action, int modifiers, int key, int command) {
    _miracleConfigSetBuiltInKeyCommandOverride(
        _ptr, index, action, modifiers, key, command);
  }

  bool removeBuiltInKeyCommand(int index) {
    return _miracleConfigRemoveBuiltInKeyCommandOverride(_ptr, index);
  }

  int _doubleColorToInt(double color) {
    return (color * 255.0).toInt();
  }

  double _intColorToDouble(int color) {
    return color / 255.0;
  }

  Color ffiColorArrayToColor(Array<Float> focusColor) {
    return Color.fromARGB(
        _doubleColorToInt(focusColor[3]),
        _doubleColorToInt(focusColor[0]),
        _doubleColorToInt(focusColor[1]),
        _doubleColorToInt(focusColor[2]));
  }

  // Border config
  MiracleBorderConfig getBorderConfig() {
    final config = _miracleConfigGetBorderConfig(_ptr);
    return MiracleBorderConfig(
      size: config.size,
      focusColor: ffiColorArrayToColor(config.focus_color),
      color: ffiColorArrayToColor(config.color),
    );
  }

  void setBorderConfig(MiracleBorderConfig config) {
    final focusColor = calloc<Float>(4);
    focusColor[0] = config.focusColor.a.toDouble();
    focusColor[1] = config.focusColor.b.toDouble();
    focusColor[2] = config.focusColor.g.toDouble();
    focusColor[3] = config.focusColor.r.toDouble();

    final color = calloc<Float>(4);
    color[0] = config.color.a.toDouble();
    color[1] = config.color.b.toDouble();
    color[2] = config.color.g.toDouble();
    color[3] = config.color.r.toDouble();

    _miracleConfigSetBorderConfig(_ptr, config.size, focusColor, color);
    calloc.free(focusColor);
    calloc.free(color);
  }

  // Animation definitions
  MiracleAnimationDefinition getAnimationDefinition(
    MiracleAnimatableEvent event,
  ) {
    final def = _miracleConfigGetAnimationDef(_ptr, event.index);
    return MiracleAnimationDefinition(
      type: MiracleAnimationType.values[def.type],
      function: MiracleEaseFunction.values[def.function],
      durationSeconds: def.duration_seconds,
      c1: def.c1,
      c2: def.c2,
      c3: def.c3,
      c4: def.c4,
      c5: def.c5,
      n1: def.n1,
      d1: def.d1,
    );
  }

  void setAnimationDefinition(
    MiracleAnimatableEvent event,
    MiracleAnimationDefinition def,
  ) {
    final defPtr = calloc<_MiracleAnimationDef>();
    defPtr.ref
      ..type = def.type.index
      ..function = def.function.index
      ..duration_seconds = def.durationSeconds
      ..c1 = def.c1
      ..c2 = def.c2
      ..c3 = def.c3
      ..c4 = def.c4
      ..c5 = def.c5
      ..n1 = def.n1
      ..d1 = def.d1;

    _miracleConfigSetAnimationDef(_ptr, event.index, defPtr);
    calloc.free(defPtr);
  }

  // Workspace config
  List<MiracleWorkspaceConfig> getWorkspaceConfigs() {
    final count = _miracleConfigGetWorkspaceConfigCount(_ptr);
    final configs = <MiracleWorkspaceConfig>[];

    for (var i = 0; i < count; i++) {
      final config = _miracleConfigGetWorkspaceConfig(_ptr, i);
      configs.add(
        MiracleWorkspaceConfig(
          num: config.num,
          containerType: config.container_type,
          name: config.name.address == 0 ? null : config.name.toDartString(),
        ),
      );
    }

    return configs;
  }

  void addWorkspaceConfig(int num, int containerType, {String? name}) {
    final namePtr = name?.toNativeUtf8() ?? nullptr;
    _miracleConfigAddWorkspaceConfig(_ptr, num, containerType, namePtr);
    if (name != null) malloc.free(namePtr);
  }

  void clearWorkspaceConfigs() => _miracleConfigClearWorkspaceConfigs(_ptr);
  bool removeWorkspaceConfig(int index) =>
      _miracleConfigRemoveWorkspaceConfig(_ptr, index);

  // Move modifier
  int get moveModifier => _miracleConfigGetMoveModifier(_ptr);
  set moveModifier(int modifier) =>
      _miracleConfigSetMoveModifier(_ptr, modifier);

  // Drag and drop
  // MiracleDragAndDropConfig get dragAndDrop {
  //   final config = _miracleConfigGetDragAndDrop(_ptr);
  //   return MiracleDragAndDropConfig(
  //     enabled: config.enabled,
  //     modifiers: config.modifiers,
  //   );
  // }

  // set dragAndDrop(MiracleDragAndDropConfig config) {
  //   _miracleConfigSetDragAndDrop(_ptr, config.enabled, config.modifiers);
  // }
}

// Error types
base class _MiracleConfigError extends Struct {
  @Int32()
  external int line;

  @Int32()
  external int column;

  @Int32()
  external int level;

  external Pointer<Utf8> filename;

  external Pointer<Utf8> message;
}

// Config data struct
base class _MiracleConfigData extends Struct {
  external Pointer<Void> _internal;
}

// Load result struct
base class _MiracleConfigLoadResult extends Struct {
  external _MiracleConfigData config;
  external Pointer<Void> _errors;
}

// Custom key command
base class _MiracleCustomKeyCommand extends Struct {
  @Int32()
  external int action;

  @Uint32()
  external int modifiers;

  @Int32()
  external int key;

  external Pointer<Utf8> command;
}

// Built in key commands
base class _MiracleBuiltInKeyCommand extends Struct {
  @Uint32()
  external int action;

  @Uint32()
  external int modifiers;

  @Int32()
  external int key;

  @Uint32()
  external int command;
}

// Dart-friendly wrapper classes
class MiracleOption {
  MiracleOption({required this.name, required this.value});

  final String name;
  final int value;
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

class MiracleBorderConfig {
  final int size;
  final Color focusColor; // RGBA
  final Color color; // RGBA

  MiracleBorderConfig({
    required this.size,
    required this.focusColor,
    required this.color,
  });
}

// Struct definitions
base class _MiracleOption extends Struct {
  external Pointer<Utf8> name;
  @Uint32()
  external int value;
}

base class _MiracleStartupApp extends Struct {
  external Pointer<Utf8> command;
  @Bool()
  external bool restart_on_death;
  @Bool()
  external bool no_startup_id;
  @Bool()
  external bool should_halt_compositor_on_death;
  @Bool()
  external bool in_systemd_scope;
}

base class _MiracleEnvVar extends Struct {
  external Pointer<Utf8> key;
  external Pointer<Utf8> value;
}

base class _MiracleKeyCommand extends Struct {
  @Int32()
  external int action;
  @Uint32()
  external int modifiers;
  @Int32()
  external int key;
}

base class _MiracleBorderConfig extends Struct {
  @Int32()
  external int size;
  @Array(4)
  external Array<Float> focus_color;
  @Array(4)
  external Array<Float> color;
}

base class _MiracleAnimationDef extends Struct {
  @Int32()
  external int type;
  @Int32()
  external int function;
  @Float()
  external double duration_seconds;
  @Float()
  external double c1;
  @Float()
  external double c2;
  @Float()
  external double c3;
  @Float()
  external double c4;
  @Float()
  external double c5;
  @Float()
  external double n1;
  @Float()
  external double d1;
}

base class _MiracleWorkspaceConfig extends Struct {
  @Int32()
  external int num;
  @Int32()
  external int container_type;
  external Pointer<Utf8> name;
}

base class _MiracleDragAndDrop extends Struct {
  @Bool()
  external bool enabled;
  @Uint32()
  external int modifiers;
}

// Wrapper classes
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

class MiracleBuiltInKeyCommand {
  final int action;
  final int modifiers;
  final int key;
  final int builtInAction;

  MiracleBuiltInKeyCommand(
      {required this.action,
      required this.modifiers,
      required this.key,
      required this.builtInAction});
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
    required this.c1,
    required this.c2,
    required this.c3,
    required this.c4,
    required this.c5,
    required this.n1,
    required this.d1,
  });
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

// Enums
enum MiracleAnimationType {
  disabled,
  slide,
  grow,
  shrink,
  fadeIn,
  fadeOut,
  max,
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
  max,
}

enum MiracleAnimatableEvent {
  windowOpen,
  windowMove,
  windowClose,
  workspaceSwitch,
  max,
}
