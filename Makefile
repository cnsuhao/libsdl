#*********************************************************************************************************
# libsdl Makefile
# target -> libsdl.a  
#           libsdl.so
#*********************************************************************************************************

#*********************************************************************************************************
# include config.mk
#*********************************************************************************************************
CONFIG_MK_EXIST = $(shell if [ -f ../config.mk ]; then echo exist; else echo notexist; fi;)
ifeq ($(CONFIG_MK_EXIST), exist)
include ../config.mk
else
CONFIG_MK_EXIST = $(shell if [ -f config.mk ]; then echo exist; else echo notexist; fi;)
ifeq ($(CONFIG_MK_EXIST), exist)
include config.mk
else
CONFIG_MK_EXIST =
endif
endif

#*********************************************************************************************************
# check configure
#*********************************************************************************************************
check_defined = \
    $(foreach 1,$1,$(__check_defined))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $(value 2), ($(strip $2)))))

$(call check_defined, CONFIG_MK_EXIST, Please configure this project in RealCoder or \
create a config.mk file!)
$(call check_defined, SYLIXOS_BASE_PATH, SylixOS base project path)
$(call check_defined, TOOLCHAIN_PREFIX, the prefix name of toolchain)
$(call check_defined, DEBUG_LEVEL, debug level(debug or release))

#*********************************************************************************************************
# configure area you can set the following config to you own system
# FPUFLAGS (-mfloat-abi=softfp -mfpu=vfpv3 ...)
# CPUFLAGS (-mcpu=arm920t ...)
# NOTICE: libsylixos, BSP and other kernel modules projects CAN NOT use vfp!
#*********************************************************************************************************
FPUFLAGS = 
CPUFLAGS = -mcpu=arm920t $(FPUFLAGS)

#*********************************************************************************************************
# toolchain select
#*********************************************************************************************************
CC  = $(TOOLCHAIN_PREFIX)gcc
CXX = $(TOOLCHAIN_PREFIX)g++
AS  = $(TOOLCHAIN_PREFIX)gcc
AR  = $(TOOLCHAIN_PREFIX)ar
LD  = $(TOOLCHAIN_PREFIX)g++

#*********************************************************************************************************
# do not change the following code
# buildin internal application source
#*********************************************************************************************************
#*********************************************************************************************************
# src(s) file
#*********************************************************************************************************
SRCS = \
SDL/SDL_sylixos.c \
SDL/src/SDL.c \
SDL/src/SDL_error.c \
SDL/src/SDL_fatal.c \
SDL/src/cpuinfo/SDL_cpuinfo.c \
SDL/src/audio/SDL_audio.c \
SDL/src/audio/SDL_audiocvt.c \
SDL/src/audio/SDL_audiodev.c \
SDL/src/audio/SDL_mixer.c \
SDL/src/audio/SDL_mixer_m68k.c \
SDL/src/audio/SDL_mixer_MMX.c \
SDL/src/audio/SDL_mixer_MMX_VC.c \
SDL/src/audio/SDL_wave.c \
SDL/src/audio/dma/SDL_dmaaudio.c \
SDL/src/audio/dsp/SDL_dspaudio.c \
SDL/src/cdrom/SDL_cdrom.c \
SDL/src/cdrom/dummy/SDL_syscdrom.c \
SDL/src/events/SDL_active.c \
SDL/src/events/SDL_events.c \
SDL/src/events/SDL_expose.c \
SDL/src/events/SDL_keyboard.c \
SDL/src/events/SDL_mouse.c \
SDL/src/events/SDL_quit.c \
SDL/src/events/SDL_resize.c \
SDL/src/file/SDL_rwops.c \
SDL/src/joystick/SDL_joystick.c \
SDL/src/joystick/dummy/SDL_sysjoystick.c \
SDL/src/loadso/dlopen/SDL_sysloadso.c \
SDL/src/stdlib/SDL_getenv.c \
SDL/src/stdlib/SDL_iconv.c \
SDL/src/stdlib/SDL_malloc.c \
SDL/src/stdlib/SDL_qsort.c \
SDL/src/stdlib/SDL_stdlib.c \
SDL/src/stdlib/SDL_string.c \
SDL/src/thread/SDL_thread.c \
SDL/src/thread/pthread/SDL_syscond.c \
SDL/src/thread/pthread/SDL_sysmutex.c \
SDL/src/thread/pthread/SDL_syssem.c \
SDL/src/thread/pthread/SDL_systhread.c \
SDL/src/timer/SDL_timer.c \
SDL/src/timer/unix/SDL_systimer.c \
SDL/src/video/SDL_blit.c \
SDL/src/video/SDL_blit_0.c \
SDL/src/video/SDL_blit_1.c \
SDL/src/video/SDL_blit_A.c \
SDL/src/video/SDL_blit_N.c \
SDL/src/video/SDL_bmp.c \
SDL/src/video/SDL_cursor.c \
SDL/src/video/SDL_gamma.c \
SDL/src/video/SDL_pixels.c \
SDL/src/video/SDL_RLEaccel.c \
SDL/src/video/SDL_stretch.c \
SDL/src/video/SDL_surface.c \
SDL/src/video/SDL_video.c \
SDL/src/video/SDL_yuv.c \
SDL/src/video/SDL_yuv_mmx.c \
SDL/src/video/SDL_yuv_sw.c \
SDL/src/video/dummy/SDL_nullevents.c \
SDL/src/video/dummy/SDL_nullmouse.c \
SDL/src/video/dummy/SDL_nullvideo.c \
SDL/src/video/sylixos/SDL_SylixOS_events.c \
SDL/src/video/sylixos/SDL_SylixOS_video.c \
SDL_mixer/dynamic_flac.c \
SDL_mixer/dynamic_fluidsynth.c \
SDL_mixer/dynamic_mod.c \
SDL_mixer/dynamic_mp3.c \
SDL_mixer/dynamic_ogg.c \
SDL_mixer/effects_internal.c \
SDL_mixer/effect_position.c \
SDL_mixer/effect_stereoreverse.c \
SDL_mixer/fluidsynth.c \
SDL_mixer/load_aiff.c \
SDL_mixer/load_flac.c \
SDL_mixer/load_ogg.c \
SDL_mixer/load_voc.c \
SDL_mixer/mixer.c \
SDL_mixer/music.c \
SDL_mixer/music_cmd.c \
SDL_mixer/music_flac.c \
SDL_mixer/music_mad.c \
SDL_mixer/music_mod.c \
SDL_mixer/music_modplug.c \
SDL_mixer/music_ogg.c \
SDL_mixer/wavestream.c \
SDL_mixer/native_midi/native_midi_common.c \
SDL_mixer/timidity/common.c \
SDL_mixer/timidity/ctrlmode.c \
SDL_mixer/timidity/filter.c \
SDL_mixer/timidity/instrum.c \
SDL_mixer/timidity/mix.c \
SDL_mixer/timidity/output.c \
SDL_mixer/timidity/playmidi.c \
SDL_mixer/timidity/readmidi.c \
SDL_mixer/timidity/resample.c \
SDL_mixer/timidity/sdl_a.c \
SDL_mixer/timidity/sdl_c.c \
SDL_mixer/timidity/tables.c \
SDL_mixer/timidity/timidity.c \
SDL_net/SDLnet.c \
SDL_net/SDLnetselect.c \
SDL_net/SDLnetTCP.c \
SDL_net/SDLnetUDP.c \

#*********************************************************************************************************
# build path
#*********************************************************************************************************
ifeq ($(DEBUG_LEVEL), debug)
OUTDIR = Debug
else
OUTDIR = Release
endif

OUTPATH = ./$(OUTDIR)
OBJPATH = $(OUTPATH)/obj
DEPPATH = $(OUTPATH)/dep

#*********************************************************************************************************
#  target
#*********************************************************************************************************
LIB = $(OUTPATH)/libsdl.a
DLL = $(OUTPATH)/libsdl.so

#*********************************************************************************************************
# objects
#*********************************************************************************************************
OBJS = $(addprefix $(OBJPATH)/, $(addsuffix .o, $(basename $(SRCS))))
DEPS = $(addprefix $(DEPPATH)/, $(addsuffix .d, $(basename $(SRCS))))

#*********************************************************************************************************
# include path
#*********************************************************************************************************
INCDIR  = -I"$(SYLIXOS_BASE_PATH)/libsylixos/SylixOS"
INCDIR += -I"$(SYLIXOS_BASE_PATH)/libsylixos/SylixOS/include"
INCDIR += -I"$(SYLIXOS_BASE_PATH)/libsylixos/SylixOS/include/inet"
INCDIR += -I"./SDL/include"

#*********************************************************************************************************
# compiler preprocess
#*********************************************************************************************************
DSYMBOL  = -DSYLIXOS
DSYMBOL += -DSYLIXOS_LIB

#*********************************************************************************************************
# depend dynamic library
#*********************************************************************************************************
DEPEND_DLL = 

#*********************************************************************************************************
# depend dynamic library search path
#*********************************************************************************************************
DEPEND_DLL_PATH = 

#*********************************************************************************************************
# compiler optimize
#*********************************************************************************************************
ifeq ($(DEBUG_LEVEL), debug)
OPTIMIZE = -O0 -g3 -gdwarf-2
else
OPTIMIZE = -O2 -g1 -gdwarf-2											# Do NOT use -O3 and -Os
endif										    						# -Os is not align for function
																		# loop and jump.
#*********************************************************************************************************
# depends and compiler parameter (cplusplus in kernel MUST NOT use exceptions and rtti)
#*********************************************************************************************************
DEPENDFLAG  = -MM
CXX_EXCEPT  = -fno-exceptions -fno-rtti
COMMONFLAGS = $(CPUFLAGS) $(OPTIMIZE) -Wall -fmessage-length=0 -fsigned-char -fno-short-enums
ASFLAGS     = -x assembler-with-cpp $(DSYMBOL) $(INCDIR) $(COMMONFLAGS) -c
CFLAGS      = $(DSYMBOL) $(INCDIR) $(COMMONFLAGS) -fPIC -c
CXXFLAGS    = $(DSYMBOL) $(INCDIR) $(CXX_EXCEPT) $(COMMONFLAGS) -fPIC -c
ARFLAGS     = -r

#*********************************************************************************************************
# define some useful variable
#*********************************************************************************************************
DEPEND          = $(CC)  $(DEPENDFLAG) $(CFLAGS)
DEPEND.d        = $(subst -g ,,$(DEPEND))
COMPILE.S       = $(AS)  $(ASFLAGS)
COMPILE_VFP.S   = $(AS)  $(ASFLAGS)
COMPILE.c       = $(CC)  $(CFLAGS)
COMPILE.cxx     = $(CXX) $(CXXFLAGS)

#*********************************************************************************************************
# target
#*********************************************************************************************************
all: $(LIB) $(DLL)
		@echo create "$(LIB) $(DLL)" success.

#*********************************************************************************************************
# include depends
#*********************************************************************************************************
ifneq ($(MAKECMDGOALS), clean)
ifneq ($(MAKECMDGOALS), clean_project)
sinclude $(DEPS)
endif
endif

#*********************************************************************************************************
# create depends files
#*********************************************************************************************************
$(DEPPATH)/%.d: %.c
		@echo creating $@
		@if [ ! -d "$(dir $@)" ]; then mkdir -p "$(dir $@)"; fi
		@rm -f $@; \
		echo -n '$@ $(addprefix $(OBJPATH)/, $(dir $<))' > $@; \
		$(DEPEND.d) $< >> $@ || rm -f $@; exit;

$(DEPPATH)/%.d: %.cpp
		@echo creating $@
		@if [ ! -d "$(dir $@)" ]; then mkdir -p "$(dir $@)"; fi
		@rm -f $@; \
		echo -n '$@ $(addprefix $(OBJPATH)/, $(dir $<))' > $@; \
		$(DEPEND.d) $< >> $@ || rm -f $@; exit;

#*********************************************************************************************************
# compile source files
#*********************************************************************************************************
$(OBJPATH)/%.o: %.S
		@if [ ! -d "$(dir $@)" ]; then mkdir -p "$(dir $@)"; fi
		$(COMPILE.S) $< -o $@

$(OBJPATH)/%.o: %.c
		@if [ ! -d "$(dir $@)" ]; then mkdir -p "$(dir $@)"; fi
		$(COMPILE.c) $< -o $@

$(OBJPATH)/%.o: %.cpp
		@if [ ! -d "$(dir $@)" ]; then mkdir -p "$(dir $@)"; fi
		$(COMPILE.cxx) $< -o $@

#*********************************************************************************************************
# link libsdl.a object files
#*********************************************************************************************************
$(LIB): $(OBJS)
		$(AR) $(ARFLAGS) $(LIB) $(OBJS)

#*********************************************************************************************************
# link libsdl.so object files
#*********************************************************************************************************
$(DLL): $(OBJS)
		$(LD) $(CPUFLAGS) -nostdlib -fPIC -shared -o $(DLL) $(OBJS) \
		$(DEPEND_DLL_PATH) $(DEPEND_DLL) -lm -lgcc

#*********************************************************************************************************
# clean
#*********************************************************************************************************
.PHONY: clean
.PHONY: clean_project

#*********************************************************************************************************
# clean objects
#*********************************************************************************************************
clean:
		-rm -rf $(LIB)
		-rm -rf $(DLL)
		-rm -rf $(OBJPATH)
		-rm -rf $(DEPPATH)

#*********************************************************************************************************
# clean project
#*********************************************************************************************************
clean_project:
		-rm -rf $(OUTPATH)

#*********************************************************************************************************
# END
#*********************************************************************************************************
