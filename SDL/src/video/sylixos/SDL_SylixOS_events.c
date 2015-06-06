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

#include "keyboard.h"
#include "mouse.h"

#include "SDL.h"
#include "../../events/SDL_sysevents.h"
#include "../../events/SDL_events_c.h"

#include "SDL_SylixOS_video.h"
#include "SDL_SylixOS_events.h"

static SDLKey keymap[512];

static int                          key_pend_flag = 0;
static int                          mouse_pend_flag = 0;

static keyboard_event_notify        key_event;
static mouse_event_notify           mouse_event;

static SDL_keysym *SylixOS_TranslateKey (keyboard_event_notify *ev, SDL_keysym *keysym)
{
    if (keysym && ev) {
        keysym->unicode  = 0;
        keysym->scancode = (Uint8)ev->keymsg[0];
        keysym->mod      = KMOD_NONE;
        if (ev->fkstat & KE_FK_CTRL) {
            keysym->mod |= KMOD_LCTRL;
        }
        if (ev->fkstat & KE_FK_CTRLR) {
            keysym->mod |= KMOD_RCTRL;
        }
        if (ev->fkstat & KE_FK_ALT) {
            keysym->mod |= KMOD_LALT;
        }
        if (ev->fkstat & KE_FK_ALTR) {
            keysym->mod |= KMOD_RALT;
        }
        if (ev->fkstat & KE_FK_SHIFT) {
            keysym->mod |= KMOD_LSHIFT;
        }
        if (ev->fkstat & KE_FK_SHIFTR) {
            keysym->mod |= KMOD_RSHIFT;
        }
        if ((ev->keymsg[0] >= 0) && (ev->keymsg[0] <= 255)) {
            keysym->sym = keymap[ev->keymsg[0]];
        } else {
            keysym->sym = SDLK_UNKNOWN;
        }

        return  keysym;
    } else {
        return  NULL;
    }
}

static int SylixOS_TranslateButton (mouse_event_notify *ev)
{
    if (ev->kstat & MOUSE_LEFT) {
        return 1;
    } else if (ev->kstat & MOUSE_MIDDLE) {
        return 2;
    } else if (ev->kstat & MOUSE_RIGHT) {
        return 3;
    } else {
        return 0;
    }
}

void SylixOS_PumpEvents (_THIS)
{
    keyboard_event_notify   key_event_temp;
    mouse_event_notify      mouse_event_temp;
    SDL_keysym              keysym;

    /* TODO: support later... */

    while (key_pend_flag) {
        key_event_temp = key_event;
        key_pend_flag  = 0;

        if (key_event_temp.type == KE_PRESS) {
            SDL_PrivateKeyboard(SDL_PRESSED, SylixOS_TranslateKey(&key_event_temp, &keysym));
        } else {
            SDL_PrivateKeyboard(SDL_RELEASED, SylixOS_TranslateKey(&key_event_temp, &keysym));
        }
    }

    while (mouse_pend_flag) {
        mouse_event_temp = mouse_event;
        mouse_pend_flag = 0;

        if (mouse_event_temp.kstat & MOUSE_LEFT) {
            SDL_PrivateMouseButton(SDL_PRESSED, SylixOS_TranslateButton(&mouse_event_temp), 0, 0);
        } else {
            SDL_PrivateMouseButton(SDL_RELEASED, SylixOS_TranslateButton(&mouse_event_temp), 0, 0);
        }
    }
}

void SylixOS_InitOSKeymap (_THIS)
{
    int i;

    /* Initialize the SylixOS key translation table */
    for (i=0; i<SDL_arraysize(keymap); ++i)
        keymap[i] = SDLK_UNKNOWN;

    keymap['0'] = SDLK_0;
    keymap['1'] = SDLK_1;
    keymap['2'] = SDLK_2;
    keymap['3'] = SDLK_3;
    keymap['4'] = SDLK_4;
    keymap['5'] = SDLK_5;
    keymap['6'] = SDLK_6;
    keymap['7'] = SDLK_7;
    keymap['8'] = SDLK_8;
    keymap['9'] = SDLK_9;

    keymap[' '] = SDLK_SPACE;
    keymap[':'] = SDLK_COLON;
    keymap[':'] = SDLK_SEMICOLON;
    keymap['<'] = SDLK_LESS;
    keymap['='] = SDLK_EQUALS;
    keymap['>'] = SDLK_GREATER;
    keymap['?'] = SDLK_QUESTION;
    keymap['@'] = SDLK_AT;
    keymap['['] = SDLK_LEFTBRACKET;
    keymap['\\'] = SDLK_BACKSLASH;
    keymap[']'] = SDLK_RIGHTBRACKET;
    keymap['^'] = SDLK_CARET;
    keymap['_'] = SDLK_UNDERSCORE;
    keymap['`'] = SDLK_BACKQUOTE;

    keymap['!'] = SDLK_EXCLAIM;
    keymap['\"'] = SDLK_QUOTEDBL;
    keymap['#'] = SDLK_HASH;
    keymap['$'] = SDLK_DOLLAR;
    keymap['&'] = SDLK_AMPERSAND;
    keymap['\''] = SDLK_QUOTE;
    keymap['('] = SDLK_LEFTPAREN;
    keymap[')'] = SDLK_RIGHTPAREN;
    keymap['*'] = SDLK_ASTERISK;
    keymap['+'] = SDLK_PLUS;
    keymap[','] = SDLK_COMMA;
    keymap['-'] = SDLK_MINUS;
    keymap['.'] = SDLK_PERIOD;
    keymap['/'] = SDLK_SLASH;

    keymap['a'] = SDLK_a;
    keymap['b'] = SDLK_b;
    keymap['c'] = SDLK_c;
    keymap['d'] = SDLK_d;
    keymap['e'] = SDLK_e;
    keymap['f'] = SDLK_f;
    keymap['g'] = SDLK_g;
    keymap['h'] = SDLK_h;
    keymap['i'] = SDLK_i;
    keymap['j'] = SDLK_j;
    keymap['k'] = SDLK_k;
    keymap['l'] = SDLK_l;
    keymap['m'] = SDLK_m;
    keymap['n'] = SDLK_n;
    keymap['o'] = SDLK_o;
    keymap['p'] = SDLK_p;
    keymap['q'] = SDLK_q;
    keymap['r'] = SDLK_r;
    keymap['s'] = SDLK_s;
    keymap['t'] = SDLK_t;
    keymap['u'] = SDLK_u;
    keymap['v'] = SDLK_v;
    keymap['w'] = SDLK_w;
    keymap['x'] = SDLK_x;
    keymap['y'] = SDLK_y;
    keymap['z'] = SDLK_z;

    keymap[K_F1]  = SDLK_F1;
    keymap[K_F2]  = SDLK_F2;
    keymap[K_F3]  = SDLK_F3;
    keymap[K_F4]  = SDLK_F4;
    keymap[K_F5]  = SDLK_F5;
    keymap[K_F6]  = SDLK_F6;
    keymap[K_F7]  = SDLK_F7;
    keymap[K_F8]  = SDLK_F8;
    keymap[K_F9]  = SDLK_F9;
    keymap[K_F10] = SDLK_F10;
    keymap[K_F11] = SDLK_F11;
    keymap[K_F12] = SDLK_F12;
    keymap[K_F13] = SDLK_F13;
    keymap[K_F14] = SDLK_F14;
    keymap[K_F15] = SDLK_F15;

    keymap[K_ESC]       = SDLK_ESCAPE;
    keymap[K_TAB]       = SDLK_TAB;
    keymap[K_CAPSLOCK]  = SDLK_CAPSLOCK;
    keymap[K_SHIFT]     = SDLK_LSHIFT;
    keymap[K_CTRL]      = SDLK_LCTRL;
    keymap[K_ALT]       = SDLK_LALT;
    keymap[K_SHIFTR]    = SDLK_RSHIFT;
    keymap[K_CTRLR]     = SDLK_RCTRL;
    keymap[K_ALTR]      = SDLK_RALT;
    keymap[K_ENTER]     = SDLK_RETURN;
    keymap[K_BACKSPACE] = SDLK_BACKSPACE;

    keymap[K_PRINTSCREEN] = SDLK_PRINT;
    keymap[K_SCROLLLOCK]  = SDLK_SCROLLOCK;
    keymap[K_PAUSEBREAK]  = SDLK_PAUSE;

    keymap[K_INSERT]   = SDLK_INSERT;
    keymap[K_HOME]     = SDLK_HOME;
    keymap[K_DELETE]   = SDLK_DELETE;
    keymap[K_END]      = SDLK_END;
    keymap[K_PAGEUP]   = SDLK_PAGEUP;
    keymap[K_PAGEDOWN] = SDLK_PAGEDOWN;

    keymap[K_UP]    = SDLK_UP;
    keymap[K_DOWN]  = SDLK_DOWN;
    keymap[K_LEFT]  = SDLK_LEFT;
    keymap[K_RIGHT] = SDLK_RIGHT;

    keymap[K_NUMLOCK] = SDLK_NUMLOCK;

    keymap[K_WIN]    = SDLK_LSUPER;
    keymap[K_WINR]   = SDLK_RSUPER;
    keymap[K_RCLICK] = SDLK_COMPOSE;
}

/* end of SDL_SylixOS_events.c ... */
