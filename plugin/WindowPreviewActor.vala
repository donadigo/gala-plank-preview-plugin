
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
    public class WindowPreviewActor : Clutter.Actor
    { 
        const float MAX_PREVIEW_WIDTH = 300;
        const float MAX_PREVIEW_HEIGHT = 150;
        const int SPACING = 24;

        public WindowManager wm { get; construct; }  
        public signal void closed ();

        public bool is_hovered { get; private set; default = false; }

        Clutter.Actor container;

        uint close_timeout_id;

        construct 
        {
            background_color = { 255, 0, 0, 50 };

            reactive = true;
            container = new Clutter.Actor ();
            add_child (container);

            float screen_width, screen_height;
            wm.get_screen ().get_size (out screen_width, out screen_height);
            set_size (screen_width, screen_height);
            set_position (0, 0);
        }

        public WindowPreviewActor (WindowManager wm)
        {
            Object (wm: wm);
        }

        public override bool enter_event (Clutter.CrossingEvent event)
        {
            if (close_timeout_id > 0U) {
                Source.remove (close_timeout_id);
                close_timeout_id = 0U;
            }

            is_hovered = true;
            return false;
        }

        public override bool leave_event (Clutter.CrossingEvent event)
        {
            close_timeout_id = Timeout.add (300, () => {
                close_timeout_id = 0U;
                is_hovered = false;
                close ();
                return false;
            });

            return false;
        }

        public void close ()
        {
            closed ();
            destroy ();
        }

        public override bool button_press_event (Clutter.ButtonEvent event)
        {
            if (event.button != 1) {
                return false;
            }
            
            close ();
            return true;
        }

        public bool set_application (Bamf.Application app)
        {
            var xids = app.get_xids ();
            if (xids.length < 1) {
                return false;
            }

            unowned List<weak Meta.WindowActor>? actors = Meta.Compositor.get_window_actors (wm.get_screen ());

            container.remove_all_children ();
            container.width = 0;
            for (int i = 0; i < xids.length; i++) {
                uint32 xid = xids.index (i);
                unowned Meta.WindowActor? actor = find_actor_for_xid (actors, xid);
                if (actor == null) {
                    continue;
                }
                
                var clone = new ScaledWindowClone (actor, MAX_PREVIEW_WIDTH, MAX_PREVIEW_HEIGHT);

                container.width += clone.width;
                container.add_child (clone);
            }

            reallocate ();

            return true;
        }

        public void set_preview_position (int x, int y)
        {
            set_position (x - container.width / 2, y - container.height);
            set_size (container.width, container.height);
        }

        void reallocate ()
        {
            var children = container.get_children ();

            float offset = 0;

            uint child_count = children.length ();
            for (int i = 0; i < child_count; i++) {
                int spacing;
                if (i != 0) {
                    spacing = SPACING;
                } else {
                    spacing = 0;
                }

                var child = (ScaledWindowClone)children.nth_data (i);
                child.x = offset + spacing;
                offset += child.width + spacing;
            }
        }

        static unowned Meta.WindowActor? find_actor_for_xid (List<weak Meta.WindowActor> actors, uint32 xid)
        {
            for (int i = 0; i < actors.length (); i++) {
                unowned Meta.WindowActor actor = actors.nth_data (i);
                if (actor.get_meta_window ().get_xwindow () == xid) {
                    return actor;
                }
            }

            return null;
        }
    }    
}