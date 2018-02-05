
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
        const int PREVIEW_MARGIN = 12;
        const int DOCK_OFFSET = 12;

        public WindowManager wm { get; construct; }  
        public signal void closed ();

        public bool is_hovered { get; private set; default = false; }

        Clutter.Actor container;

        int px;
        int py;
        uint close_timeout_id;

        construct 
        {
            background_color = { 255, 255, 255, 240 };

            reactive = true;
            container = new Clutter.Actor ();
            container.set_pivot_point (0.5f, 0.5f);
            add_child (container);
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
            hide ();
        }

        public void open ()
        {
            y += 20;
            opacity = 0;

            save_easing_state ();
            set_easing_duration (200);
            y -= 20;
            opacity = 255;
            restore_easing_state ();
        }

        public override void hide ()
        {
            save_easing_state ();
            set_easing_duration (200);
            y += 20;
            opacity = 0;

            restore_easing_state ();
            ulong completed_id = 0UL;
            completed_id = transitions_completed.connect (() => {
                disconnect (completed_id);
                destroy ();
            });
        }

        //  public override bool button_press_event (Clutter.ButtonEvent event)
        //  {
        //      if (event.button != 1) {
        //          return false;
        //      }
            
        //      close ();
        //      return true;
        //  }

        public bool set_application (Bamf.Application app)
        {
            var xids = app.get_xids ();
            if (xids.length < 1) {
                return false;
            }

            unowned List<weak Meta.WindowActor>? actors = Meta.Compositor.get_window_actors (wm.get_screen ());

            container.remove_all_children ();
            //  container.width = 0;
            for (int i = 0; i < xids.length; i++) {
                uint32 xid = xids.index (i);
                unowned Meta.WindowActor? actor = find_actor_for_xid (actors, xid);
                if (actor == null) {
                    continue;
                }
                
                var clone = new ScaledWindowClone (actor, MAX_PREVIEW_WIDTH, MAX_PREVIEW_HEIGHT);
                clone.activated.connect (() => close ());
                clone.removed.connect (() => {
                    container.remove (clone);
                    clone.destroy ();
                    reallocate ();
                    set_preview_position (px, py);

                    if (container.get_n_children () == 0) {
                        close ();
                    }
                });

                container.add_child (clone);
            }

            reallocate ();

            return true;
        }

        public void set_preview_position (int x, int y)
        {
            px = x;
            py = y;

            float width = container.width + PREVIEW_MARGIN * 2;
            float height = container.height + PREVIEW_MARGIN * 2;

            save_easing_state ();
            set_easing_duration (200);

            set_position (x - width / 2, y - height - DOCK_OFFSET);
            set_size (width, height);

            container.set_position (width / 2 - container.width / 2 , height / 2 - container.height / 2);
            restore_easing_state ();
        }

        void update_container_width ()
        {
            float width = 0;
            var children = container.get_children ();

            for (int i = 0; i < children.length (); i++) {
                width += children.nth_data (i).get_width ();

                if (i != 0) {
                    width += SPACING;
                }
            }

            container.width = width;
        }

        void reallocate ()
        {
            update_container_width ();
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