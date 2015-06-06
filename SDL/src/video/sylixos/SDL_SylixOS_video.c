/*
    SDL - Simple DirectMedia Layer

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

    Han.Hui
    sylixos@gmail.com
*/
#include "SDL_config.h"

#include "SDL_video.h"
#include "SDL_mouse.h"
#include "../SDL_sysvideo.h"
#include "../SDL_pixels_c.h"
#include "../../events/SDL_events_c.h"

#include "SDL_SylixOS_video.h"
#include "SDL_SylixOS_events.h"

extern SDL_VideoDevice  *(*_G_pfuncSDLVideoCreateDevice)();

static int SylixOS_Available (void)
{
  return 1;
}

static SDL_VideoDevice *SylixOS_CreateDevice (int devindex)
{
    if (_G_pfuncSDLVideoCreateDevice) {
        return  (_G_pfuncSDLVideoCreateDevice(devindex));
    } else {
        return  (NULL);
    }
}

VideoBootStrap SylixOS_bootstrap = {
  "sylixos", "SylixOS graph driver",
  SylixOS_Available, SylixOS_CreateDevice
};

/* end of SDL_SylixOS_video.c ... */
