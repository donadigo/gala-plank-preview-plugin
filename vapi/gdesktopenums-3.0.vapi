/* gdesktopenums-3.0.vapi generated by vapigen, do not modify. */

[CCode (cprefix = "GDesktop", gir_namespace = "GDesktopEnums", gir_version = "3.0", lower_case_cprefix = "g_desktop_")]
namespace GDesktop {
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_BACKGROUND_SHADING_", has_type_id = false)]
	public enum BackgroundShading {
		SOLID,
		VERTICAL,
		HORIZONTAL
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_BACKGROUND_STYLE_", has_type_id = false)]
	public enum BackgroundStyle {
		NONE,
		WALLPAPER,
		CENTERED,
		SCALED,
		STRETCHED,
		ZOOM,
		SPANNED
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_CLOCK_FORMAT_", has_type_id = false)]
	public enum ClockFormat {
		@24H,
		@12H
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_DEVICE_SEND_EVENTS_", has_type_id = false)]
	public enum DeviceSendEvents {
		ENABLED,
		DISABLED,
		DISABLED_ON_EXTERNAL_MOUSE
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_FOCUS_MODE_", has_type_id = false)]
	public enum FocusMode {
		CLICK,
		SLOPPY,
		MOUSE
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_FOCUS_NEW_WINDOWS_", has_type_id = false)]
	public enum FocusNewWindows {
		SMART,
		STRICT
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_LOCATION_ACCURACY_LEVEL_", has_type_id = false)]
	public enum LocationAccuracyLevel {
		COUNTRY,
		CITY,
		NEIGHBORHOOD,
		STREET,
		EXACT
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_MAGNIFIER_CARET_TRACKING_MODE_", has_type_id = false)]
	public enum MagnifierCaretTrackingMode {
		NONE,
		CENTERED,
		PROPORTIONAL,
		PUSH
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_MAGNIFIER_FOCUS_TRACKING_MODE_", has_type_id = false)]
	public enum MagnifierFocusTrackingMode {
		NONE,
		CENTERED,
		PROPORTIONAL,
		PUSH
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_MAGNIFIER_MOUSE_TRACKING_MODE_", has_type_id = false)]
	public enum MagnifierMouseTrackingMode {
		NONE,
		CENTERED,
		PROPORTIONAL,
		PUSH
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_MAGNIFIER_SCREEN_POSITION_", has_type_id = false)]
	public enum MagnifierScreenPosition {
		NONE,
		FULL_SCREEN,
		TOP_HALF,
		BOTTOM_HALF,
		LEFT_HALF,
		RIGHT_HALF
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_MOUSE_DWELL_DIRECTION_", has_type_id = false)]
	public enum MouseDwellDirection {
		LEFT,
		RIGHT,
		UP,
		DOWN
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_MOUSE_DWELL_MODE_", has_type_id = false)]
	public enum MouseDwellMode {
		WINDOW,
		GESTURE
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_PAD_BUTTON_ACTION_", has_type_id = false)]
	public enum PadButtonAction {
		NONE,
		HELP,
		SWITCH_MONITOR,
		KEYBINDING
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_POINTER_ACCEL_PROFILE_", has_type_id = false)]
	public enum PointerAccelProfile {
		DEFAULT,
		FLAT,
		ADAPTIVE
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_PROXY_MODE_", has_type_id = false)]
	public enum ProxyMode {
		NONE,
		MANUAL,
		AUTO
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_SCREENSAVER_MODE_", has_type_id = false)]
	public enum ScreensaverMode {
		BLANK_ONLY,
		RANDOM,
		SINGLE
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_STYLUS_BUTTON_ACTION_", has_type_id = false)]
	public enum StylusButtonAction {
		DEFAULT,
		MIDDLE,
		RIGHT,
		BACK,
		FORWARD
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_TABLET_MAPPING_", has_type_id = false)]
	public enum TabletMapping {
		ABSOLUTE,
		RELATIVE
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_TITLEBAR_ACTION_", has_type_id = false)]
	public enum TitlebarAction {
		TOGGLE_SHADE,
		TOGGLE_MAXIMIZE,
		TOGGLE_MAXIMIZE_HORIZONTALLY,
		TOGGLE_MAXIMIZE_VERTICALLY,
		MINIMIZE,
		NONE,
		LOWER,
		MENU
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_TOOLBAR_ICON_SIZE_", has_type_id = false)]
	public enum ToolbarIconSize {
		SMALL,
		LARGE
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_TOOLBAR_STYLE_", has_type_id = false)]
	public enum ToolbarStyle {
		BOTH,
		BOTH_HORIZ,
		ICONS,
		TEXT
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_TOUCHPAD_CLICK_METHOD_", has_type_id = false)]
	public enum TouchpadClickMethod {
		DEFAULT,
		NONE,
		AREAS,
		FINGERS
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_TOUCHPAD_HANDEDNESS_", has_type_id = false)]
	public enum TouchpadHandedness {
		RIGHT,
		LEFT,
		MOUSE
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_TOUCHPAD_SCROLL_METHOD_", has_type_id = false)]
	public enum TouchpadScrollMethod {
		DISABLED,
		EDGE_SCROLLING,
		TWO_FINGER_SCROLLING
	}
	[CCode (cheader_filename = "gsettings-desktop-schemas/gdesktop-enums.h", cprefix = "G_DESKTOP_VISUAL_BELL_", has_type_id = false)]
	public enum VisualBellType {
		FULLSCREEN_FLASH,
		FRAME_FLASH
	}
}
