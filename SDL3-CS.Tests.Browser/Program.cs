// Copyright (c) ppy Pty Ltd <contact@ppy.sh>. Licensed under the MIT Licence.
// See the LICENCE file in the repository root for full licence text.

using System.Runtime.InteropServices.JavaScript;
using static SDL.SDL3;

namespace SDL.Tests.Browser
{
    public static unsafe partial class Program
    {
        private static SDL_Window* window;
        private static SDL_Renderer* renderer;
        private static float frame;

        public static void Main()
        {
            if (!SDL_InitSubSystem(SDL_InitFlags.SDL_INIT_VIDEO))
            {
                Console.Error.WriteLine($"SDL_InitSubSystem failed: {SDL_GetError()}");
                return;
            }

            window = SDL_CreateWindow("SDL3-CS Browser"u8, 640, 480, 0);
            if (window == null)
            {
                Console.Error.WriteLine($"SDL_CreateWindow failed: {SDL_GetError()}");
                return;
            }

            renderer = SDL_CreateRenderer(window, (Utf8String)null);
            if (renderer == null)
            {
                Console.Error.WriteLine($"SDL_CreateRenderer failed: {SDL_GetError()}");
                return;
            }

            Console.WriteLine($"SDL revision: {SDL_GetRevision()}");
        }

        [JSExport]
        public static void UpdateFrame()
        {
            if (renderer == null)
                return;

            SDL_PumpEvents();

            SDL_SetRenderDrawColorFloat(renderer, SDL_sinf(frame) / 2 + 0.5f, SDL_cosf(frame) / 2 + 0.5f, 0.3f, 1.0f);
            SDL_RenderClear(renderer);
            SDL_RenderPresent(renderer);

            frame += 0.015f;
        }
    }
}
