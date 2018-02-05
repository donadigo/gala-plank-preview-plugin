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
        const int HEADER_HEIGHT = 30;
        const int CLOSE_WIDTH = 20;

        public Meta.WindowActor window_actor { get; construct; }
        public float max_width { get; construct; }
        public float max_height { get; construct; }

        public signal void activated ();
        public signal void removed ();

        Clutter.Actor clone;
        Clutter.Actor container;
        Clutter.Text title;
        Clutter.Texture close_button;

        construct
        {
            clone = new Clutter.Clone (window_actor.get_texture ());

            container = new Clutter.Actor ();
            container.reactive = true;
            container.set_position (0, HEADER_HEIGHT);
            container.add_child (clone);
            container.add_effect (new ShadowEffect (8, 2));

            title = new Clutter.Text ();
            //  title.color = { 255, 255, 255, 255 };
            title.cursor_size = 3;
            title.ellipsize = Pango.EllipsizeMode.END;
            title.set_position (CLOSE_WIDTH, 0);
            title.text = window_actor.get_meta_window ().get_title ();
            title.use_markup = true;
            title.line_wrap_mode = Pango.WrapMode.WORD_CHAR;

            reactive = true;

            // TODO: don't hardcode this
            close_button = new Clutter.Texture.from_file ("/usr/share/icons/elementary/actions/symbolic/window-close-symbolic.svg");
            close_button.reactive = true;

            var close_action = new Clutter.ClickAction ();
            close_action.clicked.connect (() => {
                window_actor.get_meta_window ().@delete (Gdk.CURRENT_TIME);
                removed ();
            });
            
            close_button.add_action (close_action);

            update_size ();
            add_child (container);
            add_child (title);
            add_child (close_button);

            var activate_action = new Clutter.ClickAction ();
            activate_action.clicked.connect (on_activate);

            container.add_action (activate_action);

            var window = window_actor.get_meta_window ();
            window.notify["title"].connect (update_title);
            window.unmanaged.connect (() => removed ());
        }

        public ScaledWindowClone (Meta.WindowActor window_actor, float max_width, float max_height)
        {
            Object (window_actor: window_actor, max_width: max_width, max_height: max_height);
        }


        void update_title ()
        {
            title.text = Markup.escape_text (window_actor.get_meta_window ().get_title ());
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

            float width, height;
            get_clone_size (out width, out height);

            container.set_size (width, height);
            set_size (width, HEADER_HEIGHT + height);

            title.width = width - CLOSE_WIDTH;
        }

        void on_activate ()
        {
            var window = window_actor.get_meta_window ();
            var workspace = window.get_workspace ();
            var screen = window.get_screen ();
            if (workspace.index () != screen.get_active_workspace_index ()) {
                workspace.activate_with_focus (window, screen.get_display ().get_current_time ());
            } else {
                window.activate (screen.get_display ().get_current_time ());
            }
            
            activated ();
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