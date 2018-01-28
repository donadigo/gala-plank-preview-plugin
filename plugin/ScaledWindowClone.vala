//
//  Copyright (C) 2017 Adam Bieńkowski
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

namespace Gala
{
    public class ScaledWindowClone : Clutter.Actor
    {
        public Meta.WindowActor window_actor { get; construct; }
        public float max_width { get; construct; }
        public float max_height { get; construct; }

        Clutter.Actor clone;

        construct
        {
            clone = new Clutter.Clone (window_actor.get_texture ());
            add_effect (new ShadowEffect (8, 2));

            reactive = true;

            update_size ();
            add_child (clone);
        }

        public ScaledWindowClone (Meta.WindowActor window_actor, float max_width, float max_height)
        {
            Object (window_actor: window_actor, max_width: max_width, max_height: max_height);
        }

        void get_clone_size (out float width, out float height)
        {
            var clip = clone.clip_rect;
            width = clip.get_width () * (float)clone.scale_x;
            height = clip.get_height () * (float)clone.scale_y;
        }

        void update_clone_clip ()
        {
            var rect = window_actor.get_meta_window ().get_frame_rect ();

            float width, height;
            calculate_aspect_ratio_size_fit (rect.width, rect.height, max_width, max_height, out width, out height);

            float width_scale = width / rect.width;
            float height_scale = height / rect.height; 

            float x_offset = rect.x - window_actor.x;
            float y_offset = rect.y - window_actor.y;

            clone.set_clip (x_offset, y_offset, rect.width, rect.height);
            clone.set_position (-x_offset * width_scale, -y_offset * height_scale);
            clone.set_scale (width_scale, height_scale);
        }

        void update_size ()
        {
            update_clone_clip ();

            float _width, _height;
            get_clone_size (out _width, out _height);

            set_size (_width, _height);
        }

        // From https://opensourcehacker.com/2011/12/01/calculate-aspect-ratio-conserving-resize-for-images-in-javascript/
        static void calculate_aspect_ratio_size_fit (float src_width, float src_height, float max_width, float max_height,
            out float width, out float height)
        {
            float ratio = float.min (max_width / src_width, max_height / src_height);
            width = src_width * ratio;
            height = src_height * ratio;
        }        
    }
}