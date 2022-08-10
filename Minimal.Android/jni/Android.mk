# gr: make path absolute so errors have full path
#		this makes them jump in xcode
LOCAL_PATH := $(abspath $(call my-dir))


# extra ../ as jni is always prepended
PROJECT_PATH := ../..
#$(warning $(LOCAL_PATH))	#	debug

# from env (so xcode variable or github var etc)
APP_MODULE := $(TARGET_NAME)


include $(CLEAR_VARS)


# full speed arm instead of thumb
LOCAL_ARM_MODE  := arm

#LOCAL_CFLAGS	+= -DANDROID_NDK
LOCAL_CFLAGS	+= -DTARGET_ANDROID
LOCAL_CFLAGS	+= -Werror			# error on warnings
LOCAL_CFLAGS	+= -Wall
LOCAL_CFLAGS	+= -Wextra
#LOCAL_CFLAGS	+= -Wlogical-op		# not part of -Wall or -Wextra
#LOCAL_CFLAGS	+= -Weffc++			# too many issues to fix for now
LOCAL_CFLAGS	+= -Wno-reorder-ctor		# ignore initialiser order warning, code in std::span needs to be updated
LOCAL_CFLAGS	+= -Wno-strict-aliasing		# TODO: need to rewrite some code
LOCAL_CFLAGS	+= -Wno-unused-parameter
LOCAL_CFLAGS	+= -Wno-sign-compare		# too many errors in draco
LOCAL_CFLAGS	+= -Wno-deprecated-copy-with-user-provided-copy	# error in draco
LOCAL_CFLAGS	+= -Wno-missing-field-initializers	# warns on this: SwipeAction	ret = {}
LOCAL_CFLAGS	+= -Wno-multichar	# used in internal Android headers:  DISPLAY_EVENT_VSYNC = 'vsyn',
LOCAL_CFLAGS	+= -Wno-invalid-source-encoding
LOCAL_CFLAGS	+= -Wno-unused		# unused variable
#LOCAL_CFLAGS	+= -pg -DNDK_PROFILE # compile with profiling
#LOCAL_CFLAGS	+= -mfpu=neon		# ARM NEON support
LOCAL_CFLAGS	+= -DDLL_EXPORT=extern\"C\"
LOCAL_CFLAGS	+= -include Source/Version.h	# force include of version.h (same as windows)
LOCAL_CFLAGS	+= -Wno-type-limits
LOCAL_CFLAGS	+= -Wno-invalid-offsetof

#LOCAL_CFLAGS	+= -fexceptions	# enable exceptions
#LOCAL_CPP_FEATURES += exceptions

#ifeq ($(OVR_DEBUG),1)
#LOCAL_CFLAGS	+= -DOVR_BUILD_DEBUG=1 -O0 -g
#else
LOCAL_CFLAGS	+= -O3
#endif





# gr: using Macos.xcconfig as basis
#	may be able to #include it as syntax is same for globals
LOCAL_C_INCLUDES +=

# use warning as echo
#$(warning $(LOCAL_C_INCLUDES))

LOCAL_STATIC_LIBRARIES =
#LOCAL_STATIC_LIBRARIES += $(LOCAL_PATH)/$(PROJECT_PATH)/PrebuiltLibrarys/PopH264/Android_$(ABI)/libPopH264
#LOCAL_STATIC_LIBRARIES += android-ndk-profiler


#LOCAL_LDLIBS	+= -lGLESv3			# OpenGL ES 3.0
#LOCAL_LDLIBS	+= -lEGL			# GL platform interface
#LOCAL_LDLIBS  	+= -llog			# logging
#LOCAL_LDLIBS  	+= -landroid		# native windows
#LOCAL_LDLIBS	+= -lz				# For minizip
#LOCAL_LDLIBS	+= -lOpenSLES		# audio
#LOCAL_LDLIBS	+= -lmediandk	# native/ndk mediacodec

#LOCAL_LDLIBS	+= -lz				# zlib for curl
#LOCAL_LDLIBS	+= -ldl


# gr: when the test app executable tries to run, it can't find the c++shared.so next to it
#	use this to alter the rpath so it finds it
#LOCAL_LDFLAGS	+= -rdynamic
LOCAL_LDFLAGS	+= -Wl,-rpath,.
#LOCAL_LDFLAGS	+= -Wl,--rpath,'$$ORIGIN'
#LOCAL_LDFLAGS	+= -Wl,-rpath,'$$ORIGIN'
#LOCAL_LDFLAGS	+= -Wl,-rpath-link=.


LOCAL_SRC_FILES  += \
$(PROJECT_PATH)/Source/Minimal.cpp \




LOCAL_MODULE = $(APP_MODULE)_Shared
#	name just CRStreamer.so
LOCAL_MODULE_FILENAME := $(APP_MODULE)

include $(BUILD_SHARED_LIBRARY)



#	build test app
include $(CLEAR_VARS)

# gr: when the test app executable tries to run, it can't find the c++shared.so next to it
#	use this to alter the rpath so it finds it
#LOCAL_LDFLAGS	+= -rdynamic
LOCAL_LDFLAGS	+= -Wl,-rpath,.
#LOCAL_LDFLAGS	+= -Wl,--rpath,'$$ORIGIN'
#LOCAL_LDFLAGS	+= -Wl,-rpath,'$$ORIGIN'

LOCAL_SHARED_LIBRARIES += $(APP_MODULE)_Shared	# use shared to determine if any symbols are missing
LOCAL_MODULE := $(APP_MODULE)_TestApp
LOCAL_MODULE_FILENAME := $(APP_MODULE)TestApp	# may have a better place to get this target name from

include $(BUILD_EXECUTABLE)
